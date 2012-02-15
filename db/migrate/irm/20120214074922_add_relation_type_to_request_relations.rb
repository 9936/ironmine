class AddRelationTypeToRequestRelations < ActiveRecord::Migration
  def up
    add_column :icm_incident_request_relations, :relation_type, :string, :limit => 10, :null => false, :after => :target_id
  end

  def down
    remove_column :icm_incident_request_relations,:relation_type
  end
end
