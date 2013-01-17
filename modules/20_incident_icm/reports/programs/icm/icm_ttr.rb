class Icm::IcmTtr < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    incident_request_table = Icm::IncidentRequest.table_name
    #查询关闭状态ID
    close_statis = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES)
    if close_statis.any?
      close_statis = close_statis.first.id
    else
      return {:datas=>[],:headers=>[],:params=>params}
    end

    priority = Icm::PriorityCode.multilingual

    statis = Icm::IncidentRequest.where("1=1")

    external_systems = Irm::ExternalSystem.multilingual

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system_id IN (?)", params[:external_system_id] + [])
      external_systems = external_systems.where("#{Irm::ExternalSystem.table_name}.id IN (?)", params[:external_system_id] + [])
    else
      statis = statis.where("external_system_id IN (?)",
                            Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
      external_systems = external_systems.where("#{Irm::ExternalSystem.table_name}.id IN (?)",
                                                Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + [])
    end

    datas = []

    headers = Array.new(priority.size + 1)
    headers[0] = I18n.t(:label_report_date_month)

    (1..12).each do |n|

      data = Array.new(priority.size + 1)
      data[0] = n.to_s

      pcount = 1
      priority.each do |pr|
        headers[pcount] = pr[:name]
         tmp_data = statis.
                  select(%Q(
                            SUM(TIMESTAMPDIFF(DAY, #{incident_request_table}.submitted_date,
                                    (SELECT ij.created_at  FROM icm_incident_journals ij
                                      WHERE ij.incident_request_id = #{incident_request_table}.id
                                      AND ij.reply_type = 'CLOSE'
                                      AND date_format(ij.created_at, '%Y-%m') = '#{Date.strptime("#{params[:year]}-#{n}", '%Y-%m').strftime("%Y-%m")}' order by created_at desc limit 1))) diff,
                            count(1) total
                        )).
                  where("#{incident_request_table}.incident_status_id = ?", close_statis).
                  where(%Q(#{incident_request_table}.priority_id = ?), pr.id).
                  where(%Q(EXISTS(
                            SELECT * FROM icm_incident_journals ij
                            WHERE ij.incident_request_id = #{incident_request_table}.id
                            AND ij.reply_type = 'CLOSE'
                            AND date_format(ij.created_at, '%Y-%m') = '#{Date.strptime("#{params[:year]}-#{n}", '%Y-%m').strftime("%Y-%m")}'))).
             group("#{incident_request_table}.priority_id")
        data[pcount] = tmp_data.any? ? ((tmp_data.first[:diff]/tmp_data.first[:total].to_f * 100).round / 100.0).to_f : 0.to_f

        pcount = pcount + 1
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