class AddCuxOrganizationToIcmIncidentRequests < ActiveRecord::Migration
  def up
    add_column :icm_incident_requests, :cux_organization_id, :string, :limit => 22, :after => "opu_id"
  end

  def down
    remove_column :icm_incident_requests, :cux_organization_id
  end
end
