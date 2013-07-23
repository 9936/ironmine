class CreateMonitorHistories < ActiveRecord::Migration
  def change
    create_table :emw_monitor_histories, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "monitor_program_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "execute_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "execute_at"
      t.text     "execute_script"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :emw_monitor_histories, "id", :string, :limit => 22, :collate => "utf8_bin"

  end
end
