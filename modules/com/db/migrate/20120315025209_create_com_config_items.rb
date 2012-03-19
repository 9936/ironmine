class CreateComConfigItems < ActiveRecord::Migration
  def change
    create_table :com_config_items do |t|
      t.string   "opu_id",      :limit => 22 , :collate=>"utf8_bin"
      t.string   "item_number",   :limit => 30,:null => false
      t.string   "config_class_id",   :limit => 22 , :collate=>"utf8_bin",:null=>false
      t.string   "managed_group_id",   :limit => 22 , :collate=>"utf8_bin"
      t.string   "managed_person_id",   :limit => 22 , :collate=>"utf8_bin"
      t.datetime "last_checked_at"
      t.string   "status_code",   :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
  end
  change_column :com_config_items, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
