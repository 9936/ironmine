class AddIndexToWorkload < ActiveRecord::Migration
  def change
    add_index :icm_incident_workloads ,["incident_request_id"],:name=>"ICM_INCIDENT_WORKLOADS_N1"
    add_index :icm_incident_workloads ,["incident_journal_id"],:name=>"ICM_INCIDENT_WORKLOADS_N2"
    add_index :icm_incident_workloads ,["incident_status_id"],:name=>"ICM_INCIDENT_WORKLOADS_N3"
    add_index :icm_incident_workloads ,["person_id"],:name=>"ICM_INCIDENT_WORKLOADS_N4"
    add_index :icm_incident_workloads ,["start_time"],:name=>"ICM_INCIDENT_WORKLOADS_N5"
  end
end
