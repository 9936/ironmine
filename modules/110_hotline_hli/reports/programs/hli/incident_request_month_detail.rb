class Hli::IncidentRequestMonthDetail < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.enabled.with_workloads.
        with_category(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_contact.with_close_reason(I18n.locale).with_close_reply.
        with_supporter(I18n.locale).
        with_priority(I18n.locale).
        with_external_system(I18n.locale).order("(#{Icm::IncidentRequest.table_name}.request_number + 0) ASC")

    if params[:start_date].present? && params[:end_date].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    if params[:close_start_date].present? && params[:close_end_date].present?
      statis = statis.where("icm_incident_requests.incident_status_id = ?", Icm::IncidentStatus.where("incident_status_code = ?", 'CLOSE').first.id);
      statis = statis.where("date_format(icm_incident_requests.last_response_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:close_start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
      statis = statis.where("date_format(icm_incident_requests.last_response_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:close_end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    if params[:hotline].present?
      statis = statis.where("icm_incident_requests.hotline = ?", params[:hotline])
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
    else
      statis = statis.where("external_system.id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    datas = []
    headers = [I18n.t(:label_report_number),
               I18n.t(:label_project),
               I18n.t(:label_reporter),
               I18n.t(:label_report_incident_request_support),
               I18n.t(:label_icm_incident_request_urgence_code),
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_icm_incident_request_incident_sub_category),
               I18n.t(:label_report_request_submit_date),
               I18n.t(:label_report_request_last_updated),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_summary),
               I18n.t(:label_icm_incident_request_contact),
               I18n.t(:label_icm_incident_request_contact_way),
               I18n.t(:label_icm_incident_request_client_info),
               I18n.t(:label_icm_incident_request_incident_status_code),
               I18n.t(:label_report_request_workload), "Close Reason", "Close Message",
               I18n.t(:label_report_estimated_date)
               ]
    headers << I18n.t(:label_report_incident_request_journal) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
    array_size = 19
    array_size = array_size + 1 if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
    statis.each do |s|
      data = Array.new(array_size)
      data[0] = s[:request_number]
      data[1] = s[:external_system_name]
      data[2] = s[:requested_name]
      data[3] = s[:supporter_name]
      data[4] = s[:urgence_name]
      data[5] = s[:priority_name]
      data[6] = s[:incident_category_name]
      data[7] = s[:incident_sub_category_name]
      data[8] = s[:submitted_date].strftime('%F %T')
      data[9] = s[:last_response_date].strftime('%F %T')
      data[10] = s[:title]
      data[11] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
      data[12] = s[:contact_name]
      data[13] = s[:contact_number]
      data[14] = s[:client_info]
      data[15] = s[:incident_status_name]
      data[16] = s[:total_processing_time]

      data[17] = s[:close_reason_name]
      data[18] = s[:close_message]
      data[19] = s[:estimated_date]

      if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
        messages = ''
        messages << s.concat_journals_with_text
        messages = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(messages,""))
        data[19] = messages
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