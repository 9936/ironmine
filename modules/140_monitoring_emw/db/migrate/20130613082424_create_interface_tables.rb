class CreateInterfaceTables < ActiveRecord::Migration
  def change
    create_table :emw_interface_tables, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "table_name", :limit => 50
      t.string   "error_table", :limit => 50
      t.string   "interface_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :emw_interface_tables, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
