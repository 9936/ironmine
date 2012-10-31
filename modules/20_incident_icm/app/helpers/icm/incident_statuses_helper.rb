module Icm::IncidentStatusesHelper
  def available_incident_phase()
    Icm::IncidentPhase.multilingual.enabled.collect{|v| [v[:name],v[:phase_code]]}
  end

  def available_incident_status(sid='')
    if sid.present?
      Icm::IncidentStatus.where(:sid => sid).enabled.multilingual.order("default_flag DESC,permanent_close_flag,close_flag,display_sequence")
    else
      Icm::IncidentStatus.enabled.multilingual.order("default_flag DESC,permanent_close_flag,close_flag,display_sequence")
    end
  end

  def available_incident_request_event
    Irm::LookupValue.query_by_lookup_type("ICM_INCIDENT_REQUEST_EVENT").enabled.multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def available_status_transform(sid = '')
    transform_scope = []
    if sid.present?
      transform_scope = Icm::StatusTransform.with_sid(sid)
    end
    if transform_scope.empty? || sid.blank?
      transform_scope = Icm::StatusTransform.with_global
    end
    status_transforms = {}
    transform_scope.each do |st|
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

  def incident_status_color(status_id)
    status = Icm::IncidentStatus.find(status_id)
    return status.display_color
  end
end
