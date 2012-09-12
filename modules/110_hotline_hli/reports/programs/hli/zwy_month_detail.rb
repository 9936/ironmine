class Hli::ZwyMonthDetail < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.
        enabled.
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_category(I18n.locale).
        with_urgence(I18n.locale).
        with_external_system(I18n.locale).
        order("(#{Icm::IncidentRequest.table_name}.request_number + 0) ASC")

    if params[:start_date].present? && params[:end_date].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
    else
      statis = statis.where("external_system.id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    datas = []
    headers = [I18n.t(:label_report_number),
               I18n.t(:label_project),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_summary),
               I18n.t(:label_reporter),
               I18n.t(:label_report_incident_request_support),
               I18n.t(:label_icm_incident_request_urgence_code),
               I18n.t(:label_report_request_submit_date),
               I18n.t(:label_report_request_last_updated),
               I18n.t(:label_icm_incident_request_incident_status_code),
               I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_icm_incident_request_incident_sub_category),
               I18n.t(:label_icm_incident_request_estimated_date),
               I18n.t(:label_icm_incident_request_hotline)
               ]

    statis.each do |s|
      data = Array.new(14)
      data[0] = s[:request_number]
      data[1] = s[:external_system_name]
      data[2] = s[:title]
      data[3] = Irm::Sanitize.sanitize(s[:summary],"")  unless s[:summary].nil?
      data[4] = s[:requested_name]
      data[5] = s[:supporter_name]
      data[6] = s[:urgence_name]
      data[7] = s[:submitted_date].strftime('%F %T')
      data[8] = s[:last_response_date].strftime('%F %T')
      data[9] = s[:incident_status_name]
      data[10] = s[:incident_category_name]
      data[11] = s[:incident_sub_category_name]
      begin
        data[12] = s[:estimated_date].strftime('%F %T')
      rescue
        data[12] = ""
      end
      data[13] = s[:hotline]
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