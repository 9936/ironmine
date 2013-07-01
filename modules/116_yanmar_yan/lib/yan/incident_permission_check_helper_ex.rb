module Yan::IncidentPermissionCheckHelperEx
  def self.included(base)

    def can_edit_addition_info?(incident_request)
      if allow_to_function?(:edit_additional_info, incident_request[:external_system_id])
        return true
      else
        return false
      end
    end

  end
end