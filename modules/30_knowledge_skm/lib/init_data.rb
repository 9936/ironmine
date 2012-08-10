#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #====================================START:KNOWLEDGE_MANAGEMENT======================================
  map.menu :knowledge_management, {
      :en => {:name => "Knowledge Base Setting", :description => "Knowledge Base Setting"},
      :zh => {:name => "知识库管理", :description => "知识库管理"},
      :children => {
          :skm_status => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Status", :description => "Status"},
                  :zh => {:name => "知识状态", :description => "创建、编辑知识文章状态"},
              }},
          :skm_template => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Template", :description => "Template"},
                  :zh => {:name => "知识模板", :description => "创建、编辑知识模板，或管理模板中的模板元素"},
              }},
          :skm_template_element => {
              :type => "function",
              :entry => {
                  :sequence => 30,
                  :en => {:name => "Template Element", :description => "Template Element"},
                  :zh => {:name => "知识模板元素", :description => "创建、编辑知识模板元素"},
              }},
          :skm_setting => {
              :type => "function",
              :entry => {
                  :sequence => 40,
                  :en => {:name => "Setting", :description => "Setting"},
                  :zh => {:name => "知识库设置", :description => "修改知识库参数设置"},
              }},
          :skm_column => {
              :type => "function",
              :entry => {
                  :sequence => 50,
                  :en => {:name => "Skm Category", :description => "Skm Category"},
                  :zh => {:name => "知识分类", :description => "添加、编辑公告分类，或定义分类的层次结构"},
              }},
          :skm_channel => {
              :type => "function",
              :entry => {
                  :sequence => 60,
                  :en => {:name => "Channel", :description => "Channel"},
                  :zh => {:name => "知识频道", :description => "新建一个知识频道，或管理频道的可访问用户组"},
              }},
      }
  }
  #====================================END:KNOWLEDGE_MANAGEMENT======================================

  #=================================START:KNOWLEDGE_MANAGEMENT=================================
  map.function_group :knowledge_management, {
      :en => {:name => "Knowledge Management", :description => "Knowledge Management"},
      :zh => {:name => "知识库", :description => "管理知识模板、模板元素、频道、分类以及知识库全局设置"}, }
  map.function_group :knowledge_management, {
      :zone_code => "KNOWLEDGE_MANAGEMENT",
      :controller => "skm/entry_headers",
      :action => "index"}
  map.function_group :knowledge_management, {
      :children => {
          :view_skm_entries => {
              :en => {:name => "View Skm Entries", :description => "View Skm Entries"},
              :zh => {:name => "查看知识库文章", :description => "查看知识库文章"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "icm/incident_journals" => ["apply_entry_header", "apply_entry_header_link", "get_entry_header_data"],
              "skm/columns" => ["get_columns_data"],
              "skm/entry_headers" => ["add_favorites", "data_grid", "get_data", "get_history_entries_data", "index", "index_search", "my_drafts", "my_drafts_data", "my_favorites", "my_favorites_data", "my_unpublished", "my_unpublished_data", "remove_favorite", "show", "video_show"],
              "skm/entry_templates" => ["get_owned_elements_data"],
              "skm/file_managements" => ["batch_create", "create", "destroy", "edit", "get_data", "get_version_files", "index", "new", "show", "update"],
          },
          :edit_skm_entries => {
              :en => {:name => "Edit Skm Entries", :description => "Edit Skm Entries"},
              :zh => {:name => "编辑知识库文章", :description => "编辑知识库文章"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/entry_headers" => ["edit", "remove_exits_attachment", "remove_exits_attachment_during_create", "update", "video_edit", "video_update"],
          },
          :create_skm_entries => {
              :en => {:name => "Create Skm Entries", :description => "Create Skm Entries"},
              :zh => {:name => "新建知识库文章", :description => "新建知识库文章"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/entry_headers" => ["create", "create_from_icm_request", "create_relation", "new", "new_from_icm_request", "new_relation", "new_step_1", "new_step_2", "new_step_3", "new_step_4", "new_step_video_upload", "remove_exits_attachment_during_create", "video_create"],
          },
          :approve_skm_entries => {
              :en => {:name => "Approve Skm Entries", :description => "Approve Skm Entries"},
              :zh => {:name => "审核知识库文章", :description => "审核知识库文章"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/entry_headers" => ["approve_knowledge", "wait_my_approve", "wait_my_approve_data"],
          },
      }
  }
  #=================================END:KNOWLEDGE_MANAGEMENT=================================

  #=================================START:SKM_STATUS=================================
  map.function_group :skm_status, {
      :en => {:name => "Status", :description => "Status"},
      :zh => {:name => "知识状态", :description => "创建、编辑知识文章状态"}, }
  map.function_group :skm_status, {
      :zone_code => "SKM_SETTING",
      :controller => "skm/entry_statuses",
      :action => "index"}
  map.function_group :skm_status, {
      :children => {
          :skm_status => {
              :en => {:name => "Manage Status", :description => "Manage Status"},
              :zh => {:name => "管理知识状态", :description => "管理知识状态"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/entry_statuses" => ["create", "edit", "get_data", "index", "new", "show", "update"],
          },
      }
  }
  #=================================END:SKM_STATUS=================================

  #=================================START:SKM_TEMPLATE=================================
  map.function_group :skm_template, {
      :en => {:name => "Template", :description => "Template"},
      :zh => {:name => "知识模板", :description => "创建、编辑知识模板，或管理模板中的模板元素"}, }
  map.function_group :skm_template, {
      :zone_code => "SKM_SETTING",
      :controller => "skm/entry_templates",
      :action => "index"}
  map.function_group :skm_template, {
      :children => {
          :skm_template => {
              :en => {:name => "Manage Template", :description => "Manage Template"},
              :zh => {:name => "管理知识模板", :description => "管理知识模板"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/entry_templates" => ["add_elements", "create", "down_element", "edit", "edit_detail", "get_available_elements", "get_data", "get_data_rest", "get_owned_elements_data", "index", "new", "remove_element", "select_elements", "show", "update", "update_detail", "up_element"],
          },
      }
  }
  #=================================END:SKM_TEMPLATE=================================

  #=================================START:SKM_TEMPLATE_ELEMENT=================================
  map.function_group :skm_template_element, {
      :en => {:name => "Template Element", :description => "Template Element"},
      :zh => {:name => "知识模板元素", :description => "创建、编辑知识模板元素"}, }
  map.function_group :skm_template_element, {
      :zone_code => "SKM_SETTING",
      :controller => "skm/entry_template_elements",
      :action => "index"}
  map.function_group :skm_template_element, {
      :children => {
          :skm_template_element => {
              :en => {:name => "Manage Template Element", :description => "Manage Template Element"},
              :zh => {:name => "管理知识模板元素", :description => "管理知识模板元素"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/entry_template_elements" => ["create", "edit", "get_data", "index", "new", "show", "update"],
          },
      }
  }
  #=================================END:SKM_TEMPLATE_ELEMENT=================================

  #=================================START:SKM_SETTING=================================
  map.function_group :skm_setting, {
      :en => {:name => "Setting", :description => "Setting"},
      :zh => {:name => "知识库设置", :description => "修改知识库参数设置"}, }
  map.function_group :skm_setting, {
      :zone_code => "SKM_SETTING",
      :controller => "skm/settings",
      :action => "index"}
  map.function_group :skm_setting, {
      :children => {
          :skm_setting => {
              :en => {:name => "Manage Knowledge Base Setting", :description => "Manage Knowledge Base Setting"},
              :zh => {:name => "管理知识库设置", :description => "管理知识库设置"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/settings" => ["edit", "index", "update"],
          },
      }
  }
  #=================================END:SKM_SETTING=================================


  #=================================START:SKM_COLUMN=================================
  map.function_group :skm_column, {
      :en => {:name => "Skm Category", :description => "Skm Category"},
      :zh => {:name => "知识分类", :description => "添加、编辑公告分类，或定义分类的层次结构"}, }
  map.function_group :skm_column, {
      :zone_code => "SKM_SETTING",
      :controller => "skm/columns",
      :action => "index"}
  map.function_group :skm_column, {
      :children => {
          :skm_column => {
              :en => {:name => "Manage Skm Categories", :description => "Manage Skm Categories"},
              :zh => {:name => "管理知识分类", :description => "管理知识分类"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/columns" => ["create", "edit", "get_columns_data", "index", "new", "update"],
          },
      }
  }
  #=================================END:SKM_COLUMN=================================

  #=================================START:SKM_CHANNEL=================================
  map.function_group :skm_channel, {
      :en => {:name => "Channel", :description => "Channel"},
      :zh => {:name => "知识频道", :description => "新建一个知识频道，或管理频道的可访问用户组"}, }
  map.function_group :skm_channel, {
      :zone_code => "SKM_SETTING",
      :controller => "skm/channels",
      :action => "index"}
  map.function_group :skm_channel, {
      :children => {
          :skm_channel => {
              :en => {:name => "Manage Skm Channel", :description => "Manage Skm Channel"},
              :zh => {:name => "管理知识频道", :description => "管理知识频道"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/channels" => ["get_all_columns_data", "get_approvals_data", "get_ava_channels", "get_ava_groups_data", "get_data", "get_owned_approvals_data", "get_owned_channels", "get_owned_groups_data", "index", "show"],
          },
          :edit_skm_channel => {
              :en => {:name => "Edit Skm Channel", :description => "Edit Skm Channel"},
              :zh => {:name => "编辑知识频道", :description => "编辑知识频道"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "irm/groups" => ["create_skm_channels", "new_skm_channels", "remove_skm_channel"],
              "skm/channels" => ["create", "create_approvals", "create_groups", "edit", "multilingual_edit", "multilingual_update", "new", "new_approvals", "new_groups", "remove_approval", "remove_group", "update"],
          },
      }
  }
  #=================================END:SKM_CHANNEL=================================


  #=================================START:SKM_WIKI=================================
  map.function_group :skm_wiki, {
      :en => {:name => "Wiki", :description => "Wiki"},
      :zh => {:name => "Wiki", :description => "Wiki"}, }
  map.function_group :skm_wiki, {
      :zone_code => "KNOWLEDGE_MANAGEMENT",
      :controller => "skm/wikis",
      :action => "index"}
  map.function_group :skm_wiki, {
      :children => {
          :view_wiki => {
              :en => {:name => "View Wiki", :description => "View Wiki"},
              :zh => {:name => "查看Wiki", :description => "查看Wiki"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/books" => ["get_data", "index", "show"],
              "skm/wikis" => ["compare", "get_data", "history", "index", "show"],
          },
          :create_wiki => {
              :en => {:name => "Create Wiki", :description => "Create Wiki"},
              :zh => {:name => "新建Wiki", :description => "新建Wiki"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/books" => ["create", "new"],
              "skm/book_wikis" => ["create", "destroy", "order"],
              "skm/wikis" => ["create", "create_word", "new", "new_word", "preview"],
          },
          :edit_wiki => {
              :en => {:name => "New Wiki", :description => "New Wiki"},
              :zh => {:name => "编辑Wiki", :description => "编辑Wiki"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/books" => ["edit", "update"],
              "skm/book_wikis" => ["create", "destroy", "order"],
              "skm/wikis" => ["edit", "edit_chapter", "preview", "update", "update_chapter"],
          },
          :manage_wiki => {
              :en => {:name => "Manage Wiki", :description => "Manage Wiki"},
              :zh => {:name => "管理Wiki", :description => "管理Wiki"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "Y",
              "skm/books" => ["edit", "publish", "update"],
              "skm/wikis" => ["revert"],
          },
      }
  }
  #=================================END:SKM_WIKI=================================

end