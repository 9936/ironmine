class ErrorTables < ActiveRecord::Migration
  def change
    create_table :emw_error_tables, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "interface_table_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "interface_column", :limit => 50
      t.string   "error_code_column", :limit => 50
      t.string   "error_message_column", :limit => 50
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :emw_error_tables, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
