# -*- coding: utf-8 -*-
require "base64"

class Irm::CommonController < ApplicationController
  layout "common", :except => [:upload_file, :create_upload_file]
  #skip_before_filter :prepare_application

  def login
    params[:notice] ||= notice
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
    respond_to do |format|
      format.html {redirect_to login_url}
      format.json {
        render json: { :success => true }
      }
    end
  end

  def forgot_password
    
  end

  #当用户输入邮箱提交的时候发送一个链接
  def send_email
    #查找该email是否有效
    if params[:username].present? or params[:email].present?
      if params[:username].present?
        person = Irm::Person.list_all.where("login_name=?", params[:username]).first
      else
        persons = Irm::Person.list_all.where("email_address=?", params[:email])
        if persons.size > 1
          redirect_to({:action =>'forgot_password' }, :notice => t(:label_error_username_required))
          return
        else
          person = persons.first
        end
      end
      #生成一个随机的token
      if person.present?
        #如果是LDAP用户不能重置密码
        if person.ldap_flag.eql?(Irm::Constant::SYS_YES)
          redirect_to({:action =>'login' }, :notice => t(:label_error_ldap_user))
          return
        else
          #查找该用户该类型的token是否存在
          user_token = person.user_tokens.where(:token_type => "RESET_PWD").first
          if user_token.present?
            #new_flag = false
            user_token.created_at = Time.now
            user_token.updated_at = Time.now
          else
            #new_flag = true
            user_token = Irm::UserToken.new(:person_id => person.id,:token_type => "RESET_PWD")
          end
          if user_token.save
            token = user_token.token
            url = "#{request.protocol}#{request.host_with_port}/reset_pwd?type=RESET_PWD&pwd_token=#{token}"
            user_token.reset_pwd(person.email_address, person.id,url)
          end
        end
      else
        #email地址不存在
        redirect_to({:action =>'forgot_password' }, :notice => t(:label_error_email_not_existed))
      end
    else
      redirect_to({:action =>'forgot_password' }, :notice => t(:label_error_email_or_username_blank))
    end
  end

  def reset_pwd
    if params[:type] and params[:pwd_token]
      user_token = Irm::UserToken.where(:token_type => params[:type], :token => params[:pwd_token], :status_code => "ENABLED").first
      if user_token.present? && !user_token.expired?
        @person = user_token.person
        #将当前的语言设置为用户设置的语言
        if @person.language_code
          lang = find_language(@person.language_code)
          set_language_if_valid(lang)
        end
      end
    end
  end

  def update_pwd
    respond_to do |format|
      @person = Irm::Person.find(params[:person_id])
      if params[:person_id] and params[:password] and params[:password_confirm] and params[:password].eql?(params[:password_confirm]) and params[:password].present?
        if @person.present?
          user_token = @person.user_tokens.where(:token_type => params[:type]).first if @person.user_tokens.any?
          if user_token.present? and user_token[:token].to_s.eql?(params[:pwd_token].to_s)
            @person.password = params[:password]
            @person.password_updated_at = Time.now
            @person.unlock
            if @person.save
              user_token.destroy
            end
            format.html {redirect_to({ :action =>'login' }, :notice => t(:label_update_password_successfully))}
          end
          format.html {redirect_to({ :action =>'reset_pwd',:type=> params[:type],:pwd_token => params[:pwd_token]}, :notice => t(:label_update_password_error))}
        else
          format.html {redirect_to({ :action =>'reset_pwd',:type=> params[:type],:pwd_token => params[:pwd_token] }, :notice => t(:label_update_password_error))}
        end
      else
        format.html {redirect_to({ :action =>'reset_pwd',:type=> params[:type],:pwd_token => params[:pwd_token] }, :notice => t(:label_update_password_error))}
      end
    end
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
    params[:file] ||= params[:filedata]
    version = Irm::AttachmentVersion.new( :data => params[:file],
                                          :attachment_id=>@file.id,
                                          :source_type=> 0,
                                          :source_id => 0,
                                          :category_id => 0,
                                          :description => "")
    if params[:urls] and params[:urls].present? and params[:file].nil? and params[:urls].slice(0, 10).eql?('data:image')
      file_str = params[:urls]
      # 通过正则获取图片的后缀名
      ext = file_str.match(/^data:image\/jpg|jpeg|gif|png/i)
      # 截取掉不是文件的字符串
      file_str = file_str.slice(file_str.index('base64,') + 7, file_str.length)
      StringIO.open(Base64.decode64(file_str)) do |data|
        data.original_filename = "#{Time.now.to_i}.#{ext}"
        data.content_type = "image/#{ext}"
        version.data = data
      end
    end
    #当上传文件时候临时生成一个Id
    if params[:content_image].present?
      version.category_id = Irm::LookupValue.get_code_id("SKM_FILE_CATEGORIES", "IMAGE")
      version.source_type = "Skm::EntryHeader"
      @tmp_id = Fwk::IdGenerator.instance.generate(Skm::EntryHeader.table_name)
      version.source_id = @tmp_id
    end

    flag, now = version.over_limit?(Irm::SystemParametersManager.upload_file_limit)
    version.save if flag
    Irm::AttachmentVersion.update_attachment_by_version(@file,version)
    @url = version.url
    @render_target = "msgEditor"
    respond_to do |format|
      format.html {render :layout => false}
      format.json { }
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

  def kpi_resolved_rate
    close_statis = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES)
    sys_ids = Irm::ExternalSystem.multilingual.order_with_name.with_person(Irm::Person.current.id).enabled.collect(&:id) + []
    total = Icm::IncidentRequest.
        select("external_system_id, count(1) amount").
        where("external_system_id IN (?)", sys_ids)
    closed = Icm::IncidentRequest.
        select("external_system_id, count(1) amount").
        where("external_system_id IN (?)", sys_ids).
        where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?", close_statis)

    @percent = total.any? ? (((closed.first[:amount].to_f / total.first[:amount].to_f).to_f * 100 * 100).round / 100.0).to_f : 0.to_f

    incident_request_table = Icm::IncidentRequest.table_name
    #查询关闭状态ID

    close_statis = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES)
    if close_statis.any?
      close_statis = close_statis.first.id
    end

    statis = Icm::IncidentRequest.
        where("1=1").
        where("external_system_id IN (?)",
              Irm::ExternalSystem.multilingual.order_with_name.with_person(Irm::Person.current.id).enabled.collect(&:id) + [])

    tmp_data = statis.
             select(%Q(
                       SUM(TIMESTAMPDIFF(DAY, #{incident_request_table}.submitted_date,
                               (SELECT ij.created_at  FROM icm_incident_journals ij
                                 WHERE ij.incident_request_id = #{incident_request_table}.id
                                 AND ij.reply_type = 'CLOSE' order by created_at desc limit 1))) diff,
                       count(1) total
                   )).
             where("#{incident_request_table}.incident_status_id = ?", close_statis)
    @ttr_persent = tmp_data.any? ? ((tmp_data.first[:diff]/tmp_data.first[:total].to_f * 100).round / 100.0).to_f : 0.to_f

    intime = 0

    sla_records = Slm::SlaInstance.all
    sla_records.each do |slai|
      if "START".eql?(slai.last_phase_type)
        calendar = slai.service_agreement.calendar
        slai.current_duration = slai.current_duration.to_i+calendar.working_time(slai.last_phase_start_date,Time.now)
      end
      if  slai.current_duration < slai.max_duration
        intime = intime + 1
      end
    end

    @sla_persent = sla_records.size == 0 ? 0.to_f : ((intime/sla_records.size.to_f * 100 * 100).round / 100.0).to_f

    respond_to do |format|
      format.html
    end
  end

  def kpi_tto

  end

  private
  #验证用户登录是否成功
  #成功,则转向用户的默认页面
  #失败,返回原来的页面,并显示登录出错的消息
  def password_authentication
    begin
      person = Irm::Person.try_to_login(params[:username], params[:password])
      if person.eql?("LDAP_SOURCES_OFFLINE")
        params[:error] = t(:label_irm_ldap_source_offline)
        reset_session
      elsif person.nil?||!person.logged?
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


   rescue Irm::LdapPersonError => error
      params[:ldap_errors] = error.message
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
      cookies[:username] = {:value=>params[:username],:expires => 1.year.from_now}
    else
      cookies.delete(:username)
    end



    # generate a key and set cookie if autologin
    #if params[:autologin] && Setting.autologin?
    #  token = Token.create(:user => user, :action => 'autologin')
    #  cookies[:autologin] = { :value => token.value, :expires => 1.year.from_now }
    #end
    #call_hook(:controller_account_success_authentication_after, {:user => user })
    check_if_bulletin_required  #展示置顶公告之后再进行跳转
   # redirect_back_or_default
  end

  def logout_successful
     login_record = Irm::LoginRecord.where(:session_id=>session[:session_id]).first
     login_record.update_attributes(:logout_at=>Time.now) if login_record
  end

  def check_password(person,password)
    person.hashed_password.eql?(Irm::Person.hash_password(password))
  end
end
