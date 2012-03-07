class CreateOauthAccessClients < ActiveRecord::Migration
  def change
    create_table :irm_oauth_access_clients do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "code",      :limit => 30 ,:null=>false
      t.string   "name",      :limit => 60 ,:null=>false
      t.string   "description",      :limit => 150 
      t.string   "site_image_url",      :limit => 150 
      t.string   "site_url",      :limit => 150 
      t.string   "callback_url",      :limit => 240 
      t.string   "token",      :limit => 150 
      t.string   "secret",      :limit => 60 
      t.string   "status_code",      :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_oauth_access_clients, "id", :string,:limit=>22, :collate=>"utf8_bin"

  end
end
