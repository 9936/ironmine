module Icm::IncidentPermissionCheckHelper
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

  #检查是否具有升级权限
  def can_upgrade?(incident_request)
    if current_person?(incident_request.support_person_id) &&
        available_upgradable_supporter(incident_request.support_group_id).any? &&
        allow_to_function?(:system_upgrade_request, incident_request.external_system_id)
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

  #检查是否具有取消权限
  def can_cancel?(incident_request)

  end

  #检查是否具有删除回复附件功能
  def can_delete_comment_file?(file, incident_request)
    if allow_to_function?(:remove_attachment) ||
        allow_to_function?(:system_delete_file_anyone, incident_request.external_system_id)
      return true
    elsif allow_to_function?(:system_delete_file_mine, incident_request.external_system_id) &&
        (current_person?(file.created_by))
      return true
    else
      return false
    end
  end

  #检查是否具有编辑回复权限
  def can_edit_comment?(journal, incident_request)
    if allow_to_function?(:edit_any_journal) || allow_to_function?(:system_edit_comment_anyone, incident_request.external_system_id)
      return true
    elsif (allow_to_function?(:edit_self_journal) ||
            allow_to_function?(:system_edit_comment_mine, incident_request.external_system_id)) &&
            current_person?(journal[:replied_by])
      return true
    else
      return false
    end
  end

  #检查是否具有添加关联权限
  def can_relation?(incident_request)
    if allow_to_function?(:edit_relation) and
        allow_to_function?(:system_relation_request, incident_request[:external_system_id])
      return true
    else
      return false
    end
  end

  #检查是否具有添加跟踪者权限
  def can_watcher?(watchable)
    if allow_to_function?(:system_watcher_anyone, watchable[:external_system_id]) ||
        allow_to_function?(:system_watcher_mine, watchable[:external_system_id])
      return true
    else
      return false
    end
  end

end