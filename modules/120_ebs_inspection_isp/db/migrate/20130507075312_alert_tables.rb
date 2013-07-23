class AlertTables < ActiveRecord::Migration
  def change
    #修改参数表
    rename_column :isp_check_parameters, :program_id, :check_item_id
    remove_index :isp_check_parameters, :name => :ISP_CHECK_PARAMETERS_TL_N1
    add_index "isp_check_parameters", ["check_item_id"], :name => "ISP_CHECK_PARAMETERS_TL_N1"

    #修改巡检项表
    remove_column :isp_check_items, :program_id
    remove_column :isp_check_items, :connection_id


    #创建巡检项连接关系表
    create_table :isp_connection_items, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "connection_id", :limit => 22, :collate => "utf8_bin"
      t.string "check_item_id", :limit => 22, :collate => "utf8_bin"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_connection_items, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "isp_connection_items", ["connection_id"], :name => "ISP_CONNECTION_ITEMS_TL_N1"

  end
end
