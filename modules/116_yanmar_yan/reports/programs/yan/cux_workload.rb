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
                iiw.people_count_t,
                iiw.real_processing_time_t,
                iiw.subtotal_processing_time
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
        "Workload",
        "Number of Technicians",
        "Workload",
        "Subtotal"]

    result = ActiveRecord::Base.connection.execute(sql)
    datas = []
    result.each do |s|
      data = Array.new(12)
      data[0] = s[0]
      data[1] = s[1]
      data[2] = s[2]
      data[3] = s[3]
      data[4] = s[4]
      data[5] = s[5].strftime('%Y-%m-%d %H:%M:%S').to_s
      data[6] = s[6].strftime('%Y-%m-%d %H:%M:%S').to_s
      data[7] = s[7]

      if s[8] > 60
        hour = (s[8]/60).to_i
        min = (s[8] - s[8]/60).to_i
        data[8] = hour.to_s + "h " + min.to_s + "m"
      else
        data[8] = s[8].to_s + "m"
      end

      data[9] = s[9]

      if s[10] > 60
        hour = (s[10]/60).to_i
        min = (s[10] - s[10]/60).to_i
        data[10] = hour.to_s + "h " + min.to_s + "m"
      else
        data[10] = s[10].to_s + "m"
      end

      if s[11] > 60
        hour = (s[11]/60).to_i
        min = (s[11] - s[11]/60).to_i
        data[11] = hour.to_s + "h " + min.to_s + "m"
      else
        data[11] = s[11].to_s + "m"
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