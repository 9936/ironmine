class Irm::MyLoginHistoryController < ApplicationController
  def index

  end

  def get_login_data
    login_records_scope = Irm::LoginRecord.list_all.query_by_person(params[:id])

    respond_to do |format|
      format.html  {
        login_records,count = paginate(login_records_scope)
        @datas = login_records
        @count = count
      }
      format.json {
        login_records,count = paginate(login_records_scope)
        render :json=>to_jsonp(login_records.to_grid_json([:login_name,:user_ip,:operate_system,:browser,:login_at,:logout_at], count))
      }

      format.xls{
        send_data(data_to_xls(login_records_scope,
                              [{:key=>:login_name,:label=>t(:label_irm_person_login)},
                               {:key=>:user_ip,:label=>t(:label_irm_login_record_user_ip)},
                               {:key=>:operate_system,:label=>t(:label_irm_login_record_operate_system)},
                               {:key=>:browser,:label=>t(:label_irm_login_record_browser)},
                               {:key=>:login_at,:label=>t(:label_irm_login_record_login_at)},
                               {:key=>:logout_at,:label=>t(:label_irm_login_record_logout_at)}]
                  ))
      }
    end
  end
end