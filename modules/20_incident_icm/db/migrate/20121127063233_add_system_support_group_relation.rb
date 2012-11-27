class AddSystemSupportGroupRelation < ActiveRecord::Migration
  def change
    create_table "icm_external_system_groups", :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false
      t.string   "external_system_id",  :limit => 22, :collate => "utf8_bin"
      t.string   "support_group_id",    :limit => 22, :collate => "utf8_bin"
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_external_system_groups, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index "icm_external_system_groups", ["external_system_id", "support_group_id"], :name => "IRM_EXTERNAL_SYSTEM_GROUP_N1"
  end
end
