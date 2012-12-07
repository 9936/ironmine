class Htc::IrLongTimeNoReply < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.enabled.
        with_category(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_priority(I18n.locale).
        with_external_system(I18n.locale).
        order("(#{Icm::IncidentRequest.table_name}.last_response_date + 0) DESC")

    if params[:long_time].present?
      statis = statis.where("date_format(last_response_date,'%Y-%m-%d') < ?",
                            (Time.now - params[:long_time].to_i.day).strftime("%Y-%m-%d"))
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
    else
      statis = statis.where("external_system.id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    datas = []
    headers = [
               I18n.t(:label_icm_incident_request_submitted_date),
               I18n.t(:label_icm_incident_request_last_date),
               I18n.t(:label_icm_incident_request_request_number),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_summary),
               I18n.t(:label_irm_external_system),
               I18n.t(:label_icm_incident_request_requested_by),
               I18n.t(:label_icm_incident_request_support_person),
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_icm_incident_request_incident_sub_category),
               I18n.t(:label_icm_incident_request_incident_status_code)
               #I18n.t(:label_report_incident_request_journal)
               ]

    statis.each do |s|
      data = Array.new(12)
      data[0] = s[:submitted_date].strftime('%F %T')
      data[1] = s[:last_response_date].strftime('%F %T')
      data[2] = s[:request_number]
      data[3] = s[:title]
      data[4] = Irm::Sanitize.sanitize(s[:summary],"")  unless s[:summary].nil?
      data[5] = s[:external_system_name]
      data[6] = s[:requested_name]
      data[7] = s[:supporter_name]
      data[8] = s[:priority_name]
      data[9] = s[:incident_category_name]
      data[10] = s[:incident_sub_category_name]
      data[11] = s[:incident_status_name]
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