Irm::AccessControl.map do |map|

  map.function :config_relation_type,{"com/config_relation_types"=>["index", "show", "new", "create","edit", "update", "multilingual_edit", "multilingual_update","get_data"],
                                  "com/config_relation_members"=>["index", "show","destroy", "new", "create","edit", "update","get_data"]

  }

  map.function :config_class,{
      "com/config_classes"=>["index", "show","get_data", "new", "create", "edit", "update", "multilingual_edit", "multilingual_update"],
      "com/config_attributes"=>["index", "show","get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]
  }



end