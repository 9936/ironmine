Fwk::AccessControl.map do |map|
  #===================slm/service catalogs============================
  map.function :service_category,{"slm/service_categories" => ["index", "edit", "update", "new", "create", "show", "get_data"]}
  map.function :service_catalog,{"slm/service_catalogs" => ["index", "edit", "update", "new", "create", "show", "get_data"],
                                 "slm/service_members" => ["new", "create", "edit", "update"],
                                 "slm/service_breaks" => ["new", "create", "edit", "update"]}
  map.function :service_agreement,{"slm/service_agreements" => ["index", "edit", "update", "new", "create", "show", "get_data"]}

end