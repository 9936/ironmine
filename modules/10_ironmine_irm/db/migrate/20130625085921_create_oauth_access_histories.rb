class CreateOauthAccessHistories < ActiveRecord::Migration
  def change
    create_table :irm_oauth_access_histories, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "client_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "access_by", :limit => 22, :null => false, :collate => "utf8_bin"
      t.datetime "accessed_at"
      t.string   "access_api", :limit => 150
      t.string   "access_ip", :limit => 50
      t.text     "access_params"
      t.string   "success_flag", :limit => 1, :default => "Y"
      t.text     "error_message"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_oauth_access_histories, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
