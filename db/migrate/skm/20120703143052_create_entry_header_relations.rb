class CreateEntryHeaderRelations < ActiveRecord::Migration
  def up
    create_table :skm_entry_header_relations, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false
      t.string   "source_id", :limit => 22, :null => false
      t.string   "target_id", :limit => 22, :null => false
      t.string   "relation_type",  :limit => 10, :null => false
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :skm_entry_header_relations, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index :skm_entry_header_relations, ["source_id", "target_id"], :name => "SKM_ENTRY_HEADER_RELATION_U1", :unique => true
  end

  def down
    drop_table :skm_entry_header_relations
  end
end
