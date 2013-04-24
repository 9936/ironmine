class CreateProgramReceivers < ActiveRecord::Migration
  def change
    create_table :isp_program_receivers, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "program_trigger_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "receiver_type", :limit => 30, :null => false
      t.string "receiver_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_program_receivers, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table "isp_program_schedules", :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "program_trigger_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.datetime "run_at", :null => false
      t.string "run_at_str", :limit => 30
      t.text "isp_program"
      t.string "run_status", :limit => 30, :default => "PENDING"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :isp_program_schedules, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
