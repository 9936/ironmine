class Irm::SmtpSetting < ActiveRecord::Base
  set_table_name :irm_smtp_settings

  #after_save :merge_settings

  validates_presence_of :from_address, :email_prefix, :host_name, :port, :timeout, :username, :password

  validates_presence_of :authentication, :if => Proc.new {|i| i.authentication_flag.eql?('Y')}


  def test_smtp(email)
    MailSettingsTestMailer.test_smtp(email).deliver
  end



end
