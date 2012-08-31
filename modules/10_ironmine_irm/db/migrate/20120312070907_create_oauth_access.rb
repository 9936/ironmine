class CreateOauthAccess < ActiveRecord::Migration
  def change
    create_table :irm_oauth_accesses do |t|
      t.string   "opu_id",      :limit => 22 , :collate=>"utf8_bin"
      t.string   "token_id",      :limit => 22, :collate=>"utf8_bin"
      t.string   "ip_address",    :limit => 30
      t.integer   "times"
      t.string   "status_code",   :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_oauth_accesses, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
