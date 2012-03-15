class Irm::MyInfoController < ApplicationController
  #个人信息显示页面
  def index
    @person = Irm::Person.list_all.with_delegate_approver.with_manager.find(Irm::Person.current.id)
  end

  #个人信息编辑页面
  def edit
    @person = Irm::Person.list_all.find(Irm::Person.current.id)
  end
  # 更新个人信息
  def update
    @person = Irm::Person.find(Irm::Person.current.id)

    respond_to do |format|
      if @person.update_attributes(params[:irm_person])
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_updated)) }
      else
        format.html { render "edit" }
      end
    end

  end

  #获取当前用户远程登录的记录
  def get_my_remote_access
    #根据用户的id获取当前应用id
    tokens = Irm::OauthToken.get_owned_client
    token_ids = tokens.collect{|i| [i.id]}
    #根据client_id 获取对应的client
    #remove_access_scope = Irm::OauthAccess.select("id, token_id, ip_address,updated_at,sum(times) times").where(:token_id=>token_ids).group("ip_address, client_id")
    remove_access_scope = Irm::OauthAccess.where(:token_id=>token_ids)
    remove_access_record, count = paginate(remove_access_scope)
    ip_and_names = []
    remove_access_record.each do |data|
      tokens.each do |token|
        if token.id.eql?(data.token_id)
          ip_and_names << "#{data[:ip_address]}#{token.name}" unless ip_and_names.include?("#{data[:ip_address]}#{token.name}")
          data[:client] = token.name
          break
        end
      end
    end
    total_record = {}
    ip_and_names.each do |ip_and_name|
      times = 0
      recent_date = Time.new(2000,01,01,00,00,0)
      remove_access_record.each do |data|
        if ip_and_name.eql?("#{data[:ip_address]}#{data[:client]}")
          total_record[ip_and_name] ||= []
          times += data[:times]
          recent_date = data[:updated_at] if data[:updated_at] > recent_date
          total_record[ip_and_name] = data
        end
      end
      total_record[ip_and_name][:times] = times
      total_record[ip_and_name][:updated_at] = recent_date
    end
    respond_to do |format|
      format.html{
        @datas = total_record
        @count = count
        render_html_data_table
      }
      format.json {render :json=>to_jsonp(remove_access_record.to_grid_json([:client,:ip_address,:created_at,:updated_at, :times], count))}
    end
  end

  def get_login_data
    login_records_scope = Irm::LoginRecord.list_all.query_by_person(Irm::Person.current.id)
    login_records,count = paginate(login_records_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(login_records.to_grid_json([:login_name,:user_ip,:operate_system,:browser,:login_at,:logout_at], count))}
    end
  end

  def avatar_crop
    @person = Irm::Person.find(params[:id])
  end

  def avatar_update
    @person = Irm::Person.find(params[:id])
    respond_to do |format|
      if params[:irm_person][:avatar]
        if @person.update_attribute(:avatar, params[:irm_person][:avatar])
          if params[:return_url]
            format.html {redirect_to(params[:return_url])}
            format.xml { head :ok}
          else
            format.html {render "avatar_crop"}
          end
        else
          format.html {render "edit"}
        end
      elsif @person.update_attributes(params[:irm_person])
        if params[:return_url]
          format.html {redirect_to(params[:return_url])}
          format.xml { head :ok}
        else
          format.html {render "index"}
        end
      else
        format.html {render "edit"}
      end
    end
  end
end
