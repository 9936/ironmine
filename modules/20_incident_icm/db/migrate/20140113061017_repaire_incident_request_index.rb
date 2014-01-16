class RepaireIncidentRequestIndex < ActiveRecord::Migration
  def up
    add_index(:icm_incident_requests, :external_system_id, :name => 'ICM_INCIDENT_REQUESTS_N6')
    add_index(:icm_incident_requests, :requested_by, :name => 'ICM_INCIDENT_REQUESTS_N7')
    add_index(:icm_incident_requests, :organization_id, :name => 'ICM_INCIDENT_REQUESTS_N8')
    add_index(:icm_incident_requests, :submitted_by, :name => 'ICM_INCIDENT_REQUESTS_N9')
    add_index(:icm_incident_requests, :close_reason_id, :name => 'ICM_INCIDENT_REQUESTS_N10')
    add_index(:icm_incident_requests, :urgence_id, :name => 'ICM_INCIDENT_REQUESTS_N11')
    add_index(:icm_incident_requests, :impact_range_id, :name => 'ICM_INCIDENT_REQUESTS_N12')
    add_index(:icm_incident_requests, :priority_id, :name => 'ICM_INCIDENT_REQUESTS_N13')
    add_index(:icm_incident_requests, :support_group_id, :name => 'ICM_INCIDENT_REQUESTS_N14')
    add_index(:icm_incident_requests, :support_person_id, :name => 'ICM_INCIDENT_REQUESTS_N15')
    remove_index(:icm_close_reasons_tl,:name=>"ICM_CLOSE_REASONS_TL_N1")
    remove_index(:icm_priority_codes_tl,:name=>"ICM_PRIORITY_CODES_TL_N1")
    remove_index(:icm_impact_ranges_tl,:name=>"ICM_IMPACT_RANGES_TL_N1")
    remove_index(:icm_urgence_codes_tl,:name=>"ICM_URGENCE_CODES_TL_N1")

  end

  def down
  end
end
