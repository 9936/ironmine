Irm::AccessControl.map do |map|
  map.function :login_function,{"chm/change_statuses"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :login_function,{"chm/change_urgencies"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

end