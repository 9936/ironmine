class CreateComIcmChmRelationTables < ActiveRecord::Migration
  def up
    create_table "icm_incident_config_relations", :force => true do |t|
      t.string   "opu_id",              :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "incident_request_id",  :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "config_item_id",   :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_incident_config_relations, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "icm_incident_config_relations", ["incident_request_id", "config_item_id"], :name => "ICM_INCIDENT_CONFIG_RELATIONS_U1", :unique => true

    create_table "chm_change_config_relations", :force => true do |t|
      t.string   "opu_id",              :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "change_request_id",  :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "config_item_id",   :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_config_relations, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_config_relations", ["change_request_id", "config_item_id"], :name => "CHM_CHANGE_CONFIG_RELATIONS_U1", :unique => true

  end

  def down
    drop_table :icm_incident_config_relations
    drop_table :chm_change_config_relations
  end
end
