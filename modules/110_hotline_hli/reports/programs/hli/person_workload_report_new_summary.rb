class Hli::PersonWorkloadReportNewSummary < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        enabled.
        with_external_system(I18n.locale).
        joins(",#{Icm::IncidentWorkload.table_name} iw").
        joins(", #{Irm::Person.table_name} ip1").
        where("ip1.id = iw.person_id").
        select("IF(ip1.email_address LIKE '%hand-china.com', 'Support', 'Customer') person_type, SUM(iw.real_processing_time) sum_workload_cost").
        select("date_format(iw.created_at, '%Y-%m') workload_date").
        where("iw.incident_request_id = #{Icm::IncidentRequest.table_name}.id").
        group("#{Icm::IncidentRequest.table_name}.external_system_id, IF(ip1.email_address LIKE '%hand-china.com', 'Support', 'Customer'), date_format(iw.created_at, '%Y-%m')").
        order("date_format(iw.created_at, '%Y-%m') ASC")
    if params[:end_date].present?
      statis = statis.where("date_format(iw.created_at, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    start_date = params[:start_date]
    unless params[:start_date].present?
       start_date = "1970-1-1"
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", params[:external_system_id] + [])
    else
      current_acc_systems = Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id)
      statis = statis.where("#{Icm::IncidentRequest.table_name}.external_system_id IN (?)", current_acc_systems + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    statis = statis.where("date_format(iw.created_at, '%Y-%m-%d') >= ?", Date.strptime("#{start_date}", '%Y-%m-%d').strftime("%Y-%m-%d"))

    datas = []
    headers = [
               "Project",
               "Customer/Support",
               "Workload Month",
               "Sum Workload"
               ]
    statis.each do |s|
      data = Array.new(4)

      data[0] = s[:external_system_name]
      data[1] = s[:person_type]
      data[2] = s[:workload_date]
      data[3] = s[:sum_workload_cost]

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
