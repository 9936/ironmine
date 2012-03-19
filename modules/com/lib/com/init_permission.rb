Irm::AccessControl.map do |map|

  map.function :config_relation_type,{"com/config_relation_types"=>["index", "show", "new", "create","edit", "update", "multilingual_edit", "multilingual_update","get_data"],
                                  "com/config_relation_members"=>["index", "show","destroy", "new", "create","edit", "update","get_data"]

  }

  map.function :config_class,{
      "com/config_classes"=>["index", "show","get_class_tree","get_data", "new", "create", "edit", "update", "multilingual_edit", "multilingual_update"],
      "com/config_attributes"=>["index", "show","get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]
  }



  map.function :config_item,{"com/config_items"=>["index", "show","destroy", "new", "get_dynamic_attributes","create","edit", "update","get_data"],
                                "com/config_item_relations"=>["index", "show","destroy", "new","create","edit", "update","get_data"]}


end