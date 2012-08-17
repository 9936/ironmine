class CreateUserTokens < ActiveRecord::Migration
  def up
    create_table :irm_user_tokens,:force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false
      t.string   "person_id", :limit => 22, :null => false
      t.string   "token",  :limit => 150
      t.string   "token_type", :limit => 30
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_user_tokens, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index :irm_user_tokens, ["token_type", "person_id"], :name => "IRM_TOKEN_TYPE_U1", :unique => true
  end

  def down
    drop_table :irm_user_tokens
  end
end
