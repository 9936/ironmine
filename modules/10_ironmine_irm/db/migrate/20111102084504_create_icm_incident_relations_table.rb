class CreateIcmIncidentRelationsTable < ActiveRecord::Migration
  def up
    create_table "icm_incident_request_relations", :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "source_id", :limit => 22, :null => false
      t.string "target_id", :limit => 22, :null => false
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    drop_table "icm_incident_request_relations"
  end
end
