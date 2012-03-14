class Irm::OauthAuthorizeController < ApplicationController
  #授权码处理
  before_filter :client_where_secret_and_redirect, :find_authorization,:find_authorization_expired
  #刷新密码和密码处理
  before_filter :client_where_secret
  #刷新码处理
  before_filter :find_token_by_refresh_token
  #密码处理
  before_filter :find_resource_owner


  def show
    #检查是否登录,如果当前用户已经登录则跳转到授权页面，否则跳转回登录页面
    if Irm::Person.current.logged?
      render :layout => false
    else
      url = ''
      if request.get?
        url = url_for(params)
      end
      redirect_to :controller => "irm/common", :action => "login", :back_url => url
    end
  end

  def create
    #根据当前client_id和 redirect_uri查找client
    find_client
    if params[:response_type] == "code"
      @auth_code = Irm::OauthCode.create(oauth_access_client_id: @client.id, person_id: Irm::Person.current.id, access_scope: params[:scope])
      redirect_to authorization_redirect_uri(@client, @auth_code, params[:state])
    end
  end

  #生成token
  def token
    #授权码相应的处理
    if params[:grant_type] == "authorization_code"
      #client_where_secret_and_redirect
      #find_authorization
      #find_authorization_expired
      @token = Irm::OauthToken.create(client_id: @client.id, oauth_code_id: @authorization.id, user_id: @authorization.person_id)
    end
    #刷新令牌相应的处理
    if params[:grant_type] == "refresh_token"
      #client_where_secret
      #find_expired_token
      #禁止再次进系刷新，设置为过期状态
      @expired_token.update_attribute("expire_at", Time.now)
      @token = Irm::OauthToken.create(client_id: @client.id, oauth_code_id: @expired_token.oauth_code_id,relation_oauth_token_id: @expired_token.id, user_id: @expired_token.user_id)
    end
    #密码进行处理
    if params[:grant_type] == "password"
      #client_where_secret
      #find_resource_owner
      @token = OauthToken.create(client_id: @client.id, user_id: @resource_owner.id)
    end
  end


  def client_where_secret_and_redirect
    if params[:grant_type] == "authorization_code"
      @client = Irm::OauthAccessClient.where(:secret => params[:client_secret]).where(:callback_url=> params[:redirect_uri]).first
      message = "label_irm_oauth_client_not_found"
      info = { client_secret: params[:client_secret], client_id: params[:client_id], redirect_uri: params[:redirect_uri] }
      render_422 message, info unless @client
    end
  end

  def authorization_redirect_uri(client, authorization, state)
    uri  = client.callback_url
    uri += "?code="  + authorization.code
    uri += "&state=" + state if state
    return uri
  end

  def find_client
    @client = Irm::OauthAccessClient.where(:site_url => params[:client_id], :callback_url=> params[:redirect_uri]).first
    client_not_found unless @client
  end

  #授权码处理
  def find_authorization
    if params[:grant_type] == "authorization_code"
      @authorization = Irm::OauthCode.where(:code => params[:code],:oauth_access_client_id => @client.id).first
      message = "label_irm_oauth_code_unavailable"
      info = { code: params[:code], client_id: @client.site_url }
      render_422 message, info unless @authorization
    end
  end

  #授权码是否过期
  def find_authorization_expired
    if params[:grant_type] == "authorization_code"
      message = "label_irm_oauth_code_expired"
      #info = { expired_at: @authorization.expire_at, description: distance_of_time_in_words(@authorization.expire_at, Time.now, true) }
      info = { expired_at: @authorization.expire_at }
      render_422 message, info if @authorization.expired?
    end
  end

  def client_where_secret
    if params[:grant_type] == "refresh_token" or params[:grant_type] == "password"
      @client = Irm::OauthAccessClient.where(:site_url => params[:client_id], :secret => params[:client_secret]).first
      message = "label_irm_oauth_client_not_found"
      info = { client_secret: params[:client_secret], client_id:params[:client_id] }
      render_422 message, info unless @client
    end
  end
  #根据refresh_token进行查找，并判断当前的刷新令牌是否可用
  def find_token_by_refresh_token
    if params[:grant_type] == "refresh_token"
      @expired_token = Irm::OauthToken.where(refresh_token: params[:refresh_token]).first
      message = "label_irm_oauth_token_unavailable"
      info = { token: @expired_token.token }
      render_422 message, info if @expired_token.nil? or @expired_token.expired?
    end
  end

  #根据用户名和密码进系查找
  def find_resource_owner
    if params[:grant_type] == "password"
      #检测密码中含有的安全标记是否匹配
      params[:password] = get_password_by_security(params[:username], params[:password])
      @resource_owner = Irm::Person.try_to_login(params[:username], params[:password])
      message = "label_irm_oauth_username_or_password_error"
      info = { username: params[:username] }
      render_422 message, info unless @resource_owner
    end
  end

  #没有找到相关的用用处理
  def client_not_found
    flash.now.alert = I18n.t(:label_irm_oauth_client_not_found)
    @info = { client_id: params[:client_id], redirect_uri: params[:redirect_uri] }
    render "show", and return
  end

  def render_422(message, info)
    @message = I18n.t message
    @info    = info.to_json
    render "422", status: 422 and return
  end

  #根据用户名查找当前用户的安全标记,并返回密码
  def get_password_by_security(login_name, security)
    person = Irm::Person.where(:login_name => login_name).first
    #security末尾含有安全标记
    if security.end_with?(person.security_flag)
      security[0,(security.size - person.security_flag.size)]
    else
      nil
    end
  end

end