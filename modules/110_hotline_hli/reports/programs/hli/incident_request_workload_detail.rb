class Hli::IncidentRequestWorkloadDetail < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.
        enabled.
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_priority(I18n.locale).
        with_external_system(I18n.locale).
        with_worklaod.
        order("(#{Icm::IncidentRequest.table_name}.request_number + 0) ASC")

    if params[:start_date].present? && params[:end_date].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') >= ?",
                            Date.strptime("#{params[:start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?",
                            Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    if params[:hotline].present?
      statis = statis.where("icm_incident_requests.hotline = ?", params[:hotline])
    else
      statis = statis.where("icm_incident_requests.hotline = ?", Irm::Constant::SYS_YES)
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
    else
      statis = statis.where("external_system.id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    if params[:support_person_id].present? && params[:support_person_id].size > 0 && params[:support_person_id][0].present?
      statis = statis.where("iw.person_id IN (?)", params[:support_person_id] + [])
    else
      nil
    end

    datas = []
    headers = [I18n.t(:label_report_number),
               I18n.t(:label_icm_incident_request_support_person),
               I18n.t(:label_report_request_workload),
               I18n.t(:label_project),
               I18n.t(:label_reporter),
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_report_request_submit_date),
               I18n.t(:label_report_request_last_updated),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_summary),
               I18n.t(:label_icm_incident_request_incident_status_code)
               ]

    statis.each do |s|
      data = Array.new(11)
      data[0] = s[:request_number]
      data[1] = s[:workload_person_name]
      data[2] = s[:workload_processing_time]
      data[3] = s[:external_system_name]
      data[4] = s[:requested_name]
      data[5] = s[:priority_name]
      data[6] = s[:submitted_date].strftime('%F %T')
      data[7] = s[:last_response_date].strftime('%F %T')
      data[8] = s[:title]
      data[9] = ""
      data[9] = Irm::Sanitize.sanitize(s[:summary],"")  unless s[:summary].nil?
      data[10] = s[:incident_status_name]
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