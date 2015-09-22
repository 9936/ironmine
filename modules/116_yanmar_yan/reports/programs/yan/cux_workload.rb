class Yan::CuxWorkload < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    start_date = params[:start_date]
    unless params[:start_date].present?
      start_date = "1970-1-1"
    end

    end_date = params[:end_date]
    unless params[:end_date].present?
      end_date = "2099-1-1"
    end

    system = ""
    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      params[:external_system_id].each do |s|
        temp = "'" + s + "',"
        system << temp
      end
    else
      sys = Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id)
      sys.each do |s|
        temp = "'" + s + "',"
        system << temp
      end
    end
    # delete the last  ,
    system = system[0, system.length-1]

    sql = %Q(SELECT
                iir.request_number,
                iir.title,
                iict.`name` 'Categoty',
                ip.full_name 'Supporter',
                iist.`name` 'Status',
                iiw.start_time 'Start Time',
                iiw.end_time 'End Time',
                iiw.people_count_c,
                iiw.real_processing_time,
                ROUND(iiw.real_processing_time/60, 2),
                iiw.people_count_t,
                iiw.real_processing_time_t,
                ROUND(iiw.real_processing_time_t/60, 2),
                ROUND(iiw.subtotal_processing_time/60, 2)
              FROM
                icm_incident_workloads iiw
              LEFT OUTER JOIN icm_incident_requests iir ON (iir.id = iiw.incident_request_id)
              LEFT OUTER JOIN icm_incident_categories_tl iict ON (
                iir.incident_category_id = iict.incident_category_id
                AND iict.`language` = 'en'
              )
              LEFT OUTER JOIN irm_people ip ON (iiw.created_by = ip.id)
              LEFT OUTER JOIN icm_incident_statuses_tl iist ON (
                iir.incident_status_id = iist.incident_status_id
                AND iist.`language` = 'en'
              )
              WHERE
                  iir.submitted_date >= '#{start_date}' AND iir.submitted_date <= '#{end_date}'
                AND iir.external_system_id IN (#{system})
              ORDER BY
                iir.request_number ASC)

    headers = [
        "Incident No",
        "incident Title",
        "Category",
        "Supporter",
        "Status",
        "Start Time",
        "End Time",
        "Number of Consultants",
        "Con-Workload(min)",
        "Con-Workload(H)",
        "Number of Technicians",
        "Tech-Workload(min)",
        "Tech-Workload(H)",
        "Subtotal(H)"]

    result = ActiveRecord::Base.connection.execute(sql)
    datas = []
    result.each do |s|
      data = Array.new(14)
      data[0] = s[0]
      data[1] = s[1]
      data[2] = s[2]
      data[3] = s[3]
      data[4] = s[4]
      data[5] = s[5].strftime('%Y-%m-%d %H:%M:%S').to_s
      data[6] = s[6].strftime('%Y-%m-%d %H:%M:%S').to_s
      data[7] = s[7]
      data[8] = s[8]
      data[9] = s[9]
      data[10] = s[10]
      data[11] = s[11]
      data[12] = s[12]
      data[13] = s[13]

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