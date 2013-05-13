class DeleteOldTasks < ActiveRecord::Migration
  def change
    drop_table :irm_calendars
    drop_table :irm_todo_events
    drop_table :irm_todo_tasks

    create_table "gtd_tasks", :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "external_system_id", :limit => 22, :collate => "utf8_bin"
      t.string "name", :limit => 150, :null => false
      t.text "description"
      t.string "task_type", :limit => 30
      t.text "rule"
      t.string "rule_type", :limit => 30
      t.integer "duration"
      t.datetime "plan_start_at"
      t.datetime "plan_end_date"
      t.datetime "start_at"
      t.datetime "end_date"
      t.string "assigned_to", :limit => 22, :collate => "utf8_bin"
      t.string "execute_status", :limit => 30
      t.string "notify_program_id", :limit => 22, :collate => "utf8_bin"
      t.string "parent_id", :limit => 22, :collate => "utf8_bin"
      t.string "incident_request_id", :limit => 22, :collate => "utf8_bin"
      t.string "who", :limit => 22, :collate => "utf8_bin"
      t.string "status_code", :limit => 30, :default => "ENABLED", :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :gtd_tasks, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
