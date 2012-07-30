Irm::AccessControl.map do |map|
  map.function :login_function,{"skm/wiki_templates"=>["index", "show", "get_data","new", "create","edit", "update","preview","sample"] }
  map.function :login_function,{

  }

  #===================skm/entry_statuses============================
  #["index", "edit", "update", "new", "create", "get_data", "show"]
  map.function :skm_status,{"skm/entry_statuses"=>["index", "show", "get_data","new", "create","edit", "update"]}

  #===================skm/entry_templates============================
  #["index", "edit", "update", "new", "create", "get_data", "show", "remove_element", "add_elements", "select_elements", "get_owned_elements_data", "get_available_elements", "up_element", "down_element", "edit_detail", "update_detail"]
  map.function :skm_template,{"skm/entry_templates"=>["index", "show", "get_data","get_data_rest", "get_owned_elements_data",
                                                        "select_elements","new", "create", "add_elements",
                                                        "get_available_elements","edit", "update", "edit_detail",
                                                        "update_detail", "remove_element", "up_element", "down_element"]}

  #===================skm/entry_template_elements============================
  #["index", "edit", "update", "new", "create", "get_data", "show"]
  map.function :skm_template_element,{"skm/entry_template_elements"=>["index", "show", "get_data","new", "create","edit", "update"]}

  #===================skm/settings ====================================
  map.function :skm_setting, {"skm/settings" => ["index","edit", "update"]}


  #===================skm/entries ==========================================
  map.function :view_skm_entries, {"skm/entry_headers" => ["index", "show", "index_search", "get_history_entries_data", "get_data",
                                                           "my_favorites_data", "my_favorites", "add_favorites", "data_grid", "my_drafts",
                                                           "my_drafts_data", "remove_favorite", "video_show","my_unpublished","my_unpublished_data"],
                                   "icm/incident_journals" => ["get_entry_header_data", "apply_entry_header", "apply_entry_header_link"],
                                   "skm/entry_templates" => ["get_owned_elements_data"],
                                   "skm/file_managements" => ["index", "new", "create", "batch_create", "edit", "update", "show",
                                                              "get_data", "destroy", "get_version_files"],
                                   "skm/columns" => ["get_columns_data"]}
  map.function :create_skm_entries, {"skm/entry_headers" => ["new", "create","new_relation","create_relation", "new_step_1", "new_step_2",
                                                             "new_step_3", "new_step_4", "new_from_icm_request",
                                                             "remove_exits_attachment_during_create", "create_from_icm_request",
                                                             "new_step_video_upload", "video_create","reset_approve"]}
  map.function :edit_skm_entries, {"skm/entry_headers" => ["edit", "update", "remove_exits_attachment_during_create", "remove_exits_attachment", "video_edit", "video_update"]}
  map.function :edit_relation, {"skm/entry_headers" => ["add_relation", "remove_relation"]}

  #map.function :approve_skm_entries, {"skm/entry_headers"=>["wait_my_approve","wait_my_approve_data","approve_knowledge"]  }

  map.function :login_function,{ "skm/entry_reports" => ["get_rpt_apply_data", "get_rpt_show_data", "get_search_history_data"],
                                 "skm/entry_headers"=>["wait_my_approve","wait_my_approve_data","approve_knowledge","knowledge_details"]}

  map.function :skm_column,{"skm/columns" => ["index", "edit", "update", "new", "create", "get_columns_data"]}

  map.function :skm_channel, {"skm/channels" => ["index", "get_data", "show", "get_owned_groups_data", "get_ava_groups_data",
                                                 "get_all_columns_data", "get_owned_channels", "get_ava_channels","get_approvals_data","get_owned_approvals_data"]}
  map.function :edit_skm_channel, {"skm/channels" => ["edit", "update", "new", "create", "multilingual_edit", "multilingual_update",
                                                      "new_groups","create_groups","remove_group","new_approvals","create_approvals","remove_approval"],
                                   "irm/groups" => ["new_skm_channels", "create_skm_channels", "remove_skm_channel"]}
  #===================skm/entry_headers#portlet============================
  map.function :entry_header_portlet,{"skm/entry_headers"=>["portlet"]}
  #====================skm/wikis===============================
  map.function :view_wiki,{"skm/wikis" => ["index","get_data","show","compare","history"],"skm/books"=>["index", "show", "get_data"]}
  map.function :create_wiki,{"skm/wikis" => ["new","create","preview","new_word","create_word"],"skm/books"=>["new", "create"], "skm/book_wikis"=>[ "create", "destroy","order"]}
  map.function :edit_wiki,{"skm/wikis" => ["edit","update","preview","edit_chapter","update_chapter"],"skm/books"=>["edit", "update"], "skm/book_wikis"=>[ "create", "destroy","order"]}
  map.function :manage_wiki,{"skm/wikis" => ["destroy","revert"],"skm/books"=>["edit", "update","publish"]}
end