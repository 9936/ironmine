class LoginReport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    datas = Irm::LoginRecord.with_person.select_all.order("login_at desc")
    chart_datas = Irm::LoginRecord.select("count(*) count, DATE_FORMAT(`login_at`,'%Y-%m-%d') date").group("DATE_FORMAT(`login_at`,'%Y-%m-%d')").order("date")
    if(params[:date_from].present?)
      datas = datas.where("login_at > ?",params[:date_from])
      chart_datas = chart_datas.where("login_at > ?",params[:date_from])
    end

    if(params[:date_to].present?)
      datas = datas.where("login_at < ?",params[:date_to])
      chart_datas = chart_datas.where("login_at < ?",params[:date_to])
    end

    if(params[:person_id].present?)
      datas = datas.where("#{Irm::LoginRecord.table_name}.identity_id = ?",params[:person_id])
      chart_datas = chart_datas.where("#{Irm::LoginRecord.table_name}.identity_id = ?",params[:person_id])
    end
    chart_datas_tmp = []
    chart_datas.each do |cd|
      chart_datas_tmp << cd.attributes
    end
    {:datas=>datas,:params=>params,:chart_datas=>chart_datas_tmp}
  end
end