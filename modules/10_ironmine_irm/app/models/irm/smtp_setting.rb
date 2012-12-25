class Irm::SmtpSetting < ActiveRecord::Base
  set_table_name :irm_smtp_settings

  after_save :merge_settings

  validates_presence_of :from_address, :email_prefix, :host_name, :port, :timeout, :username, :password


  def merge_settings
    ActionMailer::Base.smtp_settings.merge!({
        :address => self.host_name,
        :port => self.port,
        :user_name => self.username,
        :password => self.password,
        :authentication => self.authentication
    })
  end

  def test_smtp(email)
    MailSettingsTestMailer.test_smtp(email).deliver
  end
end
