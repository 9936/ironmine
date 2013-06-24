class CreateConnections < ActiveRecord::Migration
  def change
    create_table :emw_connections, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
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
    change_column :emw_connections, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
