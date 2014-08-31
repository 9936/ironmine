class Hli::IncidentRequestStatisByPriority < Irm::ReportManager::ReportBase
  def data(params={})
    language = Irm::Person.current.language_code
    params||={}

    statis = Icm::IncidentRequest.
        select("count(1) statis_count, '' percentage, pct.name priority").enabled.
        joins(", #{Icm::PriorityCode.table_name} pc, #{Icm::PriorityCodesTl.table_name} pct").
        joins(", #{Irm::ExternalSystem.view_name} es").
        where("es.id = icm_incident_requests.external_system_id").
        where("es.language = pct.language").
        where("pc.weight_values = icm_incident_requests.weight_value").
        where("pc.id = pct.priority_code_id").
        where("pct.language = ?", language).
        order("pc.weight_values DESC")
    if params[:from_year].present? && params[:to_year].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m') >= ?", Date.strptime("#{params[:from_year][:year]}-#{params[:from_year][:month]}", '%Y-%m').strftime("%Y-%m"))
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m') <= ?", Date.strptime("#{params[:to_year][:year]}-#{params[:to_year][:month]}", '%Y-%m').strftime("%Y-%m"))
    end

    if params[:hotline].present?
      statis = statis.where("icm_incident_requests.hotline = ?", params[:hotline])
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("es.id IN (?)", params[:external_system_id] + [])
    end

    datas = []
    headers = [I18n.t(:label_icm_incident_request_priority), I18n.t(:label_amount), I18n.t(:label_percentage)]
    statis_count_total = 0

    priorities = Icm::PriorityCode.
        select("#{Icm::PriorityCode.table_name}.id priority_id, pct.name priority_name").
        joins(",#{Icm::PriorityCodesTl.table_name} pct").
        where("pct.priority_code_id = #{Icm::PriorityCode.table_name}.id").
        where("pct.language = ?", language).
        enabled.
        order("weight_values DESC")

    priorities.each do |pr|
      data = Array.new(3)
      data[0] = pr[:priority_name]
      data[1] = 0
      data[2] = "100%"
      t = statis.where("pc.id = ?", pr[:priority_id])

      if t.any?
        data = Array.new(3)
        data[0] = pr[:priority_name]
        data[1] = t.size
        data[2] = 0.to_s + '%'
        datas << data
        statis_count_total += t.size
      end

      datas << data unless t.any?
    end

    datas.each do |d|
      next if statis_count_total == 0
      d[2] = ( ((d[1]/statis_count_total.to_f)*100*100).round/100.0).to_s + '%'
    end
    sum = [I18n.t(:label_summary), statis_count_total, '100%']
    datas << sum
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