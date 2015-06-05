module Ysq::IncidentPermissionCheckHelperEx
  def self.included(base)

    def can_edit_addition_info?(incident_request)
      if allow_to_function?(:edit_additional_info, incident_request[:external_system_id])
        return true
      else
        return false
      end
    end

    def can_edit_workload?(incident_request)
      if allow_to_function?(:edit_workload_self, incident_request[:external_system_id])
        return true
      else
        return false
      end
    end

    #检查是否具有转交权限
    def can_pass?(incident_request)
      if incident_request.support_person_id.blank?
        return false
      end

      if allow_to_function?(:pass_incident_request) || allow_to_function?(:system_pass_anyone, incident_request.external_system_id)
        return true
      elsif allow_to_function?(:system_pass_mine, incident_request.external_system_id) &&
          (current_person?(incident_request.submitted_by) ||
              current_person?(incident_request.support_person_id) ||
              current_person?(incident_request.requested_by) )
        return true
      else
        return false
      end
    end
  end
end