class CreateOauthToken < ActiveRecord::Migration
  def change
    create_table :irm_oauth_tokens do |t|
      t.string   "opu_id",      :limit => 22 , :collate=>"utf8_bin"
      t.string   "client_id",      :limit => 22, :collate=>"utf8_bin"
      t.string   "user_id",        :limit => 22, :collate=>"utf8_bin"
      t.string   "oauth_code_id",  :limit => 22, :collate=>"utf8_bin"
      t.string   "token",      :limit => 150
      t.string   "refresh_token",      :limit => 150
      t.datetime "expire_at"
      t.string   "relation_oauth_token_id", :limit => 22, :collate=>"utf8_bin"
      t.string   "access_scope",      :limit => 60
      t.string   "status_code",      :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_oauth_tokens, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
