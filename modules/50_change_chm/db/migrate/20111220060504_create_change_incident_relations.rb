class CreateChangeIncidentRelations < ActiveRecord::Migration
  def up
    create_table "chm_change_incident_relations", :force => true do |t|
      t.string   "opu_id",              :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "change_request_id",   :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "incident_request_id",  :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "create_flag",  :limit => 1, :null => false, :default=>"N"
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_incident_relations, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_incident_relations", ["change_request_id", "incident_request_id"], :name => "CHM_CHANGE_INCIDENT_RELATIONS_U1", :unique => true

  end

  def down
    drop_table :chm_change_incident_relations
  end
end
