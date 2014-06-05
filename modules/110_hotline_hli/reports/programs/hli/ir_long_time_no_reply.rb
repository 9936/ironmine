class Hli::IrLongTimeNoReply < Irm::ReportManager::ReportBase
  def data(params={})
    close_status = Icm::IncidentStatus.where("close_flag = ?", "Y").collect(&:id)
    params||={}

    statis = Icm::IncidentRequest.
        select_all.enabled.
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_priority(I18n.locale).
        where("#{Icm::IncidentRequest.table_name}.incident_status_id NOT IN (?)", close_status).
        with_external_system(I18n.locale).order("(#{Icm::IncidentRequest.table_name}.last_response_date + 0) DESC")

    if params[:long_time].present?
      statis = statis.where("date_format(last_response_date,'%Y-%m-%d') < ?",
                            (Time.now - params[:long_time].to_i.day).strftime("%Y-%m-%d"))
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
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_report_request_submit_date),
               I18n.t(:label_report_request_last_updated),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_summary),
               I18n.t(:label_icm_incident_request_incident_status_code),
               "持续时间"
               #I18n.t(:label_report_incident_request_journal)
               ]

    statis.each do |s|
      data = Array.new(11)
      data[0] = s[:request_number]
      data[1] = s[:external_system_name]
      data[2] = s[:requested_name]
      data[3] = s[:supporter_name]
      data[4] = s[:priority_name]
      data[5] = s[:submitted_date].strftime('%F %T')
      data[6] = s[:last_response_date].strftime('%F %T')
      data[7] = s[:title]
      data[8] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
      #data[8] = ""
      data[9] = s[:incident_status_name]
      #data[10] = s[:total_processing_time]
      data[10] = (Time.now - DateTime.parse(s[:last_response_date])).days
      #s.concat_journals
#      journals = Icm::IncidentJournal.
#          select("ps.full_name reply_name, #{Icm::IncidentJournal.table_name}.message_body").
#          joins(",#{Irm::Person.table_name} ps ").
#          where(:incident_request_id => s[:id]).
#          where(:reply_type => 'SUPPORTER_REPLY').
#          where("ps.id = #{Icm::IncidentJournal.table_name}.replied_by")
      messages = ''
#      journals.each do |t|
#      messages << s.concat_journals_with_text
#      end

      #data[11] = messages
      #data[11] = ""
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