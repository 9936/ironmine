module Chm::ChangeRequestsHelper
  def change_incident_requests(change_request_id)
    incident_request_ids = Chm::ChangeIncidentRelation.where(:change_request_id=>change_request_id,:create_flag=>Irm::Constant::SYS_NO).collect{|i| i.incident_request_id}
    Icm::IncidentRequest.list_all.query_by_ids(incident_request_ids)
  end

  def change_master_incident_request(incident_request_id)
     Icm::IncidentRequest.list_all.query(incident_request_id).first
  end

end
