class IcmToRfcRate < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    incident_request_table = Icm::IncidentRequest.table_name

    statis = Icm::IncidentRequest.
        select("#{incident_request_table}.external_system_id, count(1) amount").
        group("#{incident_request_table}.external_system_id")

    external_systems = Irm::ExternalSystem.multilingual

    if params[:external_system_id].present? &&
        params[:external_system_id].size > 0 &&
        params[:external_system_id][0].present?
      statis = statis.where("external_system_id IN (?)", params[:external_system_id] + [])
      external_systems = external_systems.where("#{Irm::ExternalSystem.table_name}.id IN (?)", params[:external_system_id] + [])
    end

    datas = []
    headers = [I18n.t(:label_irm_external_system),
               I18n.t(:label_icm_to_rfc_amount),
               I18n.t(:label_total_amount),
               I18n.t(:label_icm_to_rfc_rate)]

    external_systems.each do |e|
      data = Array.new(4)
      data[0] = e[:system_name]
      rec = statis.
          where("#{incident_request_table}.external_system_id = ?", e.id).
          where(%Q(date_format(#{incident_request_table}.submitted_date, '%Y-%m') = ? OR
            EXISTS (SELECT * FROM chm_change_incident_relations cir
                      WHERE cir.incident_request_id = #{incident_request_table}.id
                      AND date_format(cir.created_at, '%Y-%m') = ?)),
            Date.strptime("#{params[:year]}-#{params[:month]}", '%Y-%m').strftime("%Y-%m"),
            Date.strptime("#{params[:year]}-#{params[:month]}", '%Y-%m').strftime("%Y-%m"))
      to_rfc_rec = statis.
                where("#{incident_request_table}.external_system_id = ?", e.id).
                where(%Q(EXISTS (SELECT * FROM chm_change_incident_relations cir
                            WHERE cir.incident_request_id = #{incident_request_table}.id
                            AND date_format(cir.created_at, '%Y-%m') = ?)),
                  Date.strptime("#{params[:year]}-#{params[:month]}", '%Y-%m').strftime("%Y-%m"))
      data[1] = to_rfc_rec.any? ? to_rfc_rec.first[:amount]  : 0
      data[2] = rec.any? ? rec.first[:amount]  : 0
      percent = data[2] == 0 ? 0.to_f : ((data[1] / data[2].to_f * 100 * 100).round / 100.0).to_f
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