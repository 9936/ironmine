class LoginReport < Irm::ReportManager::ReportBase
  def data(params={})
    datas = Irm::LoginRecord.all
    {:datas=>datas,:params=>params}
  end
end