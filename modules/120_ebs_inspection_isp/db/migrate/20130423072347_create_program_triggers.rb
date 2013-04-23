class CreateProgramTriggers < ActiveRecord::Migration
  def change
    create_table :isp_program_triggers, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "program_id", :limit => 22, :collate => "utf8_bin"
      t.string "person_id",     :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "receiver_type", :limit => 22, :null => false
      t.text   "time_mode", :null => false
      t.date   "start_at",  :null => false
      t.date   "end_at", :null => false
      t.datetime "start_time"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_program_triggers, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "isp_program_triggers", ["program_id"], :name => "ISP_PROGRAM_TRIGGER_N1"

  end
end
