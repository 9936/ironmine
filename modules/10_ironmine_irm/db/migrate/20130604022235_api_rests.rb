class ApiRests < ActiveRecord::Migration
  def up
    create_table :irm_rest_apis, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "permission_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "method", :limit => 20, :default => "GET"
      t.string   "name", :limit => 30
      t.text     "description"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_rest_apis, "id", :string, :limit => 22, :collate => "utf8_bin"
    rename_column :irm_api_params, :permission_id, :rest_api_id
    remove_column :irm_api_params, :method
  end

  def down
    drop_table :irm_rest_apis
    rename_column :irm_api_params, :rest_api_id, :permission_id
    add_column :irm_api_params, "method", :limit => 20, :default => "GET"
  end
end
