class Hli::PendingRequestsBySupporter < Irm::ReportManager::ReportBase
  def data(params={})
    language = Irm::Person.current.language_code
    params||={}

    statis = Icm::IncidentRequest.
        select("#{Icm::IncidentRequest.table_name}.support_person_id, pp.full_name full_name").enabled.
        joins(",#{Irm::Person.table_name} pp").
        joins(",#{Icm::IncidentStatus.table_name} iss").
        where("iss.id = #{Icm::IncidentRequest.table_name}.incident_status_id").
        where("iss.incident_status_code NOT IN ('NEW', 'CLOSE', 'DONE')").
        where("pp.id = #{Icm::IncidentRequest.table_name}.support_person_id")

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
    headers = Array.new(2)

    statis.group("support_person_id").each do |sp|
      data = Array.new(2)
      data[0] = sp[:full_name]
      data[1] = ""
      requests_detail = statis.
          select("#{Icm::IncidentRequest.table_name}.request_number request_number").
          select("DATEDIFF(now(), #{Icm::IncidentRequest.table_name}.submitted_date) duration").
          where("#{Icm::IncidentRequest.table_name}.support_person_id = ?", sp[:support_person_id])
      requests_detail.each do |ir|
        data[1] << ir[:request_number] + "-" + ir[:duration].to_s
        data[1] << ',' unless requests_detail.last == ir
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