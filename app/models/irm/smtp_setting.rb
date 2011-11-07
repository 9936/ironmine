class Irm::SmtpSetting < ActiveRecord::Base
  set_table_name :irm_smtp_settings

  validates_presence_of :from_address, :email_prefix, :host_name, :port, :timeout, :username, :password

end
