class CreateOauthCode < ActiveRecord::Migration
  def change
    create_table :irm_oauth_codes do |t|
      t.string   "opu_id",      :limit => 22 , :collate=>"utf8_bin"
      t.string   "oauth_access_client_id",      :limit => 22, :collate=>"utf8_bin"
      t.string   "person_id",      :limit => 22, :collate=>"utf8_bin"
      t.string   "code",      :limit => 150
      t.datetime "expire_at"
      t.string   "access_scope",      :limit => 60
      t.string   "status_code",      :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_oauth_codes, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
