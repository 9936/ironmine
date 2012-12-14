module Hli::IncidentPermissionCheckHelperEx
  def self.included(base)
    base.class_eval do
      #检查是否具有转交权限
      def can_pass?(incident_request)
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

      #检查是否具有状态编辑权限
      def can_edit_status?(incident_request)
        if allow_to_function?(:incident_request_edit_status) ||
            allow_to_function?(:system_status_anyone, incident_request.external_system_id)
          return true
        elsif allow_to_function?(:system_status_mine, incident_request.external_system_id) &&
            (current_person?(incident_request.submitted_by) ||
                current_person?(incident_request.support_person_id) ||
                current_person?(incident_request.requested_by) )
          return true
        else
          return false
        end
      end

      #检查是否具有关闭权限
      def can_close?(incident_request)
        if allow_to_function?(:close_incident_request) ||
            allow_to_function?(:system_close_anyone, incident_request.external_system_id)
          return true
        elsif allow_to_function?(:system_close_mine, incident_request.external_system_id) &&
            (current_person?(incident_request.submitted_by) ||
                current_person?(incident_request.support_person_id) ||
                current_person?(incident_request.requested_by) )
          return true
        else
          return false
        end
      end

      #检查是否具有编辑权限
      def can_edit?(incident_request)
        if allow_to_function?(:edit_incident_request) ||
            allow_to_function?(:system_edit_anyone, incident_request.external_system_id)
          return true
        elsif allow_to_function?(:system_edit_mine, incident_request.external_system_id) &&
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
end