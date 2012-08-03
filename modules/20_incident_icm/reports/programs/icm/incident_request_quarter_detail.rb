class Icm::IncidentRequestQuarterDetail < Irm::ReportManager::ReportBase
  def data(params={})
    language = Irm::Person.current.language_code
    params||={}
    datas = []

    statis = Icm::IncidentRequest.
      select_all.
      with_requested_by(language).
      with_incident_status(language).
      with_supporter(language).
      with_priority(language).
      with_incident_status(language).
      with_external_system(language).order("#{Icm::IncidentRequest.table_name}.request_number ASC")

    if params[:year].present? && params[:quarter].present?
      s_base =  (params[:quarter].to_i - 1) * 3
      quarters = [Date.strptime("#{params[:year]}-#{(s_base + 1).to_s}", '%Y-%m').strftime("%Y-%m"),
                 Date.strptime("#{params[:year]}-#{(s_base + 2).to_s}", '%Y-%m').strftime("%Y-%m"),
                 Date.strptime("#{params[:year]}-#{(s_base + 3).to_s}", '%Y-%m').strftime("%Y-%m")]
      statis = statis.where(%Q((date_format(icm_incident_requests.submitted_date, '%Y-%m') IN (?))
                                OR
                                (EXISTS(SELECT * FROM #{Icm::IncidentJournal.table_name} ijj
                                WHERE ijj.reply_type = 'CLOSE'
                                AND ijj.incident_request_id = #{Icm::IncidentRequest.table_name}.id
                                AND date_format(ijj.created_at, '%Y-%m') <= ?
                                AND date_format(ijj.created_at, '%Y-%m') >= ?))), quarters + [], quarters[2], quarters[0])
      statis = statis.joins("LEFT OUTER JOIN #{Icm::IncidentJournal.table_name} ij ON ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.reply_type = 'CLOSE'")
      statis = statis.select("ij.created_at close_date")
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
    end

    if params[:incident_status_id].present? && params[:incident_status_id].size > 0 && params[:incident_status_id][0].present?
      statis = statis.where("#{Icm::IncidentRequest.table_name}.incident_status_id IN (?)", params[:incident_status_id] + [])
    end

    headers = [I18n.t(:label_icm_incident_request_request_number),
               I18n.t(:label_irm_external_system),
               I18n.t(:label_icm_incident_request_requested_by),
               I18n.t(:label_report_incident_request_support),
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_icm_incident_request_submitted_date),
               I18n.t(:label_report_last_updated),
               I18n.t(:label_report_month),
               I18n.t(:label_report_continued_day),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_incident_status_code),
               I18n.t(:label_report_processing_time)]

    statis.each do |s|
      data = Array.new(12)
      data[0] = s[:request_number]
      data[1] = s[:external_system_name]
      data[2] = s[:requested_name]
      data[3] = s[:supporter_name]
      data[4] = s[:priority_name]
      data[5] = s[:submitted_date].strftime("%F %T")
      data[6] = s[:updated_at] > s[:last_response_date] ? s[:updated_at].strftime("%F %T") : s[:last_response_date].strftime("%F %T")
      data[7] = s[:submitted_date].strftime("%Y-%m")
      data[8] = s[:close_date].present? ? (DateTime.parse(s[:close_date].to_s) - DateTime.parse(data[5].to_s)).to_i : (DateTime.now - DateTime.parse(data[5].to_s)).to_i + 1
      data[9] = s[:title]
      data[10] = s[:incident_status_name]
      data[11] = s[:real_processing_time]

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