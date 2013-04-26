class Hli::PersonWorkloadReport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.
        enabled.
        with_category(I18n.locale).
        with_close_reason(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_submitted_by.
        with_priority(I18n.locale).
        with_external_system(I18n.locale).
        joins(",#{Icm::IncidentWorkload.table_name} iw").
        joins(" LEFT OUTER JOIN #{Irm::LookupValue.view_name} lv ON lv.lookup_type = 'WORKLOAD_TYPE' AND lv.lookup_code = iw.workload_type AND lv.language = '#{I18n.locale}'").
        joins(", #{Irm::Person.table_name} ip1").
        where("ip1.id = iw.person_id").
        select("ip1.full_name supporter_name, ip1.id real_support_person_id").
        where("iw.incident_request_id = #{Icm::IncidentRequest.table_name}.id").
        select("lv.meaning workload_type_name, iw.real_processing_time real_processing_time").
        order("(#{Icm::IncidentRequest.table_name}.submitted_date) ASC")
    if params[:end_date].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    start_date = params[:start_date]
    unless params[:start_date].present?
       start_date = "1970-1-1"
    end
    statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') >= ?", Date.strptime("#{start_date}", '%Y-%m-%d').strftime("%Y-%m-%d"))

    if params[:supporter_id].present? && params[:supporter_id].size > 0 && params[:supporter_id][0].present?
      statis = statis.where(%Q"iw.person_id IN (?)",
                            params[:supporter_id] + [])
    end

    if params[:hotline].present?
      statis = statis.where("icm_incident_requests.hotline = ?", params[:hotline])
    end

    unless Irm::Person.find(params[:running_person_id]).admin_flag.eql?(Irm::Constant::SYS_YES)
      current_acc_systems = Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id)
      statis = statis.where("external_system.id IN (?)", current_acc_systems + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    datas = []
    headers = [
               I18n.t(:label_icm_incident_request_request_number),
               I18n.t(:label_irm_project_name),
               I18n.t(:label_icm_incident_request_support_person),
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_icm_incident_request_incident_sub_category),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_submitted_date),
               I18n.t(:label_icm_incident_request_last_date),
               I18n.t(:label_icm_incident_request_incident_status_code),
               I18n.t(:label_icm_incident_journal_workload_type),
               I18n.t(:label_report_request_workload)
               ]

    headers << I18n.t(:label_report_incident_request_journal) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)

    statis.each do |s|
      data = Array.new(12)
      data = Array.new(13) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)

      data[0] = s[:request_number]
      data[1] = s[:external_system_name]
      data[2] = s[:supporter_name]
      data[3] = s[:priority_name]
      data[4] = s[:incident_category_name]
      data[5] = s[:incident_sub_category_name]
      data[6] = s[:title]
      data[7] = s[:submitted_date]
      data[8] = s[:last_response_date]
      data[9] = s[:incident_status_name]
      data[10] = s[:workload_type_name]
      data[11] = s[:real_processing_time]

      if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
        messages = ''
        messages << s.concat_journals_with_text(s[:real_support_person_id])
        messages = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(messages,""))
        data[12] = messages
      end

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
