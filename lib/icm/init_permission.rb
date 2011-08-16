Irm::AccessControl.map do |map|
  map.function :login_function,{ "icm/incident_reports" => [:get_urgency_summary,:get_report_summary]}
  #============= 事故单==============================
  # 查看事故单
  map.function :view_incident_request,{"icm/incident_requests"=>[:index, :get_data, :get_help_desk_data,
                                                                 :get_external_systems,
                                                                 :get_slm_services],
                                       "icm/incident_journals"=>[:index,:new]}
  # 创建事故单
  map.function :create_incident_request,{"icm/incident_requests"=>[:new,:create, :short_create]}
  # 编辑事故单
  map.function :edit_incident_request,{"icm/incident_requests"=>[:edit,:update]}
  # 回复事故单
  map.function :reply_incident_request,{"icm/incident_journals"=>[:index,:new,:create,
                                                                  :get_entry_header_data, :apply_entry_header]}
  # 关闭事故单
  map.function :close_incident_request,{"icm/incident_journals"=>[:edit_close,:update_close]}
  # 转交事故单
  map.function :pass_incident_request,{"icm/incident_journals"=>[:edit_pass,:update_pass,:edit_upgrade,:update_upgrade]}
  # 分配事故单
  map.function :assign_incident_request,{"icm/incident_requests"=>[:assign_dashboard,:assignable_data,:assign_request]}
  # 查看所有事故单
  map.function :view_all_incident_request ,{"icm/incident_requests"=>[:index]}
  # 为他人提交事故单
  map.function :create_icdt_rqst_for_other,{"icm/incident_requests"=>[:new,:create]}


  #===================icm/rule_settings============================
  #["index", "edit", "update", "new", "create", "get_data", "show"]
  map.function :icm_rule_setting,{"icm/rule_settings"=>["index", "show", "get_data","new", "create","edit", "update"]}

  #===================icm/urgence_codes============================
  #["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "show"]
  map.function :icm_urgence_code,{"icm/urgence_codes"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================icm/impact_ranges============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "multilingual_edit", "multilingual_update"]
  map.function :icm_impact_range,{"icm/impact_ranges"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================icm/priority_codes============================
  #["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "show"]
  map.function :icm_priority_code,{"icm/priority_codes"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================icm/group_assignments============================
  #["index", "edit", "update", "new", "create", "get_data", "destroy", "get_customer_departments", "get_customer_sites", "get_customer_site_groups", "get_customer_people", "get_customer_organizations"]
  map.function :icm_group_assignment,{"icm/group_assignments"=>["index", "get_data","new", "create","edit", "update"],
                                       "icm/incident_requests" => ["get_all_slm_services"]}

  #===================icm/incident_phases============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "multilingual_edit", "multilingual_update"]
  map.function :icm_phase,{"icm/incident_phases"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================icm/incident_statuses============================
  #["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "show", "edit_transform", "update_transform"]
  map.function :icm_status,{"icm/incident_statuses"=>["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "show", "edit_transform", "update_transform"]}

  #===================icm/close_reasons============================
  #["index", "edit", "update", "new", "create", "show", "get_data"]
  map.function :icm_close_reason,{"icm/close_reasons"=>["index", "show", "get_data","new", "create","edit", "update"]}

end