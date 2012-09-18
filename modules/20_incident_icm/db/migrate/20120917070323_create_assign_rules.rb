class CreateAssignRules < ActiveRecord::Migration
  def up
    create_table :icm_assign_rules, :force => true do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "support_group_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "join_type",      :limit => 3,  :default => "OR", :null => false
      t.integer  "sequence",         :default => 1
      t.string   "status_code",      :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_assign_rules, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index :icm_assign_rules, ["support_group_id","id"], :name => "ICM_GROUP_RULE_N1"
  end

  def down
    drop_table :icm_assign_rules
  end
end
