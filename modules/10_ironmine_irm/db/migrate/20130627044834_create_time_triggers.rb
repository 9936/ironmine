class CreateTimeTriggers < ActiveRecord::Migration
  def change
    create_table :irm_time_triggers, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "target_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "target_type", :limit => 50, :null => false
      t.text "time_mode"
      t.date "start_at", :null => false
      t.date "end_at", :null => false
      t.datetime "start_time"
      t.integer  "schedule_days", :default => 2
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_time_triggers, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "irm_time_triggers", ["target_id"], :name => "IRM_TIME_TRIGGERS_N1"

    create_table :irm_time_schedules, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "time_trigger_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.datetime "run_at", :null => false
      t.string "run_at_str", :limit => 30
      t.string "run_status", :limit => 30, :default => "PENDING"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_time_schedules, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
