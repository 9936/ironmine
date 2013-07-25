class CreateEmwDatabaseItems < ActiveRecord::Migration
  def change
    create_table :emw_database_items do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "database_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "description", :limit => 240
      t.string   "script_type", :limit => 240,:null => false
      t.text   "script"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps
    end
    change_column :emw_database_items, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end