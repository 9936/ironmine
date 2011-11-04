class Irm::MailSettingsController < ApplicationController
  def index
    @smtp_setting = Irm::SmtpSetting.all.first()
    @imap_setting = Irm::ImapSetting.all.first()
  end

  def edit

  end

  def update

  end
end