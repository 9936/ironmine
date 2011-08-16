class ModifyIncidentRequestModuleTables < ActiveRecord::Migration
  def self.up
    remove_column :icm_incident_requests,:urgence_code
    remove_column :icm_incident_requests,:impact_range_code
    remove_column :icm_incident_requests,:priority_code
    remove_column :icm_incident_requests,:incident_status_code
    remove_column :icm_incident_requests,:close_reason_code
    add_column :icm_incident_requests,:close_reason_id,:string,:limit=>22 ,:after=>:report_source_code
    add_column :icm_incident_requests,:urgence_id,:string,:limit=>22 ,:after=>:report_source_code
    add_column :icm_incident_requests,:impact_range_id,:string,:limit=>22 ,:after=>:report_source_code
    add_column :icm_incident_requests,:priority_id,:string,:limit=>22 ,:after=>:report_source_code
    add_column :icm_incident_requests,:incident_status_id,:string,:limit=>22 ,:after=>:report_source_code
    add_column :icm_incident_journals,:reply_type,:string,:limit=>30,:after=>:incident_request_id
  end

  def self.down
    add_column :icm_incident_requests,:urgence_code,:string,:limit=>30
    add_column :icm_incident_requests,:impact_range_code ,:string,:limit=>30
    add_column :icm_incident_requests,:priority_code ,:string,:limit=>30
    add_column :icm_incident_requests,:incident_status_code ,:string,:limit=>30
    add_column :icm_incident_requests,:close_reason_code ,:string,:limit=>30
    remove_column :icm_incident_requests,:close_reason_id
    remove_column :icm_incident_requests,:urgence_id
    remove_column :icm_incident_requests,:impact_range_id
    remove_column :icm_incident_requests,:priority_id
    remove_column :icm_incident_requests,:incident_status_id
    remove_column :icm_incident_journals,:reply_type
  end
end
