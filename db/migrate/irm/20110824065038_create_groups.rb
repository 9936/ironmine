class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table "irm_groups", :force => true do |t|
      t.string "parent_group_id",        :limit => 22,:null => false
      t.string "code", :limit => 30,:null => false
      t.string "opu_id",               :limit => 22,:null => false
      t.string   "status_code",        :limit => 30, :default=>"ENABLED"
      t.string  "created_by",          :limit => 22,:null => false
      t.string  "updated_by",          :limit => 22,:null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :irm_groups, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    create_table "irm_groups_tl", :force => true do |t|
      t.string    "group_id",:limit => 22,:null => false
      t.string    "name",          :limit=>30,:null=>false
      t.string    "description",   :limit=>150
      t.string    "language",      :limit=>30
      t.string    "source_lang",   :limit=>30
      t.string    "opu_id", :limit => 22,:null => false
      t.string    "status_code",   :limit => 30, :default=>"ENABLED"
      t.integer   "created_by"
      t.integer   "updated_by"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end

    change_column :irm_groups_tl, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_groups_tl", ["group_id", "language"], :name => "IRM_GROUPS_TL_U1", :unique => true

    execute('CREATE OR REPLACE VIEW irm_groups_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_groups t,irm_groups_tl tl
                                                 WHERE t.id = tl.group_id')


    create_table "irm_group_members", :force => true do |t|
      t.string    "group_id",:limit => 22,:null => false
      t.string    "person_id",:limit => 22,:null => false
      t.string    "opu_id", :limit => 22,:null => false
      t.string    "status_code",   :limit => 30, :default=>"ENABLED"
      t.integer   "created_by"
      t.integer   "updated_by"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end

    change_column :irm_group_members, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_group_members", ["group_id", "person_id"], :name => "IRM_GROUP_MEMBERS_U1", :unique => true

    drop_table :irm_support_groups
    drop_table :irm_support_groups_tl
    execute('drop view irm_support_groups_vl')

    drop_table :irm_support_group_members

    create_table "icm_support_groups", :force => true do |t|
      t.string    "group_id",:limit => 22,:null => false
      t.string    "assignment_process_code",:limit => 30,:null => false
      t.string    "vendor_flag",:limit => 1,:null => false ,:default=>"N"
      t.string    "oncall_flag",:limit => 1,:null => false ,:default=>"N"
      t.string    "opu_id", :limit => 22,:null => false
      t.string    "status_code",   :limit => 30, :default=>"ENABLED"
      t.integer   "created_by"
      t.integer   "updated_by"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end

    change_column :icm_support_groups, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"


  end

  def self.down
    drop_table :irm_groups
    drop_table :irm_groups_tl
    execute('drop view irm_groups_vl')
    drop_table :irm_group_members


    create_table "irm_support_groups", :force => true do |t|
      t.string   "opu_id",                  :limit => 22
      t.string   "organization_id",         :limit => 22
      t.string   "group_code",              :limit => 30,                  :null => false
      t.string   "parent_group_id",         :limit => 22
      t.string   "assignment_process_code", :limit => 30
      t.string   "support_role_code",       :limit => 30,                  :null => false
      t.string   "vendor_group_flag",       :limit => 1,  :default => "N", :null => false
      t.string   "oncall_group_flag",       :limit => 1,  :default => "N", :null => false
      t.string   "status_code",             :limit => 30,                  :null => false
      t.string   "created_by",              :limit => 22
      t.string   "updated_by",              :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end


    create_table "irm_support_groups_tl", :force => true do |t|
      t.string   "support_group_id", :limit => 22
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150, :null => false
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",      :limit => 30,  :null => false
      t.string   "created_by",       :limit => 22
      t.string   "updated_by",       :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end


    execute('CREATE OR REPLACE VIEW irm_support_groups_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_support_groups t,irm_support_groups_tl tl
                                                 WHERE t.id = tl.support_group_id')

    drop_table :icm_support_groups
  end
end
