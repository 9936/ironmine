class Hli::LastTenDateRequestCount < Irm::ReportManager::ReportBase
  def data(params={})
    language = Irm::Person.current.language_code
    params||={}

    statis = Icm::IncidentRequest.select("DATE_FORMAT(submitted_date,'%Y-%m-%d') count_date").where("1=1")

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

    if params[:start_date].present?
      statis = statis.where("DATE_FORMAT(submitted_date,'%Y-%m-%d') > ?", (Date.strptime("#{params[:start_date]}", '%Y-%m-%d') - 10.day).strftime("%Y-%m-%d"))
    end

    datas = []
    headers = Array.new(2)

    statis.select("COUNT(1) total_count").group("DATE_FORMAT(submitted_date,'%Y-%m-%d')").each do |sp|
      data = Array.new(2)
      data[0] = sp[:count_date]
      data[1] = sp[:total_count]

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