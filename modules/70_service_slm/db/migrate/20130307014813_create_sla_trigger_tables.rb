class CreateSlaTriggerTables < ActiveRecord::Migration
  def up
    create_table "slm_sla_instances", :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "service_agreement_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "bo_type" , :limit => 30 , :null => false
      t.string "bo_id" , :limit => 22, :null => false, :collate => "utf8_bin"
      t.integer "max_duration", :null => false, :default => 0
      t.datetime "start_at"
      t.datetime "end_at"
      t.integer "current_duration", :null => false, :default => 0
      t.string "current_status", :limit => 30, :default => "START"
      t.string "last_phase_type", :limit => 30, :default => "START"
      t.datetime "last_phase_start_date"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.integer "created_by", :limit => 22, :null => false, :collate => "utf8_bin"
      t.integer "updated_by", :limit => 22, :null => false, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_sla_instances, "id", :string, :limit => 22, :collate => "utf8_bin"


    create_table "slm_sla_instance_phases", :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "sla_instance_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "phase_type", :limit => 30, :null => false
      t.datetime "start_at", :null => false
      t.datetime "end_at"
      t.integer "duration"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.integer "created_by", :limit => 22, :null => false, :collate => "utf8_bin"
      t.integer "updated_by", :limit => 22, :null => false, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_sla_instance_phases, "id", :string, :limit => 22, :collate => "utf8_bin"


    create_table "slm_sla_instance_triggers", :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "sla_instance_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "time_trigger_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.datetime "trigger_date"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.integer "created_by", :limit => 22, :null => false, :collate => "utf8_bin"
      t.integer "updated_by", :limit => 22, :null => false, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_sla_instance_triggers, "id", :string, :limit => 22, :collate => "utf8_bin"

  end

  def down
    drop_table :slm_sla_instances
    drop_table :slm_sla_instance_phases
    drop_table :slm_sla_instance_triggers
  end
end
