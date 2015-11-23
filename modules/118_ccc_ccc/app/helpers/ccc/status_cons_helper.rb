module Ccc::StatusConsHelper
  # def available_request_status_code
  #   Icm::IncidentStatus.enabled.multilingual.query_by_close_flag(Irm::Constant::SYS_NO).order_display.collect{|i|[i[:name],i.id]}
  # end


  def available_request_status_children_code(external_system_id,incident_status_parent_id,profile_type)
    profile_type_id = Irm::Profile.find(profile_type).user_license
    status_con = Ccc::StatusCon.where(
        "external_system_id = ? AND incident_status_parent_id = ? AND profile_type_id LIKE ?",external_system_id,incident_status_parent_id,"%#{profile_type_id}%"
    ).first
    if status_con
      incident_status_children_ids = status_con.incident_status_children_id.split(",")
      puts Icm::IncidentStatus.where(id: incident_status_children_ids).to_sql
      Icm::IncidentStatus.where(id: incident_status_children_ids).enabled.multilingual.query_by_close_flag(Irm::Constant::SYS_NO).order_display.collect{|i|[i[:name],i.id]}
    else
      Icm::IncidentStatus.where(id: incident_status_parent_id).enabled.multilingual.query_by_close_flag(Irm::Constant::SYS_NO).order_display.collect{|i|[i[:name],i.id]}
    end
  end

  def available_profile_user_license
    Irm::LookupValue.query_by_lookup_type("IRM_PROFILE_USER_LICENSE").multilingual.order_id.collect{|p| [p[:meaning],p[:lookup_code]]}
  end
end
