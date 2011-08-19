Irm::AccessControl.map do |map|
  #============= 系统主页==============================
  # 主页
  map.function :home_page,{"irm/home"=>[:index], "irm/calendars" => ["get_full_calendar"]}
  map.function :public_function,{"irm/demo" => [:index],
                                 "irm/common"=>[:login, :forgot_password,:edit_password,:update_password],
                                 "irm/navigations" => ["access_deny", "combo"],
                                 "irm/attach_screenshot" => ["index"]}
  map.function :login_function,{ "irm/filters" => ["edit", "new", "create", "update", "index", "operator_value"],
                                 "irm/setting" => ["common"],
                                 "irm/navigations" => ["change_application", "index"],
                                 "irm/kanbans" => ["refresh_my_kanban"],
                                 "irm/support_group_members"=>["get_options"],"irm/search"=>[:index]}
  #=====common setting===================
  #===================irm/global_settings============================
  #["index", "edit", "update", "crop"]
  map.function :global_setting,{"irm/global_settings"=>["index","edit", "update"]}
  #===================irm/lookup_types irm/lookup_values============================
  map.function :lookup_code,{"irm/lookup_types"=>["index", "show", "get_lookup_types","new", "create", "create_value", "create_edit_value", "add_code","create_edit_value", "edit", "update"],
                             "irm/lookup_values"=>["index", "show", "get_lookup_values", "select_lookup_type","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================irm/general_categories============================
  map.function :general_category,{"irm/general_categories"=>["index", "show", "get_data","new", "create","edit", "update"]}

  #===================irm/flex_value_sets irm/flex_values============================
  map.function :value_set,{"irm/flex_value_sets"=>["index", "show", "get_data","new", "create","edit", "update"],
                           "irm/flex_values"=>["index", "show", "get_data", "select_set","new", "create","edit", "update"]}

  #===================irm/id_flexes irm/id_flex_structures irm/id_flex_segments============================
  map.function :id_flex,{"irm/id_flexes"=>["index", "show", "get_data","new", "create","edit", "update"],
                           "irm/id_flex_structures"=>["index", "show", "get_data", "select_parent","new", "create","edit", "update"],
                           "irm/id_flex_segments"=>["index", "show", "get_data","new", "create","edit", "update"]}

  #===================irm/companies irm/locations============================
  map.function :company,{"irm/companies"=>["index", "show", "get_data", "site_info","new", "create", "add_site_info", "create_location",
                                          "edit", "update", "multilingual_edit", "multilingual_update", "edit_location", "update_location",
                                           "get_company_site", "get_company_info", "get_support_group", "get_choose_company"],
                                "irm/locations"=>["index", "show", "get_data","new", "create","edit", "update"]}

  #===================irm/organizations============================
  map.function :organization,{"irm/organizations"=>["index", "show", "get_data", "belongs_to", "get_by_company",
                                                    "new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================irm/departments============================
  map.function :department,{"irm/departments"=>["index", "show", "get_data", "belongs_to",
                                                "get_by_organization","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================irm/people============================
  map.function :person,{"irm/people"=>["index", "show", "get_data", "get_choose_people","new", "create",
                                       "get_support_group", "get_owned_roles","edit", "update",
                                       "multilingual_edit", "multilingual_update","add_roles","remove_role",
                                       "select_roles", "get_available_roles"],
                             "irm/company_accesses"=>["index","new", "create"], "uid/external_system_members" => ["new_from_person"]}

  #===================irm/regions============================
  #["index", "get_data", "edit", "update", "new", "show", "create", "multilingual_edit", "multilingual_update"]
  map.function :region,{"irm/regions"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================irm/site_groups============================
  #["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "get_current_group_site", "create_site", "belongs_to", "show", "add_site", "edit_site", "update_site", "current_site_group", "multilingual_site_edit", "multilingual_site_update", "get_by_region_code"]
  #===================irm/sites============================
  #["index", "get_data", "edit", "update", "new", "show", "create", "select_site", "multilingual_edit", "multilingual_update", "get_by_site_group_code"]
  map.function :site,{"irm/sites" => ["index", "show", "get_data", "select_site", "get_by_site_group_code","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  map.function :site_group,{"irm/site_groups" =>["index", "show", "get_data", "get_current_group_site", "get_by_region_code", "belongs_to","new", "create","edit", "update", "multilingual_edit", "multilingual_update"],}

  #===================irm/support_groups============================
  #["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "belongs_to", "add_persons", "get_support_group_member", "choose_person", "create_member", "delete_member", "show"]
  #===================irm/support_group_members============================
  #["index", "edit", "update", "delete", "new", "create", "get_data", "select_person", "get_person"]
  map.function :support_group,{"irm/support_groups"=>["index", "show", "get_data", "get_support_group_member", "choose_person","new", "create",
                                                       "edit", "update", "multilingual_edit", "multilingual_update","delete_member", "create_member"],
                                     "irm/support_group_members"=>["get_person", "get_options","select_person", "create","delete_from_person",
                                                                   "new_from_person","get_person_support_group","create_from_person"]}

  #=====permission ===================

  #===================irm/roles============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "multilingual_edit", "multilingual_update"]
  map.function :role,{"irm/roles"=>["index", "edit", "update", "new", "create", "edit_assignment", "update_assignment", "assignable_people", "role_people", "show", "multilingual_edit", "multilingual_update"]}

  #===================irm/mail_templates============================
  #["new", "get_data", "create", "copy", "copy_template", "test_mail_template", "index", "edit", "update", "destroy", "show", "get_script_context_fields", "get_mail_templates"]
  map.function :mail_template,{"irm/mail_templates"=>["index", "show", "get_data", "get_script_context_fields",
                                                            "get_mail_templates","new", "create","edit", "update"],
                               "irm/object_attributes"=>["all_columns"]}

  #===================irm/menus============================
  #["index", "new", "create", "get_data", "edit", "update", "show", "remove_entry", "multilingual_edit", "multilingual_update"]
  #===================irm/menu_entries============================
  #["index", "new", "create", "get_data", "edit", "update", "destroy", "select_parent", "show"]
  map.function :menu,{"irm/menus"=>["index", "show", "get_data","new", "create","edit", "update",
                                    "multilingual_edit", "multilingual_update", "remove_entry"],
                      "irm/menu_entries"=>["index", "show", "get_data", "select_parent","new", "create","edit", "update"]}

  #===================irm/function_groups============================
  #["index", "edit", "update", "new", "create", "show", "get_data"]
  map.function :function_group,{"irm/function_groups"=>["index", "show", "get_data","new", "create","edit", "update"]}

  #===================irm/functions============================
  #["index", "edit", "update", "new", "create", "show", "get_data", "add_permissions", "get_available_permissions", "select_permissions", "add_permissions", "remove_permission"]
  map.function :function,{"irm/functions"=>["index", "show", "get_data","new", "create", "add_permissions", "add_permissions","edit", "update"]}

 #===================irm/currencies============================
  #["index", "get_data", "edit", "update", "new", "show", "create", "multilingual_edit", "multilingual_update"]
  map.function :currency,{"irm/currencies"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  #===================irm/languages============================
  #["index", "get_data", "edit", "update", "new", "show", "create", "multilingual_edit", "multilingual_update"]
  map.function :language,{"irm/languages"=>["index", "show", "get_data","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  #===================irm/product_modules============================
  #["index", "edit", "update", "new", "create", "get_data", "data_grid"]
  map.function :product_module,{"irm/product_modules"=>["index", "get_data","new", "create","edit", "update"]}

  #===================irm/wf_tasks============================
  #["index", "show_permissions", "show_permissions_data", "show_missed_permissions", "missed_permissions_data"]
  map.function :todo_event,{"irm/todo_events"=>["index", "show", "quick_show", "calendar_view","new", "create","edit",
                                                "update","edit_recurrence", "update_recurrence",
                                                "my_events_index", "get_data", "get_top_data", "my_events_get_data"]}

  #===================irm/wf_tasks============================
  #["index", "show_permissions", "show_permissions_data", "show_missed_permissions", "missed_permissions_data"]
  map.function :todo_task,{"irm/todo_tasks"=>["index", "show","new", "create","edit", "update","edit_recurrence", "update_recurrence",
                                                    "my_tasks_index", "get_data","get_top_data", "my_tasks_get_data"]}

  #===================irm/business_objects============================
  #["index", "new", "create", "get_data", "edit", "update", "show", "execute_test", "multilingual_edit", "multilingual_update"]
  #===================irm/object_attributes============================
  #["index", "new", "create", "get_data", "edit", "update", "show", "destroy", "multilingual_edit", "multilingual_update", "relation_columns", "selectable_columns"]
  map.function :business_object,{"irm/business_objects"=>["index", "show", "get_data","new", "create","edit",
                                                          "update", "multilingual_edit", "multilingual_update"],
                                 "irm/object_attributes"=>["index", "show", "get_data","get_standard_data","new", "create", "selectable_columns",
                                                           "relation_columns","edit", "update", "multilingual_edit", "multilingual_update",
                                                           "selectable_columns", "relation_columns","change_type"]}

  #===================irm/list_of_values============================
  #["index", "new", "create", "get_data", "edit", "update", "show", "multilingual_edit", "multilingual_update", "execute_test", "get_lov_data"]
  map.function :list_of_value,{"irm/list_of_values"=>["index", "show", "get_lov_data", "get_data","new", "create",
                                                      "edit", "update", "multilingual_edit", "multilingual_update"]}

  #====================irm/my_info =================================
  map.function :my_info, {"irm/my_info" => ["index", "filter_company"],
                          "irm/company_accesses"=>["get_data"],
                          "irm/people"=>["get_owned_external_systems", "get_support_group"]}
  map.function :my_password,{"irm/my_password" => ["index","edit_password", "update_password"]}
  map.function :my_login_history ,{"irm/my_login_history" => ["index", "get_login_data"]}
  map.function :my_avatar,{"irm/my_avatar" => ["index","avatar_crop", "edit", "update"]}

  #====================irm/bulletins ==================================
  map.function :bulletin, {"irm/bulletins" => ["index", "show", "get_data","new", "create","edit", "update"]}
  map.function :edit_bulletin, {"irm/bulletins" => ["edit", "update"]}
  map.function :new_bulletin, {"irm/bulletins" => ["new", "create"]}
  map.function :delete_bulletin, {"irm/bulletins" => ["destroy", "remove_exits_attachments"]}
  #====================irm/watchers ========================================
  map.function :view_watchers, {}
  map.function :edit_watchers, {"irm/watchers" => ["add_watcher", "delete_watcher"]}

  #===================irm/wf_settings============================
  #["index", "edit", "update"]
  map.function :workflow_setting,{"irm/wf_settings"=>["index","edit", "update"]}
  #===================irm/wf_rules============================
  #["index", "new", "create", "get_data", "edit", "update", "show"]
  map.function :workflow_rule,{"irm/wf_rules"=>["index", "show","new", "create","add_exists_action","save_exists_action","edit", "update","active","add_exists_action","save_exists_action"]}

  #===================irm/ldap_sources============================
  #["index", "edit", "execute_test", "active", "update", "new", "create", "get_data", "show"]
  map.function :ldap_source,{"irm/ldap_sources"=>["index", "show","new", "create","edit", "update","active"]}
  #===================irm/ldap_auth_headers============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "get_by_ldap_source"]
  #===================irm/ldap_auth_attributes============================
  #["index", "new", "create", "get_data", "edit", "update", "show", "destroy"]
  map.function :ldap_user,{"irm/ldap_auth_headers"=>["index", "show","get_by_ldap_source",
                                                            "new", "create","edit", "update"],
                                  "irm/ldap_auth_attributes"=>["index", "show","new", "create",
                                                               "edit", "update"]}


  #===================irm/ldap_syn_headers============================
  #["index", "edit", "execute_test", "execute_test", "update", "new", "create",  "get_data", "show", "active"]
    #===================irm/ldap_syn_attributes============================
  #["index", "new", "create", "get_data", "edit", "show", "update", "destroy"]
  map.function :ldap_organization,{"irm/ldap_syn_headers"=>["index", "show","new", "create","edit", "update","active"],
                                 "irm/ldap_auth_headers"=>["get_by_ldap_source"],
                                 "irm/ldap_syn_attributes"=>["index", "show","new", "create","edit", "update"]}

  #===================irm/wf_field_updates============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "destroy", "set_value"]
  #===================irm/formula_functions============================
  #["formula_function_options", "check_syntax"]

  map.function :workflow_field_update,{"irm/wf_field_updates"=>["index", "show","get_data","new", "create","destroy","set_value","edit", "update"],
                                       "irm/wf_approval_processes"=>["get_data_by_action"],
                                       "irm/formula_functions"=>["formula_function_options", "check_syntax"],
                                       "irm/wf_rules"=>["get_data_by_action"],
                                       "irm/object_attributes"=>["updateable_columns"]}

  #===================irm/wf_mail_alerts============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "destroy", "recipient_source"]
  map.function :workflow_mail_alert,{"irm/wf_mail_alerts"=>["index", "show","get_data","new", "create",
                                                            "recipient_source","destroy","edit", "update","recipient_source"],
                                     "irm/wf_approval_processes"=>["get_data_by_action"],
                                     "irm/wf_rules"=>["get_data_by_action"]}
  #===================irm/wf_approval_processes============================
  #["index", "new", "create", "get_data", "edit", "active", "update", "destroy", "show", "destroy_action", "add_exists_action", "save_exists_action", "destroy_action", "reorder"]
  #===================irm/wf_approval_steps============================
  #["index", "new", "create", "edit", "update", "destroy"]
  map.function :workflow_process,{"irm/wf_approval_processes"=>["index", "show","new", "create","edit", "update",
                                                                "destroy_action", "add_exists_action", "save_exists_action", "reorder"],
                                  "irm/wf_approval_steps"=>["index","new", "create","edit", "update"]}

  #===================irm/wf_process_instances============================
  #["submit", "recall"]
  #===================irm/wf_step_instances============================
  #["show", "reassign", "submit", "save_reassign"]
  map.function :workflow_approval,{"irm/wf_step_instances"=>["show", "reassign", "submit", "save_reassign"],
                                     "irm/wf_process_instances"=>["submit", "recall"]}

  #=================== job monitors ============================
  map.function :monitor_group_assign,{"irm/monitor_icm_group_assigns"=>["index"]}
  map.function :monitor_workflow_rule,{"irm/monitor_ir_rule_processes"=>["index"]}
  map.function :monitor_delayed_jobs,{"irm/delayed_jobs"=>["index"]}
  map.function :monitor_approve_mail,{"irm/monitor_approval_mails"=>["index"]}


  #===================irm/report_type_categories============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "multilingual_edit", "multilingual_update"]
  map.function :report_type_category,{"irm/report_type_categories"=>["index", "show","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}
  #===================irm/report_types===========================
  #["index", "edit", "update", "edit_relation", "update_relation", "new", "create", "get_data", "show", "multilingual_edit", "multilingual_update"]
  #===================irm/report_type_sections============================
  #["index", "update", "field_source", "section_field"]
  map.function :report_type,{"irm/report_types"=>["index", "show","new", "create","edit", "update", "edit_relation", "update_relation", "multilingual_edit", "multilingual_update"],
                             "irm/report_type_sections"=>["index", "update", "field_source", "section_field"]}

  map.function :kanban,{"irm/kanbans"=>["index", "show", "get_data", "refresh_my_kanban",
                                        "get_owned_lanes","new", "create","edit", "update",
                                        "up_lane", "down_lane", "add_lanes", "delete_lane",
                                        "select_lanes", "get_available_lanes"]
                             }
  map.function :kanban_lane,{"irm/lanes" => ["index", "show", "get_data","new", "create","edit", "update", "delete_card", "select_cards", "get_available_cards"]}
  map.function :kanban_card,{"irm/cards" => ["index", "show", "get_data","new", "create","edit", "update", "edit_rule", "update_rule"]}

  #===================irm/reports============================
  #["index", "edit", "update", "new", "run", "operator_value", "create", "get_data", "show", "multilingual_edit", "multilingual_update", "destroy", "edit_custom", "update_custom"]
  map.function :view_reports,{"irm/reports"=>["index", "show","run","get_data"]}
  map.function :create_reports,{"irm/reports"=>["new", "create","operator_value","destroy"]}
  map.function :edit_reports,{"irm/reports"=>["edit", "update","operator_value", "multilingual_edit", "multilingual_update", "edit_custom", "update_custom"]}
  #===================irm/report_folders============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "multilingual_edit", "multilingual_update"]
  map.function :view_report_folders,{"irm/report_folders"=>["index"]}
  map.function :create_report_folders,{"irm/report_folders"=>["new", "create"]}
  map.function :edit_report_folders,{"irm/report_folders"=>["edit", "update", "multilingual_edit", "multilingual_update"]}


  #===================irm/tabs============================
  #["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "show"]
  map.function :tab,{"irm/tabs"=>["index", "show","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================irm/applications============================
  #["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "show"]
  map.function :application,{"irm/applications"=>["index", "show","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================irm/profiles============================
  #["index", "edit", "update", "new", "create", "multilingual_edit", "multilingual_update", "get_data", "show"]
  map.function :profile,{"irm/profiles"=>["index", "show","new", "create","edit", "update", "multilingual_edit", "multilingual_update"]}

  #===================irm/bu_columns============================
  map.function :bulletin_column,{"irm/bu_columns" => ["index", "edit", "update", "new", "create", "get_columns_data"]}

  #===================irm/password_policies============================
  map.function :password_policy,{"irm/password_policies" => ["index", "update"]}
end
