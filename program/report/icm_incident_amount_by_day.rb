class IcmIncidentAmountByDay < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    incident_request_table = Icm::IncidentRequest.table_name
    start_date = params[:date_from].present? ? Date.strptime(params[:date_from], '%Y-%m-%d') :  Time.now.strftime("%Y-%m-%d")
    params[:date_from] = start_date
    end_date = params[:date_to].present? ? Date.strptime(params[:date_to], '%Y-%m-%d') : Time.now.strftime("%Y-%m-%d")
    params[:date_to] = end_date

    statis = Icm::IncidentRequest.
        select("#{incident_request_table}.submitted_date, count(1) amount").
        group("date_format(#{incident_request_table}.submitted_date, '%Y-%m-%d')")

    statis = statis.
        where("date_format(#{incident_request_table}.submitted_date, '%Y-%m-%d') >= ?",
                          start_date.strftime("%Y-%m-%d")).
        where("date_format(#{incident_request_table}.submitted_date, '%Y-%m-%d') <= ?",
                          end_date.strftime("%Y-%m-%d"))

    datas = []
    headers = [I18n.t(:label_date),
               I18n.t(:label_icm_receive_amount)]

    chart_datas_tmp = []
    for i in start_date..end_date
      data = Array.new(4)
      data[0] = i.to_s
      rec = statis.where("date_format(#{incident_request_table}.submitted_date, '%Y-%m-%d') = ?", i.strftime("%Y-%m-%d"))
      data[1] = rec.any? ? rec.first[:amount] : 0
      datas << data
      chart_datas_tmp << {"date" => i, "amount" => data[1]}
    end
    {:datas=>datas,:headers=>headers,:params=>params,:chart_datas=>chart_datas_tmp}
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