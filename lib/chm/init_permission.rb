Irm::AccessControl.map do |map|
  map.function :change_status,{"chm/change_statuses"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :change_urgency,{"chm/change_urgencies"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :change_impact,{"chm/change_impacts"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :change_priority,{"chm/change_priorities"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :change_request,{"chm/change_requests"=>["index", "show", "get_data","show_plan","show_implement","show_approve"]}
  map.function :change_plan_type,{"chm/change_plan_types"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :new_change_request,{"chm/change_requests"=>["incident_new","new", "create"]}
  map.function :edit_change_request,{"chm/change_requests"=>["edit", "update"]}
  map.function :change_journal,{"chm/change_journals"=>["create"]}
  map.function :change_plan,{"chm/change_plans"=>["change","refresh","create","update"]}
  map.function :change_task_phase,{"chm/change_task_phases"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :change_task_template,{"chm/change_task_templates"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"],
                                "chm/change_template_tasks"=>["show","new", "create","edit", "update", "destroy"]}
  map.function :change_task,{"chm/change_tasks"=>["show","new", "create","edit", "update", "destroy","template_new","template_create"],"chm/change_task_templates"=>["show_tasks"]}

  map.function :change_incident,{"chm/change_requests"=>["show_incident"],"chm/change_incident_relations"=>["new","create","destroy","incident_requests"]}
  # 查看事故单
  map.function :view_incident_request,{"chm/change_requests"=>["show_detail"]}


  map.function :advisory_board,{"chm/advisory_boards"=>["index", "show", "get_data","new", "create","edit", "update"],
                                "chm/advisory_board_members"=>["create","new","get_data","destroy"]}

  map.function :change_approve,{"chm/change_approvals"=>["new","create","destroy","get_available_member"]}

  map.function :approve_change,{}

  map.function :perform_change_task,{}
end