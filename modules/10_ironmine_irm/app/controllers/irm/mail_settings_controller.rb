class Irm::MailSettingsController < ApplicationController
  def index
    init
    @smtp_setting = Irm::SmtpSetting.where("opu_id = ?", Irm::OperationUnit.current.id).first()
    @imap_setting = Irm::ImapSetting.where("opu_id = ?", Irm::OperationUnit.current.id).first()
  end

  def edit
    init
    @smtp_setting = Irm::SmtpSetting.where("opu_id = ?", Irm::OperationUnit.current.id).first()
    @imap_setting = Irm::ImapSetting.where("opu_id = ?", Irm::OperationUnit.current.id).first()
  end

  def update
    @smtp_setting = Irm::SmtpSetting.where("opu_id = ?", Irm::OperationUnit.current.id).first()
    @imap_setting = Irm::ImapSetting.where("opu_id = ?", Irm::OperationUnit.current.id).first()
    new_smtp = params[:smtp_setting]
    new_imap = params[:imap_setting]
    new_imap.merge!({:timeout => new_smtp[:timeout]}) if new_smtp[:timeout].present?
    new_imap.merge!({:username => new_smtp[:username]}) if new_smtp[:username].present?
    new_imap.merge!({:password => new_smtp[:password]}) if new_smtp[:password].present?



    respond_to do |format|
      if @smtp_setting.update_attributes(params[:smtp_setting]) &&
          @imap_setting.update_attributes(params[:imap_setting])
        format.html { redirect_to :action => "index"}
      else
        format.html { render :action => "edit"}
      end
    end
  end

  def test_smtp
    smtp_setting = Irm::SmtpSetting.first
    smtp_setting.test_smtp(params[:email])
  end

  private
  def init
    unless Irm::SmtpSetting.where("opu_id = ?", Irm::OperationUnit.current.id).any?
      Irm::SmtpSetting.create(:opu_id => Irm::OperationUnit.current.id,
                              :from_address => Irm::MailManager.default_email_from,
                              :email_prefix => "IRONMINE",
                              :protocol => "SMTP",
                              :port => Ironmine::Application.config.action_mailer.smtp_settings[:port] || "25",
                              :timeout => "10000",
                              :host_name => Ironmine::Application.config.action_mailer.smtp_settings[:address],
                              :tls_flag => Irm::Constant::SYS_YES,
                              :username => Ironmine::Application.config.action_mailer.smtp_settings[:user_name] || "rootironmine@163.com",
                              :password => Ironmine::Application.config.action_mailer.smtp_settings[:password] || "handhand",
                              :authentication => Ironmine::Application.config.action_mailer.smtp_settings[:authentication] || "login")
    end

    unless Irm::ImapSetting.where("opu_id = ?", Irm::OperationUnit.current.id).any?
      Irm::ImapSetting.create(:opu_id => Irm::OperationUnit.current.id,
                              :protocol => "POP",
                              :host_name => Ironmine::Application.config.action_mailer.smtp_settings[:address],
                              :port => "110",
                              :timeout => "10000",
                              :username => Ironmine::Application.config.action_mailer.smtp_settings[:user_name] || "rootironmine@163.com",
                              :password => Ironmine::Application.config.action_mailer.smtp_settings[:password] || "handhand")
    end
  end
end