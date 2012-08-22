Fwk::MenuAndFunctionManager.map do |map|
  #===================irm/hotlines============================
  #
  map.function :hotline_project_new,{"irm/projects" => ["new","edit","update", "create", "add_person", "create_person"]}
  map.function :view_hotline_project,{"irm/projects" => ["index","get_data", "show", "get_support_person_list_data", "get_customer_list_data"]}
  map.function :edit_hotline_project,{"irm/projects" => ["edit","update","add_person", "create_person", "add_supporters", "add_customers",
                                                         "remove_project_supporter", "add_customer_to_project", "add_supporter_to_project",
                                                         "remove_project_customer", "get_available_project_supporter_data",
                                                         "get_available_project_customer_data"]}
  map.function :edit_self_hotline_project,{}
  map.function :reply_incident_request,{"icm/incident_journals"=>[:get_incident_history_data]}
end