class Irm::MyLoginHistoryController < ApplicationController
  def index

  end

  def get_login_data
    login_records_scope = Irm::LoginRecord.list_all.query_by_person(params[:id])

    respond_to do |format|
      format.json {
        login_records,count = paginate(login_records_scope)
        render :json=>to_jsonp(login_records.to_grid_json([:login_name,:user_ip,:operate_system,:browser,:login_at,:logout_at], count))
      }

      format.xls{
        send_data(login_records_scope.to_xls(:only => [:login_name,:user_ip,:operate_system,:browser,:login_at,:logout_at],
                                       :headers=>[       t(:label_irm_person_login),
                                                         t(:label_irm_login_record_user_ip),
                                                         t(:label_irm_login_record_operate_system),
                                                         t(:label_irm_login_record_browser),
                                                         t(:label_irm_login_record_login_at),
                                                         t(:label_irm_login_record_logout_at)]
                                             ))}
      end
  end
end