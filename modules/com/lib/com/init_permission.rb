Irm::AccessControl.map do |map|
  map.function :login_function,{"com/config_relation_types"=>["index", "show", "new", "create","edit", "update", "multilingual_edit", "multilingual_update","get_data"],
                                  "com/config_relation_members"=>["index", "show", "new", "create","edit", "update","get_data"]

  }

end