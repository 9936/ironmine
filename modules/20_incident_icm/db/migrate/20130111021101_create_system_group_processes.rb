class CreateSystemGroupProcesses < ActiveRecord::Migration
  def change
    create_table :icm_group_processes do |t|
      t.string   "opu_id",          :limit => 22 , :collate=>"utf8_bin"
      t.string   "external_system_id",:limit => 22 , :collate=>"utf8_bin"
      t.string   "category_id",     :limit => 22 , :collate=>"utf8_bin"
      t.string   "sub_category_id", :limit => 22 , :collate=>"utf8_bin"
      t.string   "urgence_id",      :limit => 22 , :collate=>"utf8_bin"
      t.string   "impact_range_id", :limit => 22 , :collate=>"utf8_bin"
      t.integer  "display_sequence",:default => 1
      t.string   "status_code",     :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",      :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",      :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_group_processes, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index :icm_group_processes, ["external_system_id"], :name => "ICM_PROCESSES_SYSTEM"


    create_table :icm_group_process_relations do |t|
      t.string   "opu_id",          :limit => 22 , :collate=>"utf8_bin"
      t.string   "group_process_id",      :limit => 22 , :collate=>"utf8_bin"
      t.string   "support_group_from",:limit => 22 , :collate=>"utf8_bin"
      t.string   "support_group_to",:limit => 22 , :collate=>"utf8_bin"
      t.string   "status_code",     :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",      :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",      :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_group_process_relations, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index :icm_group_process_relations, ["group_process_id"], :name => "ICM_PROCESSES_ID"
  end
end
