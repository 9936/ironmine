class CreateMonitorPrograms < ActiveRecord::Migration
  def change
    create_table :emw_monitor_programs, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "assigned_to", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "history_flag", :limit => 1, :default => 'N'
      t.string   "mail_alert", :limit => 22, :null => false, :collate => "utf8_bin"
      t.text     "time_mode"
      t.string   "repeat_type", :limit => 30
      t.date     "start_at"
      t.date     "end_at"
      t.datetime "start_time"
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :emw_monitor_programs, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
