module Icm::IncidentStatusesHelper
  def available_incident_phase()
    Icm::IncidentPhase.multilingual.enabled.collect{|v| [v[:name],v[:phase_code]]}
  end

  def available_incident_status
    Icm::IncidentStatus.multilingual.order("default_flag DESC,close_flag,display_sequence")
  end

  def available_incident_request_event
    Irm::LookupValue.query_by_lookup_type("ICM_INCIDENT_REQUEST_EVENT").enabled.multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def available_status_transform
    status_transforms = {}
    Icm::StatusTransform.all.each do |st|
      status_transforms[st.from_status_id]||= {}
      status_transforms[st.from_status_id].merge!({st.to_status_id=>st.event_code})
    end
    status_transforms
  end

  def available_incident_event_name
    names = {}
    Irm::LookupValue.query_by_lookup_type("ICM_INCIDENT_REQUEST_EVENT").enabled.multilingual.each{|p|names.merge!({p[:lookup_code]=>p[:meaning]})}
    names
  end
end
