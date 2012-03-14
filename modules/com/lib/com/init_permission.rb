Irm::AccessControl.map do |map|
  #===================com/config_classes============================
  #["index", "new", "edit", "create", "update", "show", "get_data", "destroy", "multilingual_edit", "multilingual_update"]
  map.function :login_function,{"com/config_classes"=>["index", "show","get_data"]}
  map.function :login_function,{"com/config_classes"=>["new", "create"]}
  map.function :login_function,{"com/config_classes"=>["edit", "update", "multilingual_edit", "multilingual_update"]}


  #===================com/config_attributes============================
  #["index", "new", "edit", "create", "update", "show", "get_data", "destroy", "multilingual_edit", "multilingual_update"]
  map.function :login_function,{"com/config_attributes"=>["index", "show","get_data"]}
  map.function :login_function,{"com/config_attributes"=>["new", "create"]}
  map.function :login_function,{"com/config_attributes"=>["edit", "update", "multilingual_edit", "multilingual_update"]}

end