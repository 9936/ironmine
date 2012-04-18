class HighestPriorityIncidents < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    incident_request_table = Icm::IncidentRequest.table_name

    statis = Icm::IncidentRequest.select("#{incident_request_table}.external_system_id, count(1) amount")
    external_systems = Irm::ExternalSystem.multilingual
    if params[:year].present? && params[:month].present?
      statis = statis.where("date_format(#{incident_request_table}.submitted_date, '%Y-%m') = ?", Date.strptime("#{params[:year]}-#{params[:month]}", '%Y-%m').strftime("%Y-%m"))
    end

    if params[:external_system_id].present? &&
        params[:external_system_id].size > 0 &&
        params[:external_system_id][0].present?
      statis = statis.where("external_system_id IN (?)", params[:external_system_id] + [])
      external_systems = external_systems.where("#{Irm::ExternalSystem.table_name}.id IN (?)", params[:external_system_id] + [])
    end

    datas = []
    headers = [I18n.t(:label_date),
               I18n.t(:label_highest_priority_incident_hightest_amount),
               I18n.t(:label_total_amount),
               I18n.t(:label_percentage)]

    external_systems.each do |e|
      data = Array.new(4)
      data[0] = e[:system_name]
      data[1] = statis.
          where("#{incident_request_table}.external_system_id = ?", e.id).
          where("#{incident_request_table}.priority_id = (SELECT ip.id FROM icm_priority_codes ip ORDER BY weight_values ASC LIMIT 0,1) ").
          group("#{incident_request_table}.external_system_id")
      data[1] = data[1].any? ? data[1].first[:amount] : 0
      data[2] = statis.where("#{incident_request_table}.external_system_id = ?", e.id).
                group("#{incident_request_table}.external_system_id")
      data[2] = data[2].any? ? data[2].first[:amount] : 0
      percent = data[2] == 0 ? 0.to_f : (((data[1].to_f / data[2].to_f).to_f * 100 * 100).round / 100.0).to_f
      if percent == 0.to_f
        percent = 0
      end
      data[3] = percent.to_s + "%"
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