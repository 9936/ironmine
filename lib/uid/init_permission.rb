Irm::AccessControl.map do |map|
  
  #map.function :view_external_systems,{"uid/external_systems"=>["index", "show"]}
  #map.function :create_external_systems,{"uid/external_systems"=>["new", "create"]}
  #map.function :edit_external_systems,{"uid/external_systems"=>["edit", "update",
  #                                                              "multilingual_edit",
  #                                                              "multilingual_update"]}
  #
  #===================irm/external_systems============================
  map.function :system,{"uid/external_systems" => ["index", "update","edit","show","new","create"]}
  map.function :external_loingid,{"uid/external_logins" => ["index", "update","edit","new","create"]}
  map.function :login_mapping,{"uid/login_mappings" => ["index", "update","new","edit","create"]}
  map.function :external_system_member,{"uid/external_system_members" => ["index"]}
end