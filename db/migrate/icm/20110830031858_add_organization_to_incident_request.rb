class AddOrganizationToIncidentRequest < ActiveRecord::Migration
  def self.up
    add_column :icm_incident_requests,:organization_id,:string,:limit=>22,:after=>:requested_by
  end

  def self.down
    remove_column :icm_incident_requests,:organization_id
  end
end
