class ChangeIncidentRelationId < ActiveRecord::Migration
  def change
    change_column :icm_incident_request_relations, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
