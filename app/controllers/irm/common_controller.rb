class Irm::CommonController < ApplicationController
  layout "common", :except => [:upload_file, :create_upload_file]
  #skip_before_filter :prepare_application

  def login
    if request.get?
      # 注销用户
      self.logged_user = nil
    else
      password_authentication
    end
  end

  # 用户退出系统
  def logout
    logout_successful
    self.logged_user = nil
    redirect_to login_url
  end

  def forgot_password
    
  end

  def upload_screen_shot
    if params[:target] && params[:target].present?
      @render_target = params[:target]
    else
      @render_target = "msgEditor"
    end
  end

  def upload_file
    @file = Irm::AttachmentVersion.new()
    render :layout => "common_all"
  end

  def create_upload_file
    @file=Irm::Attachment.create()
    version = Irm::AttachmentVersion.new(:data => params[:file],
                                            :attachment_id=>@file.id,
                                            :source_type=> 0,
                                            :source_id => 0,
                                            :category_id => 0,
                                            :description => "")
    flag, now = version.over_limit?(Irm::SystemParametersManager.upload_file_limit)
    version.save if flag
    Irm::AttachmentVersion.update_attachment_by_version(@file,version)
    @url = "<img src=#{version.url}>"
    @render_target = "msgEditor"
    respond_to do |format|
      format.js do
        responds_to_parent do
          render :create_upload_file do |page|

          end
        end
      end
    end
  end

  # 个人密码修改页面
  def edit_password
    @person = Irm::Person.find(params[:id])
  end

  # 更新个人密码
  def update_password
    @person = Irm::Person.find(params[:id])
    params[:irm_person][:password]="*" if params[:irm_person][:password].blank?
    respond_to do |format|
      if(params[:irm_person][:old_password]&&check_password(@person,params[:irm_person][:old_password]))
        if @person.update_attributes(params[:irm_person])
          format.html {redirect_to({:action=>"login"},:notice=>t(:successfully_updated))}
        else
          @person.password = "" if @person.password.eql?("*")
          format.html {render("edit_password")}
        end
      else
        @person.errors.add(:old_password,t('activerecord.errors.messages.invalid'))
        format.html { render("edit_password")}
      end
    end
  end



  private
  #验证用户登录是否成功
  #成功,则转向用户的默认页面
  #失败,返回原来的页面,并显示登录出错的消息
  def password_authentication
    person = Irm::Person.try_to_login(params[:username], params[:password])
    if person.nil?||!person.logged?
      #失败
      user = Irm::Person.unscoped.where("login_name=?", params[:username]).first
      invalid_credentials(user)
      reset_session
    elsif person.locked?
      params[:error] = t(:notice_account_locked)
      reset_session
    else
      # 成功
      successful_authentication(person)
    end
  end

  #返回用户登录失败的消息
  def invalid_credentials(user)
    if(user.present?)
      user.add_lock_time
      user.save
      Irm::LoginRecord.create({:opu_id=>user.opu_id,
                               :identity_id=>user.id,
                         :session_id=>session[:session_id],
                         :user_ip=>request.remote_ip,
                         :user_agent=>request.user_agent,
                         :login_status=>"FAILED",
                         :login_at=>Time.now}) if session[:session_id].present?

    end
    params[:error] = t(:notice_account_invalid_creditentials)
  end

  #登录成功则返回到默认页面
  def successful_authentication(user)
    if !user.auth_source_id.present?&&Irm::PasswordPolicy.expire?(user.password_updated_at,user.opu_id)
      redirect_to({:action=>"edit_password",:id=>user.id})
      return
    end

    # 移除成功登录人员的锁定信息
    user.unlock
    user.save
    # 设定当前用户
    self.logged_user = user
    person_setup
    Irm::LoginRecord.create({:identity_id=>user.id,
                             :session_id=>session[:session_id],
                             :user_ip=>request.remote_ip,
                             :user_agent=>request.user_agent,
                             :login_at=>Time.now}) if session[:session_id].present?
    if(params[:rememberme])
      cookies[:username] = params[:username]
    else
      cookies.delete(:username)
    end



    # generate a key and set cookie if autologin
    #if params[:autologin] && Setting.autologin?
    #  token = Token.create(:user => user, :action => 'autologin')
    #  cookies[:autologin] = { :value => token.value, :expires => 1.year.from_now }
    #end
    #call_hook(:controller_account_success_authentication_after, {:user => user })
    redirect_back_or_default
  end

  def logout_successful
     login_record = Irm::LoginRecord.where(:session_id=>session[:session_id]).first
     login_record.update_attributes(:logout_at=>Time.now) if login_record
  end

  def check_password(person,password)
    person.hashed_password.eql?(Irm::Person.hash_password(password))
  end
end
