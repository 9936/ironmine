class Hli::IncidentRequestMonthDurationByPriority < Irm::ReportManager::ReportBase
  def data(params={})
    language = Irm::Person.current.language_code
    params||={}
    datas = []
    close_status = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES).first
    priorities = Icm::PriorityCode.
        select("#{Icm::PriorityCode.table_name}.id id, pct.name priority_name").
        joins(",#{Icm::PriorityCodesTl.table_name} pct").
        where("pct.language = ?", language).
        where("pct.priority_code_id = #{Icm::PriorityCode.table_name}.id").
        order("#{Icm::PriorityCode.table_name}.weight_values DESC").
        enabled

    statis = Icm::IncidentRequest.
        select("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m') submitted_month").
        select("#{Icm::IncidentRequest.table_name}.priority_id priority_id").enabled.
        where("date_format(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m-%d') >= ?", Date.strptime("2011-01-01", '%Y-%m-%d')).
        where("hotline = ?", Irm::Constant::SYS_YES).
        where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?", close_status.id).
        order("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m') ASC")

    #if params[:start].present?
    #  statis = statis.where("date_format(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') >= ?",
    #                        Date.strptime("#{params[:start][:year]}-#{params[:start][:month]}", '%Y-%m').strftime("%Y-%m"))
    #end
    #
    #if params[:end].present?
    #  statis = statis.where("date_format(#{Icm::IncidentRequest.table_name}.submitted_date, '%Y-%m') >= ?",
    #                        Date.strptime("#{params[:end][:year]}-#{params[:end][:month]}", '%Y-%m').strftime("%Y-%m"))
    #end
    statis = statis.
        where("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m-%d') < ?",
              Date.strptime("#{params[:end][:year]}-#{params[:end][:month]}", '%Y-%m') + 1.month).
        where("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m-%d') >= ?",
              Date.strptime("#{params[:start][:year]}-#{params[:start][:month]}", '%Y-%m'))
    statis = statis.
        select("SUM(DATEDIFF(#{Icm::IncidentRequest.table_name}.last_response_date, #{Icm::IncidentRequest.table_name}.submitted_date)) duration").
        group("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m'), #{Icm::IncidentRequest.table_name}.priority_id")

    column_size = priorities.size + 2

    headers = Array.new(column_size)
    headers[0] = I18n.t(:label_report_submitted_date_and_priority)
    headers[column_size - 1] = I18n.t(:label_summary)

    last_data = Array.new(column_size)
    last_data[0] = I18n.t(:label_summary)
    last_data[column_size - 1] = 0.0
    statis.each do |s|
      data = Array.new(column_size)
      data[0] = s[:submitted_month]
      data[column_size - 1] = 0.0
      n = 1
      existed = datas.find{|i| i[0] == s[:submitted_month]}
      priorities.each do |p|
        if existed && s[:priority_id] == p[:id]
          existed[n] = s[:duration]
          last_data[n] = last_data[n] + existed[n]
          last_data[n] = 0.0 if last_data[n].nil?
          existed[column_size - 1] = existed[column_size - 1] + existed[n]
          last_data[column_size - 1] = last_data[column_size - 1] + existed[n]
        else
          headers[n] = p[:priority_name]
          data[n] = 0.0
          last_data[n] = 0.0 if last_data[n].nil?
          data[n] = s[:duration] if s[:priority_id] == p[:id]
          data[column_size - 1] = data[column_size - 1] + data[n]
          last_data[n] = last_data[n] + data[n]
          last_data[column_size - 1] = last_data[column_size - 1] + data[n]
        end
        n = n + 1
      end
      datas << data unless existed
    end
    datas << last_data
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