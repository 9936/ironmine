class Hli::SupporterWorkDetails < Irm::ReportManager::ReportBase
  def data(params={})
    language = Irm::Person.current.language_code
    params||={}

    supporters = Irm::Person.
        enabled.
        select("#{Irm::Person.table_name}.*").
        where(%Q"EXISTS(SELECT * FROM #{Icm::SupportGroup.table_name} sg, #{Irm::GroupMember.table_name} gm
                 WHERE sg.group_id = gm.group_id
                 AND gm.person_id = #{Irm::Person.table_name}.id
                 AND sg.oncall_flag = ?)", Irm::Constant::SYS_YES)

    statis = Icm::IncidentRequest.where("1=1").enabled

    #曾经被分派到、在事故单上回复过的，都算在此事故单上付出了工作量
    if params[:supporter_id].present? && params[:supporter_id].size > 0 && params[:supporter_id][0].present?
      statis = statis.where(%Q"EXISTS(SELECT * FROM #{Icm::IncidentHistory.table_name} ih, #{Icm::IncidentJournal.table_name} ij1
                                WHERE ih.property_key = ? AND ih.old_value IN (?) AND ih.journal_id = ij1.id
                                AND ij1.incident_request_id = #{Icm::IncidentRequest.table_name}.id)
                                OR EXISTS(SELECT * FROM #{Icm::IncidentJournal.table_name} ij2
                                WHERE ij2.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij2.replied_by IN (?))
                                OR #{Icm::IncidentRequest.table_name}.support_person_id IN (?)",
                            "support_person_id",
                            params[:supporter_id] + [],
                            params[:supporter_id] + [],
                            params[:supporter_id] + [])
      supporters = supporters.where("id IN (?)", params[:supporter_id] + [])
    end

    if params[:hotline].present?
      statis = statis.where("#{Icm::IncidentRequest.table_name}.hotline = ?", params[:hotline])
    end

    external_systems = Irm::ExternalSystem.
        select("#{Irm::ExternalSystem.table_name}.*, est.system_name external_system_name").
        joins(",#{Irm::ExternalSystemsTl.table_name} est").
        where("est.external_system_id = #{Irm::ExternalSystem.table_name}.id").
        where("est.language = ?", language)

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      external_systems = external_systems.where("#{Irm::ExternalSystem.table_name}.id IN (?)", params[:external_system_id] + [])
    end

    if params[:start_date].present?
      statis = statis.where("submitted_date >= ?", params[:start_date])
      close_statuses = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES).collect(&:incident_status_code)
      statis = statis.
          where(" NOT EXISTS (SELECT * FROM #{Icm::IncidentJournal.table_name} ij WHERE ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND ij.reply_type IN (?) AND date_format(ij.created_at, '%Y-%m') < ? )",
                            close_statuses + [], params[:start_date])
    end

    if params[:end_date].present?
      statis = statis.where("submitted_date <= ?", params[:end_date])
    end

    datas = []
    headers = Array.new(external_systems.size + 2)
    headers[0] = I18n.t(:label_report_incident_request_supporter_and_system)
    headers[headers.size - 1] = I18n.t(:label_summary)

    summary_data =Array.new(headers.size)
    summary_data[0] = I18n.t(:label_summary)

    supporters.each do |sp|
      data = Array.new(external_systems.size + 2)
      data[0] = sp[:full_name]
      data[data.size - 1] = 0
      n = 1
      external_systems.each do |es|
        headers[n] = es[:external_system_name]
        data[n] = statis.where("external_system_id = ?", es.id).where("support_person_id = ?", sp.id).size
        data[data.size - 1] = data[data.size - 1] + data[n]
        summary_data[n] = summary_data[n].nil? ? 0 + data[n] : summary_data[n] + data[n]
        n = n + 1
      end
      summary_data[summary_data.size - 1] = summary_data[summary_data.size - 1].nil? ? 0 + data[data.size - 1] : summary_data[summary_data.size - 1] + data[data.size - 1]
      datas << data
    end
    datas << summary_data

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