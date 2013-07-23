class CreateInterfaceColumns < ActiveRecord::Migration
  def change
    create_table :emw_interface_columns, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "data_type", :limit => 30
      t.integer  "data_length"
      t.string   "error_flag", :limit => 1, :default => "N"
      t.string   "interface_table_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :emw_interface_columns, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
