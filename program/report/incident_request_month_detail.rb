class IncidentRequestMonthDetail < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_external_system(I18n.locale).order("#{Icm::IncidentRequest.table_name}.request_number ASC")

    if params[:year].present? && params[:month].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m') = ?", Date.strptime("#{params[:year]}-#{params[:month]}", '%Y-%m').strftime("%Y-%m"))
    end


    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
    end

    datas = []
    headers = [I18n.t(:label_icm_incident_request_request_number),
               I18n.t(:label_icm_incident_request_submitted_date),
               I18n.t(:label_icm_incident_request_last_date),
               I18n.t(:label_irm_external_system),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_requested_by),
               I18n.t(:label_icm_incident_request_incident_status_code),
               I18n.t(:label_report_incident_request_support),
               I18n.t(:label_report_incident_request_journal)]

    statis.each do |s|
      data = Array.new(9)
      data[0] = s[:request_number]
      data[1] = s[:submitted_date].strftime('%F %T')
      data[2] = s[:last_response_date].strftime('%F %T')
      data[3] = s[:external_system_name]
      data[4] = s[:title]
      data[5] = s[:requested_name]
      data[6] = s[:incident_status_name]
      data[7] = s[:supporter_name]

      s.concat_journals
#      journals = Icm::IncidentJournal.
#          select("ps.full_name reply_name, #{Icm::IncidentJournal.table_name}.message_body").
#          joins(",#{Irm::Person.table_name} ps ").
#          where(:incident_request_id => s[:id]).
#          where(:reply_type => 'SUPPORTER_REPLY').
#          where("ps.id = #{Icm::IncidentJournal.table_name}.replied_by")
      messages = ''
#      journals.each do |t|
        messages << s.concat_journals
        messages << "  "
#      end

      data[8] = messages
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