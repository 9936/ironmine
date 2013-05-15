module Gtd::TasksHelper
  def available_systems
    external_systems_scope = Irm::ExternalSystem.multilingual.enabled.order("CONVERT( system_name USING gbk ) ")
    external_systems_scope = external_systems_scope.uniq
    external_systems_scope.collect{|i|[i[:system_name], i[:id]]}
  end

  def available_tasks_list_options
    [[I18n.t(:label_irm_todo_task_display_opts_open), "open"],
     [I18n.t(:label_irm_todo_task_display_opts_today), "today"],
     [I18n.t(:label_irm_todo_task_display_opts_over_due), "overdue"],
     [I18n.t(:label_irm_todo_task_display_opts_next_7_days), "in7day"]]
  end

  def available_task_types
    [[t(:label_gtd_task_type_task), "TASK"],
     [t(:label_gtd_task_type_instance), "INSTANCE"]
    ]
  end

  def available_member_types
    [[t(:label_gtd_task_member_public), "PUBLIC"],
     [t(:label_gtd_task_member_private), "PRIVATE"],
     [t(:label_gtd_task_member_member), "MEMBER"]
    ]
  end

  def available_access_types
    [[t(:label_gtd_task_access_read), "READ"],
     [t(:label_gtd_task_access_edit), "EDIT"]
    ]
  end

  def available_members(person_ids)
    Irm::Person.query_by_ids(person_ids).collect{|i| i.full_name}
  end

end
