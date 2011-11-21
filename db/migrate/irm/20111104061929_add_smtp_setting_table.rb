class AddSmtpSettingTable < ActiveRecord::Migration
  def up
    create_table :irm_smtp_settings, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "from_address", :limit => 250, :null => false
      t.string "email_prefix", :limit => 250, :null => false
      t.string "protocol", :limit => 30
      t.string "host_name", :limit => 150
      t.string "port", :limit => 30, :default => "25"
      t.string "timeout", :limit => 30, :default => "10000"
      t.string "tls_flag", :limit => 1
      t.string "username", :limit => 60
      t.string "password", :limit => 60
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    drop_table :irm_smtp_settings
  end
end
