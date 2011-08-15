Irm::AccessControl.map do |map|
  
  #map.function :view_external_systems,{"uid/external_systems"=>["index", "show"]}
  #map.function :create_external_systems,{"uid/external_systems"=>["new", "create"]}
  #map.function :edit_external_systems,{"uid/external_systems"=>["edit", "update",
  #                                                              "multilingual_edit",
  #                                                              "multilingual_update"]}
  #
  #===================irm/external_systems============================
  map.function :password_policy,{"uid/external_systems" => ["index", "update"]}
end