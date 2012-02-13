Irm::AccessControl.map do |map|
  map.function :login_function,{"icm/incident_categories"=>["get_option"],
                                "icm/incident_sub_categories"=>["get_option"]}
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
  # 永久关闭事故单
  map.function :permanent_close_incdnt_request,{"icm/incident_journals"=>[:edit_permanent_close,:update_permanent_close]}
  # 重新打开事故单
  map.function :reopen_incident_request,{"icm/incident_journals"=>[:edit_reopen,:update_reopen]}
  # 转交事故单
  map.function :pass_incident_request,{"icm/incident_journals"=>[:edit_pass,:update_pass,:edit_upgrade,:update_upgrade],
                                       "icm/support_groups"=>[:get_pass_member_options]}
  # 升级事故单
  map.function :upgrade_incident_request,{"icm/incident_journals"=>[:edit_upgrade,:update_upgrade],
                                       "icm/support_groups"=>[:get_member_options]}
  # 分配事故单
  map.function :assign_incident_request,{"icm/incident_requests"=>[:assign_dashboard,:assignable_data,:assign_request]}
  # 查看所有事故单
  map.function :view_all_incident_request ,{"icm/incident_requests"=>[:index, :info_card]}
  # 为他人提交事故单
  map.function :create_icdt_rqst_for_other,{"icm/incident_requests"=>[:new,:create]}
  #编辑事故单状态
  map.function :incident_request_assign_me,{"icm/incident_requests"=>[:edit_assign_me,:assign_me_data,:update_assign_me]}
  #领取事故单
  map.function :incident_request_edit_status,{"icm/incident_journals"=>[:edit_status,:update_status]}
  map.function :view_icm_kanban,{"icm/incident_requests" => [:kanban_index]}

  map.function :edit_relation, {"icm/incident_requests" => [:add_relation, :remove_relation]}
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


  #===================icm/support_groups============================
  #["index", "update", "create", "get_member_options"]
  map.function :icm_support_group,{"icm/support_groups"=>["index","create","update"]}


  #===================icm/incident_phases============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "multilingual_edit", "multilingual_update"]
  map.function :icm_phase,{"icm/incident_phases"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================icm/incident_statuses============================
  #["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "show", "edit_transform", "update_transform"]
  map.function :icm_status,{"icm/incident_statuses"=>["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "show", "edit_transform", "update_transform"]}

  #===================icm/close_reasons============================
  #["index", "edit", "update", "new", "create", "show", "get_data"]
  map.function :icm_close_reason,{"icm/close_reasons"=>["index", "show", "get_data","new", "create","edit", "update"]}


  #====================irm/watchers ========================================
  map.function :view_watcher, {"irm/watchers" => ["order"]}
  map.function :edit_watcher, {"irm/watchers" => ["add_watcher", "delete_watcher"]}

  #====================icm/mail_requests====================================
  map.function :view_mail_request, {"icm/mail_requests" => ["index", "get_data", "show"]}
  map.function :edit_mail_request, {"icm/mail_requests" => ["new", "create", "edit", "update", "disable", "enable"]}


  #===================icm/incident_categories============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "multilingual_edit", "multilingual_update"]
  #===================icm/incident_sub_categories============================
  #["edit", "update", "new", "create", "show", "multilingual_edit", "multilingual_update", "destroy"]
  map.function :incident_category,{"icm/incident_categories"=>["index", "edit", "update", "new", "create", "get_data", "show", "multilingual_edit", "multilingual_update"],
  "icm/incident_sub_categories"=>["edit", "update", "new", "create", "show", "multilingual_edit", "multilingual_update", "destroy"]}

end