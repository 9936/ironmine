class Yan::CuxTicketsListByCreationDate < Irm::ReportManager::ReportBase
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


    sql = %Q(
            SELECT
              iir.request_number AS 'Serial Number',
              iir.title AS 'Title',
              iir.summary AS 'Summary',
              iest.system_name AS 'System',
              ip1.full_name AS 'Requester',
              iict.`name` AS 'Category',
              iisct.`name` AS 'Subcategory',
              iist.`name` AS 'Status',
              ipct.`name` AS 'Priority',
              iuct.`name` AS 'Urgency',
              iirt.`name` 'Impact Range',
              igt.`name` AS 'Support Group',
              ip2.full_name AS 'Supporter',
              iir.submitted_date AS 'Submit Date',
              iir.estimated_date AS 'Estimate Date',
              iir.last_response_date AS 'Last Response Date',
              icrt.`name` AS 'Close Reason',
              ilvv.meaning AS 'Incident Report Source'
            FROM
              icm_incident_requests iir
            LEFT OUTER JOIN irm_external_systems_tl iest ON (
              iir.external_system_id = iest.external_system_id
              AND iest.`language` = 'en'
            )
            LEFT OUTER JOIN irm_people ip1 ON (iir.requested_by = ip1.id)
            LEFT OUTER JOIN icm_incident_categories_tl iict ON (
              iir.incident_category_id = iict.incident_category_id
              AND iict.`language` = 'en'
            )
            LEFT OUTER JOIN icm_incident_sub_categories_tl iisct ON (
              iir.incident_sub_category_id = iisct.incident_sub_category_id
              AND iisct.`language` = 'en'
            )
            LEFT OUTER JOIN icm_incident_statuses_tl iist ON (
              iir.incident_status_id = iist.incident_status_id
              AND iist.`language` = 'en'
            )
            LEFT OUTER JOIN icm_priority_codes_tl ipct ON (
              iir.priority_id = ipct.priority_code_id
              AND ipct.`language` = 'en'
            )
            LEFT OUTER JOIN icm_urgence_codes_tl iuct ON (
              iir.urgence_id = iuct.urgence_code_id
              AND iuct.`language` = 'en'
            )
            LEFT OUTER JOIN icm_impact_ranges_tl iirt ON (
              iir.impact_range_id = iirt.impact_range_id
              AND iirt.`language` = 'en'
            )
            LEFT OUTER JOIN icm_support_groups isg ON (iir.support_group_id = isg.id)
            LEFT OUTER JOIN irm_groups_tl igt ON (
              isg.group_id = igt.group_id
              AND igt.`language` = 'en'
            )
            LEFT OUTER JOIN irm_people ip2 ON (iir.support_person_id = ip2.id)
            LEFT OUTER JOIN icm_close_reasons_tl icrt ON (
              iir.close_reason_id = icrt.close_reason_id
              AND icrt.`language` = 'en'
            )
            LEFT OUTER JOIN irm_lookup_values_vl ilvv ON (
              iir.report_source_code = ilvv.lookup_code
              AND ilvv.`language` = 'en'
            )
            WHERE
                  iir.submitted_date >= '#{start_date}' AND iir.submitted_date <= '#{end_date}'
              AND iir.external_system_id IN (#{system})
            ORDER BY
              iir.submitted_date ASC
          )

    headers = [
        "Serial Number",
        "Title",
        "Summary",
        "System",
        "Requester",
        "Category",
        "Subcategory",
        "Status",
        "Priority",
        "Urgency",
        "Impact Range",
        "Support Group",
        "Supporter",
        "Submit Date",
        "Estimate Date",
        "Last Response Date",
        "Close Reason",
        "Incident Report Source"]

    result = ActiveRecord::Base.connection.execute(sql)
    datas = []
    result.each do |s|
      data = Array.new(18)
      data[0] = s[0]
      data[1] = s[1]
      data[2] = s[2]
      data[3] = s[3]
      data[4] = s[4]
      data[5] = s[5]
      data[6] = s[6]
      data[7] = s[7]
      data[8] = s[8]
      data[9] = s[9]
      data[10] = s[10]
      data[11] = s[11]
      data[12] = s[12]
      data[13] = s[13]
      data[14] = s[14]
      data[15] = s[15]
      data[16] = s[16]
      data[17] = s[17]
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
