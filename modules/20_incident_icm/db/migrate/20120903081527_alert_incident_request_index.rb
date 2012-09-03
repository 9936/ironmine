class AlertIncidentRequestIndex < ActiveRecord::Migration
  def up
    remove_index :icm_incident_requests,:name=>"ICM_INCIDENT_REQUESTS_N2"
    add_index :icm_incident_requests ,["incident_status_id"],:name=>"ICM_INCIDENT_REQUESTS_N2"
    add_index :icm_incident_requests ,["next_reply_user_license"],:name=>"ICM_INCIDENT_REQUESTS_N3"
    add_index :icm_incident_requests ,["last_request_date"],:name=>"ICM_INCIDENT_REQUESTS_N4"
    add_index :icm_incident_requests ,["last_response_date"],:name=>"ICM_INCIDENT_REQUESTS_N5"
  end

  def down
    remove_index :icm_incident_requests ,:name=>"ICM_INCIDENT_REQUESTS_N2"
    remove_index :icm_incident_requests ,:name=>"ICM_INCIDENT_REQUESTS_N3"
    remove_index :icm_incident_requests ,:name=>"ICM_INCIDENT_REQUESTS_N4"
    remove_index :icm_incident_requests ,:name=>"ICM_INCIDENT_REQUESTS_N5"
    add_index :icm_incident_requests,["incident_status_id","next_reply_user_license","last_request_date","last_response_date"],:name=>"ICM_INCIDENT_REQUESTS_N2"
  end
end
