Irm::AccessControl.map do |map|
  map.function :change_status,{"chm/change_statuses"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :change_urgency,{"chm/change_urgencies"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :change_impact,{"chm/change_impacts"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :change_priority,{"chm/change_priorities"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :change_request,{"chm/change_requests"=>["index", "show", "get_data","show_incident","show_plan","show_implement","show_approve"]}
  map.function :new_change_request,{"chm/change_requests"=>["new", "create"]}
  map.function :edit_change_request,{"chm/change_requests"=>["edit", "update"]}
end