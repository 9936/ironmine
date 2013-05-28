class CreateProgramHistories < ActiveRecord::Migration
  def change
    create_table :isp_program_histories, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "program_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.datetime "execute_at"
      t.text "report_content"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_program_histories, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "isp_program_histories", ["program_id"], :name => "SIP_PROGRAM_HISTORY_N1"

    create_table :isp_conn_histories, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "program_history_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "host", :limit => 150
      t.string "username", :limit => 150
      t.string "password", :limit => 150
      t.text "script"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_conn_histories, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "isp_conn_histories", ["program_history_id"], :name => "SIP_CONN_HISTORY_N1"

    create_table :isp_parameter_histories, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "conn_history_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "name", :limit => 150
      t.string "value", :limit => 150
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_parameter_histories, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "isp_parameter_histories", ["conn_history_id"], :name => "SIP_PARAMETER_HISTORY_N1"

  end
end
