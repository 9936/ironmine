class IcmWorkloadRank < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    incident_request_table = Icm::IncidentRequest.table_name

    statis = Icm::IncidentRequest.
        joins(",#{Icm::IncidentJournal.table_name} ij1").
        joins(",#{Irm::Person.table_name} pe").
        where("ij1.incident_request_id = #{incident_request_table}.id").
        where("ij1.created_by = pe.id").
        where(%Q(EXISTS(
                  SELECT * FROM icm_incident_journals ij
                  WHERE ij.incident_request_id = #{incident_request_table}.id
                  AND ij.reply_type = 'SUPPORTER_REPLY'
                  AND date_format(ij.created_at, '%Y-%m') = '#{Date.strptime("#{params[:year]}-#{params[:month]}", '%Y-%m').strftime("%Y-%m")}')))

    external_systems = Irm::ExternalSystem.multilingual

    if params[:external_system_id].present? &&
        params[:external_system_id].size > 0 &&
        params[:external_system_id][0].present?
      statis = statis.where("external_system_id IN (?)", params[:external_system_id] + [])
      external_systems = external_systems.where("#{Irm::ExternalSystem.table_name}.id IN (?)", params[:external_system_id] + [])
    end

    datas = []
    headers = [I18n.t(:label_icm_rank),
               "#{I18n.t(:label_irm_person_name)}(#{I18n.t(:label_irm_person_login)})",
               I18n.t(:label_icm_workload)]

    external_systems.each do |e|
      data = Array.new(4)
      data[0] = e[:system_name]
      data[1] = ""
      data[2] = ""
      data[3] = ""
      total = statis.select("1").group("#{incident_request_table}.id").length
      rec = statis.
          where("#{incident_request_table}.external_system_id = ?", e.id).
          group("ij1.created_by").
          select("count(1) workload, pe.full_name full_name, pe.login_name login_name").
          order("count(1) desc")
      next unless rec.any?
      datas << data
      for i in 1..5
        break if rec[i].nil?
        data = Array.new(3)
        data[0] = i.to_s
        data[1] = "#{rec[i][:full_name]}(#{rec[i][:login_name]})"
        data[2] = rec[i][:workload]
        percent = total == 0 ? 0.to_f : ((data[2] / total.to_f * 100 * 100).round / 100.0).to_f
        if percent == 0.to_f
          percent = 0
        end
        data[3] = percent.to_s + "%"
        datas << data
      end
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