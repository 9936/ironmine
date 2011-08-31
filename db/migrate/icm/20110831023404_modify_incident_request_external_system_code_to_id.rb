class ModifyIncidentRequestExternalSystemCodeToId < ActiveRecord::Migration
  def self.up
    rename_column :icm_incident_requests, :external_system_code, :external_system_id
    change_column :icm_incident_requests, :external_system_id, :string, :limit => 22
  end

  def self.down
    rename_column :icm_incident_requests, :external_system_id, :external_system_code
    change_column :icm_incident_requests, :external_system_code, :string, :limit => 22
  end
end
