class Yan::UncloseLastReply < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.enabled.
        with_category(I18n.locale).
        with_support_group(I18n.locale).
        with_supporter(I18n.locale).
        select("iisv.name incident_status_name").
        select("    (SELECT
            ij1.message_body
        FROM
            icm_incident_journals ij1
        WHERE
            ij1.reply_type IN ('OTHER_REPLY' , 'SUPPORTER_REPLY', 'CUSTOMER_REPLY')
                AND ij1.incident_request_id = #{Icm::IncidentRequest.table_name}.id
        ORDER BY ij1.created_at DESC
        LIMIT 1) last_reply").
        select("    (SELECT
            ipj.full_name
        FROM
            icm_incident_journals ij2,
            irm_people ipj
        WHERE
            ipj.id = ij2.replied_by
                AND ij2.reply_type IN ('OTHER_REPLY' , 'SUPPORTER_REPLY', 'CUSTOMER_REPLY')
                AND ij2.incident_request_id = #{Icm::IncidentRequest.table_name}.id
        ORDER BY ij2.created_at DESC
        LIMIT 1) last_person").
        select("(SELECT
            ij3.created_at
        FROM
            icm_incident_journals ij3
        WHERE
            ij3.reply_type IN ('OTHER_REPLY' , 'SUPPORTER_REPLY', 'CUSTOMER_REPLY')
                AND ij3.incident_request_id = #{Icm::IncidentRequest.table_name}.id
        ORDER BY ij3.created_at DESC
        LIMIT 1) last_date").select("ips.full_name requested_name").select("iesv.system_name external_system_name").
        joins(", icm_incident_statuses_vl iisv").
        joins(", irm_people ips ").where("ips.id = #{Icm::IncidentRequest.table_name}.submitted_by").
        joins(", irm_external_systems_vl iesv").where("iesv.language = 'en'").where("#{Icm::IncidentRequest.table_name}.external_system_id = iesv.id").
        where("iisv.language = 'en'").where("#{Icm::IncidentRequest.table_name}.incident_status_id = iisv.id").
        where("iisv.incident_status_code <> 'CLOSED'").
        order("(#{Icm::IncidentRequest.table_name}.submitted_date) ASC")

    datas = []

    headers = [
               I18n.t(:label_icm_incident_request_request_number),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_submitted_date),
               I18n.t(:label_icm_incident_request_requested_by),
               I18n.t(:label_irm_external_system),
               I18n.t(:label_icm_incident_request_incident_status_code),
               I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_icm_incident_request_incident_sub_category),
               I18n.t(:label_icm_incident_request_support_group),
               I18n.t(:label_icm_incident_request_support_person),
               "Last Reply",
               "Last Person",
               "Last Date"
               ]

    statis.each do |s|
      data = Array.new(13)
      data[0] = s[:request_number]
      data[1] = s[:title]
      data[2] = s[:submitted_date]
      data[3] = s[:requested_name]
      data[4] = s[:external_system_name]
      data[5] = s[:incident_status_name]
      data[6] = s[:incident_category_name]
      data[7] = s[:incident_sub_category_name]
      data[8] = s[:support_group_name]
      data[9] = s[:supporter_name]
      data[10] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:last_reply],""))  unless s[:last_reply].nil?
      data[11] = s[:last_person]
      data[12] = s[:last_date]
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
