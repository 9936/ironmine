class Irm::ImapSetting < ActiveRecord::Base
  set_table_name :irm_imap_settings

  validates_presence_of :protocol, :host_name, :port, :timeout, :username, :password
end
