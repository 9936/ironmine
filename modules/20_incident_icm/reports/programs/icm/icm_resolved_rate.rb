class Icm::IcmResolvedRate < Irm::ReportManager::ReportBase
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

    statis = Icm::IncidentRequest.select("external_system_id, count(1) amount")

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
    headers = [I18n.t(:label_report_date_month),
               I18n.t(:label_icm_receive_amount),
               I18n.t(:label_total_solved_amount),
               I18n.t(:label_percentage)]

    (1..12).each do |n|

      data = Array.new(4)
      data[0] = n.to_s

      data[1] = statis.
          where(%Q(date_format(#{incident_request_table}.submitted_date, '%Y-%m') = '#{Date.strptime("#{params[:year]}-#{n}", '%Y-%m').strftime("%Y-%m")}'))

      data[1] = data[1].any? ? data[1].first[:amount] : 0

      data[2] = statis.where("#{incident_request_table}.incident_status_id = ?", close_statis).
                where(%Q(EXISTS(
                          SELECT * FROM icm_incident_journals ij
                          WHERE ij.incident_request_id = #{incident_request_table}.id
                          AND ij.reply_type = 'CLOSE'
                          AND date_format(ij.created_at, '%Y-%m') = '#{Date.strptime("#{params[:year]}-#{n}", '%Y-%m').strftime("%Y-%m")}')))
      data[2] = data[2].any? ? data[2].first[:amount] : 0

      percent = data[1] == 0 ? 0.to_f : (((data[2].to_f / data[1].to_f).to_f * 100 * 100).round / 100.0).to_f
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