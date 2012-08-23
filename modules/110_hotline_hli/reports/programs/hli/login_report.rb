class Hli::LoginReport < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    datas = Irm::LoginRecord.with_person.select_all.order("login_at desc")
    chart_datas = Irm::LoginRecord.select("count(*) total_count, DATE_FORMAT(`login_at`,'%Y-%m-%d') date").group("DATE_FORMAT(`login_at`,'%Y-%m-%d')").order("date")
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

  def to_xls(params)
    columns = [{:key=>:full_name,:label=>I18n.t(:label_irm_person)},
               {:key=>:login_name,:label=>I18n.t(:label_irm_person_login)},
               {:key=>:user_ip,:label=>I18n.t(:label_irm_login_record_user_ip)},
               {:key=>:operate_system,:label=>I18n.t(:label_irm_login_record_operate_system)},
               {:key=>:browser,:label=>I18n.t(:label_irm_login_record_browser)},
               {:key=>:login_at,:label=>I18n.t(:label_irm_login_record_login_at)},
               {:key=>:logout_at,:label=>I18n.t(:label_irm_login_record_logout_at)}]

    result = data(params)
    result[:datas].to_xls(columns,{}) do |sheet|
      chart_data_columns = [{:key=>:date,:label=>"Date"},
                            {:key=>:total_count,:label=>"Total"}]
      result[:chart_datas].append_to_xls_sheet(sheet,chart_data_columns)
    end
  end
end