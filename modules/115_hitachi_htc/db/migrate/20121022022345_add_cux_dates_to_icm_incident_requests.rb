class AddCuxDatesToIcmIncidentRequests < ActiveRecord::Migration
  def change
    add_column :icm_incident_requests, :cux_submit_time, :datetime, :after => "opu_id"
    add_column :icm_incident_requests, :cux_response_time, :datetime, :after => "opu_id"
    add_column :icm_incident_requests, :cux_resolve_time, :datetime, :after => "opu_id"
    add_column :icm_incident_requests, :cux_close_time, :datetime, :after => "opu_id"
    add_column :icm_incident_requests, :cux_response_hours, :integer, :after => "opu_id"
    add_column :icm_incident_requests, :cux_resolve_hours, :integer, :after => "opu_id"
  end
end
