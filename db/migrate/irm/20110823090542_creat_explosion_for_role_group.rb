class CreatExplosionForRoleGroup < ActiveRecord::Migration
  def self.up
    create_table "irm_role_explosions", :force => true do |t|
      t.string "parent_role_id",        :limit => 22,:null => false
      t.string "direct_parent_role_id", :limit => 22,:null => false
      t.string "role_id",      :limit => 22,:null => false
      t.string "opu_id",               :limit => 22,:null => false
      t.string   "status_code",        :limit => 30, :default=>"ENABLED"
      t.string  "created_by",          :limit => 22,:null => false
      t.string  "updated_by",          :limit => 22,:null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :irm_role_explosions, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_role_explosions", ["parent_role_id","direct_parent_role_id","role_id"],:name => "IRM_ROLE_EXPLOSIONS_U1", :unique => true
    create_table "irm_group_explosions", :force => true do |t|
      t.string "parent_group_id",        :limit => 22,:null => false
      t.string "direct_parent_group_id", :limit => 22,:null => false
      t.string "group_id",      :limit => 22,:null => false
      t.string "opu_id",               :limit => 22,:null => false
      t.string   "status_code",        :limit => 30, :default=>"ENABLED"
      t.string  "created_by",          :limit => 22,:null => false
      t.string  "updated_by",          :limit => 22,:null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :irm_group_explosions, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_group_explosions", ["parent_group_id","direct_parent_group_id","group_id"],:name => "IRM_GROUP_EXPLOSIONS_U1", :unique => true
  end

  def self.down
    drop_table :irm_role_explosions
    drop_table :irm_group_explosions
  end
end
