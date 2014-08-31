class Hli::PendingRequestsDetail < Irm::ReportManager::ReportBase
  def data(params={})
    language = Irm::Person.current.language_code
    params||={}

    statis = Icm::IncidentRequest.list_all.enabled.where("incident_status.incident_status_code NOT IN ('NEW', 'CLOSE', 'DONE')")

    if params[:hotline].present?
      statis = statis.where("#{Icm::IncidentRequest.table_name}.hotline = ?", params[:hotline])
    end


    if params[:external_system_name].present?
      system = Irm::ExternalSystemsTl.where("system_name IN (?)", params[:external_system_name].split(',') + [""])
      external_system_id = system.collect(&:external_system_id) if system.any?
      statis = statis.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", external_system_id + [])
    elsif params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
    end

    #if params[:start_date].present?
    #  statis = statis.where("DATE_FORMAT(submitted_date,'%Y-%m-%d') = ?", Date.strptime("#{params[:start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    #end

    datas = []
    headers = Array.new(10)

    statis.order("#{Icm::IncidentRequest.table_name}.request_number + 0 ASC").each do |sp|
      data = Array.new(10)
      data[0] = sp[:request_number]
      data[1] = sp[:external_system_name]
      data[2] = sp[:requested_name]
      data[3] = sp[:supporter_name]
      data[4] = sp[:priority_name]
      data[5] = sp[:impact_range_name]
      data[6] = sp[:submitted_date]
      data[7] = sp[:last_response_date]
      data[8] = sp[:title]
      data[9] = sp[:incident_status_name]

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