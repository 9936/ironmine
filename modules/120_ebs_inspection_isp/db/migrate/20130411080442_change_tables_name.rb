class ChangeTablesName < ActiveRecord::Migration
  def up
    drop_table :sip_programs
    drop_table :sip_programs_tl
    execute("DROP VIEW sip_programs_vl")
    drop_table :sip_connections
    drop_table :sip_check_parameters
    drop_table :sip_check_items

    create_table :isp_programs, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_programs, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :isp_programs_tl, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "program_id", :limit => 22, :collate => "utf8_bin"
      t.string "language", :limit => 30, :null => false
      t.string "name", :limit => 150
      t.string "description", :limit => 240
      t.string "source_lang", :limit => 30, :null => false
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_programs_tl, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "isp_programs_tl", ["program_id", "language"], :name => "ISP_PROGRAMS_TL_U1", :unique => true
    add_index "isp_programs_tl", ["program_id"], :name => "ISP_PROGRAMS_TL_N1"

    execute('CREATE OR REPLACE VIEW isp_programs_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
             FROM isp_programs t,isp_programs_tl tl WHERE t.id = tl.program_id')


    create_table :isp_connections, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "program_id", :limit => 22, :collate => "utf8_bin"
      t.string "name", :limit => 150
      t.string "description", :limit => 240
      t.string "connect_type", :limit => 30
      t.string "host", :limit => 150
      t.string "username", :limit => 150
      t.string "password", :limit => 150
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_connections, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "isp_connections", ["program_id"], :name => "ISP_CONNECTIONS_TL_N1"



    create_table :isp_check_parameters, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "program_id", :limit => 22, :collate => "utf8_bin"
      t.string "name", :limit => 150
      t.string "description", :limit => 240
      t.string "param_type", :limit => 30
      t.string "data_type", :limit => 30
      t.string "object_symbol"
      t.string "value", :limit => 150
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_check_parameters, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "isp_check_parameters", ["program_id"], :name => "ISP_CHECK_PARAMETERS_TL_N1"


    create_table :isp_check_items, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "program_id", :limit => 22, :collate => "utf8_bin"
      t.string "connection_id", :limit => 22, :collate => "utf8_bin"
      t.string "name", :limit => 150
      t.string "description", :limit => 240
      t.string "object_symbol", :limit => 240
      t.text "script"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_check_items, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "isp_check_items", ["program_id"], :name => "ISP_CHECK_ITEMS_TL_N1"
  end

end
