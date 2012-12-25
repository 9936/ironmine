class ChangeMailSettings < ActiveRecord::Migration
  def up
    #删除邮件配置中已有的信息
    Irm::SmtpSetting.destroy_all
    Irm::ImapSetting.destroy_all

    add_column :irm_smtp_settings, :active_flag, :string, :limit => 1, :default => "Y",:after=> :authentication
    add_column :irm_imap_settings, :active_flag, :string, :limit => 1, :default => "Y",:after=> :password
  end

  def down
    remove_column :irm_smtp_settings, :active_flag
    remove_column :irm_imap_settings, :active_flag
  end
end
