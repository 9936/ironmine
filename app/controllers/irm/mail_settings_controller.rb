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

    respond_to do |format|
      if @smtp_setting.update_attributes(params[:smtp_setting]) &&
          @imap_setting.update_attributes(params[:imap_setting])
        format.html { redirect_to :action => "index"}
      else
        format.html { render :action => "edit"}
      end
    end
  end

  private
  def init
    unless Irm::SmtpSetting.where("opu_id = ?", Irm::OperationUnit.current.id).any?
      Irm::SmtpSetting.create(:opu_id => Irm::OperationUnit.current.id,
                              :from_address => "example@example.com",
                              :email_prefix => "IRONMINE",
                              :protocol => "SMTP",
                              :port => "25",
                              :timeout => "10000",
                              :host_name => "localhost",
                              :tls_flag => Irm::Constant::SYS_YES,
                              :username => "ironmine",
                              :password => "ironmine")
    end

    unless Irm::ImapSetting.where("opu_id = ?", Irm::OperationUnit.current.id).any?
      Irm::ImapSetting.create(:opu_id => Irm::OperationUnit.current.id,
                              :protocol => "POP",
                              :host_name => "localhost",
                              :port => "110",
                              :timeout => "10000",
                              :username => "ironmine",
                              :password => "ironmine")
    end
  end
end