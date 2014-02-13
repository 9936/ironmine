class Icm::IcmElapseDetail < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    #未选择应用系统,查询用户所有系统
    unless params[:external_system_id][0].present?
      params[:external_system_id]= Irm::Person.current.system_ids
    end

    external_system_ids="''"
    params[:external_system_id].each do |d|
      external_system_ids<<",'"+d+"'"
    end

    #statis = Icm::IncidentRequest.
    #    filter_system_ids(params[:external_system_id]).
    #    select_elapse.
    #    with_statuses(:zh).
    #    with_support_person.
    #    with_real_distance.
    #    with_elapse_support_group(:zh).
    #    order("request_number","status")

    elapse_info_sub_sql=%Q(SELECT t2.incident_request_id,t1.incident_status_id incident_status_id, t1.support_person_id support_person_id,
    t1.support_group_id support_group_id,SUM(t1.real_distance) real_distance
    FROM #{Icm::IncidentJournalElapse.table_name} t1
    JOIN #{Icm::IncidentJournal.table_name} t2 ON t1.incident_journal_id = t2.id
    GROUP BY t2.incident_request_id,t1.support_person_id , t1.incident_status_id , t1.support_group_id)


    ##组拼sql语句
    sql_str= "SELECT irq.request_number request_number,irq.submitted_date,irq.last_response_date,status.name status,
    people.full_name support_person,elapse_info.real_distance real_distance,igv.name support_group_name
    FROM (#{elapse_info_sub_sql}) elapse_info
        LEFT OUTER JOIN
    #{Icm::IncidentStatusesTl.table_name} status ON status.incident_status_id = elapse_info.incident_status_id AND status.language = '#{I18n.locale}'
        LEFT OUTER JOIN
    #{Irm::Person.table_name} people ON people.id = elapse_info.support_person_id
        LEFT OUTER JOIN
    #{Icm::SupportGroup.table_name} isg ON elapse_info.support_group_id = isg.id
        LEFT OUTER JOIN
    #{Irm::Group.view_name} igv ON isg.group_id = igv.id AND igv.language = '#{I18n.locale}'
        LEFT OUTER JOIN
    #{Icm::IncidentRequest.table_name} irq ON irq.id = elapse_info.incident_request_id"


    sql_str+=" where irq.external_system_id IN (#{external_system_ids})"


    if params[:submitted_start_date].present?
      sql_str += " and date_format(irq.submitted_date, '%Y-%m-%d') >= '#{Date.strptime("#{params[:submitted_start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d")}'"
    end

    if params[:submitted_ent_date].present?
      sql_str += " and date_format(irq.submitted_date, '%Y-%m-%d') <= '#{Date.strptime("#{params[:submitted_ent_date]}", '%Y-%m-%d').strftime("%Y-%m-%d")}'"
    end

    if params[:last_response_start_date].present?
      sql_str += " and date_format(irq.last_response_date, '%Y-%m-%d') >= '#{Date.strptime("#{params[:last_response_start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d")}'"
    end

    if params[:last_response_end_date].present?
      sql_str += " and date_format(irq.last_response_date, '%Y-%m-%d') <= '#{Date.strptime("#{params[:last_response_end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d")}'"
    end

    sql_str+=" ORDER BY request_number, status"

    results=Icm::IncidentRequest.find_by_sql(sql_str)
    datas = []

    headers = [
        I18n.t(:label_icm_incident_request_request_number_alias),
        I18n.t(:label_icm_incident_request_submitted_date),
        I18n.t(:label_icm_incident_request_last_response_date),
        I18n.t(:label_icm_incident_request_status),
        I18n.t(:label_icm_incident_request_support_person),
        I18n.t(:label_icm_incident_request_real_distance),
        I18n.t(:label_icm_incident_request_support_group_name)
    ]
    results.each do |s|
      data = Array.new(7)
      data[0] = s.attributes["request_number"]
      data[1] = s.attributes["submitted_date"].strftime("%Y-%m-%d") unless s.attributes["submitted_date"].nil?
      data[2] = s.attributes["last_response_date"].strftime("%Y-%m-%d") unless s.attributes["last_response_date"].nil?
      data[3] = s.attributes["status"]
      data[4] = s.attributes["support_person"]
      data[5] = (s.attributes["real_distance"].to_f/3600).round(2) unless s.attributes["real_distance"].nil?
      data[6] = s.attributes["support_group_name"]
      datas << data
    end
    {:datas=>datas,:headers=>headers,:params=>params}
  end

  def to_xls(params)
    columns = []

    result = data(params)

    result[:headers].each_with_index do |sh,index|
      columns << {:key=>index.to_s.to_sym,:label=>sh}
    end

    excel_data = []
    result[:datas].each_with_index do |data,index|
      excel_data << data.to_cus_hash
    end

    excel_data.to_xls(columns,{})
  end
end