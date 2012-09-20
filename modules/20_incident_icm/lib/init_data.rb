#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #====================================START:INCIDENT_MANAGEMENT======================================
  map.menu :incident_management, {
      :en => {:name => "Incident Setting", :description => "Incident Setting"},
      :zh => {:name => "事故管理", :description => "事故管理"},
      :children => {
          :icm_close_reason => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Close Reason", :description => "Close Reason"},
                  :zh => {:name => "关闭原因", :description => "创建、编辑事故单关闭原因"},
              }},
          :icm_rule_setting => {
              :type => "function",
              :entry => {
                  :sequence => 30,
                  :en => {:name => "Rule Setting", :description => "Rule Setting"},
                  :zh => {:name => "规则设置", :description => "创建、编辑事故单关闭规则"},
              }},
          :icm_urgence_code => {
              :type => "function",
              :entry => {
                  :sequence => 40,
                  :en => {:name => "Urgency", :description => "Urgency"},
                  :zh => {:name => "紧急度", :description => "定义或编辑事故单紧急度"},
              }},
          :icm_impact_range => {
              :type => "function",
              :entry => {
                  :sequence => 50,
                  :en => {:name => "Impact Range", :description => "Impact Range"},
                  :zh => {:name => "影响度", :description => "定义或编辑事故单影响度"},
              }},
          :icm_priority_code => {
              :type => "function",
              :entry => {
                  :sequence => 60,
                  :en => {:name => "Priority", :description => "Priority"},
                  :zh => {:name => "优先级", :description => "查看根据紧急度和影响度定义，计算出的优先级"},
              }},
          :icm_phase => {
              :type => "function",
              :entry => {
                  :sequence => 70,
                  :en => {:name => "Phase", :description => "Phase"},
                  :zh => {:name => "阶段", :description => "定义或编辑事故单阶段"},
              }},
          :icm_status => {
              :type => "function",
              :entry => {
                  :sequence => 80,
                  :en => {:name => "Status", :description => "Status"},
                  :zh => {:name => "状态", :description => "创建、编辑事故单状态，或定义状态转移规则"},
              }},
          :icm_support_group => {
              :type => "function",
              :entry => {
                  :sequence => 90,
                  :en => {:name => "Support Group", :description => "Support Group"},
                  :zh => {:name => "支持组", :description => "定义支持组属性，或设置支持组分派规则"},
              }},
          :mail_request => {
              :type => "function",
              :entry => {
                  :sequence => 100,
                  :en => {:name => "Mail Request Conf.", :description => "Mail Request Conf."},
                  :zh => {:name => "邮件事故单设置", :description => "创建或修改从邮件创建事故单的规则"},
              }},
          :incident_category => {
              :type => "function",
              :entry => {
                  :sequence => 35,
                  :en => {:name => "Incident Category", :description => "Incident Category"},
                  :zh => {:name => "事故单分类设置", :description => "创建、编辑事故的分类，或为分类添加子分类"},
              }},
          :assign_rule => {
              :type => "function",
              :entry => {
                  :sequence => 110,
                  :en => {:name => "Assign Rules", :description => "Assign Rules"},
                  :zh => {:name => "分派规则", :description => "分派规则"}
              }
          }
      }
  }
  #====================================END:INCIDENT_MANAGEMENT======================================

  #=================================START:INCIDENT_REQUEST=================================
  map.function_group :incident_request, {
      :en => {:name => "Incident Request", :description => "Incident Request"},
      :zh => {:name => "事故单", :description => "管理事故单状态、紧急度、关闭原因等属性，以及支持组和事故单分派规则"}, }
  map.function_group :incident_request, {
      :zone_code => "INCIDENT_REQUEST",
      :controller => "icm/incident_requests",
      :action => "index"}
  map.function_group :incident_request, {
      :children => {
          :view_incident_request => {
              :en => {:name => "View", :description => "View"},
              :zh => {:name => "查看", :description => "查看"},
              :default_flag => "Y",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_requests" => ["show_detail"],
              "icm/incident_journals" => ["index", "new"],
              "icm/incident_requests" => ["get_data", "get_external_systems", "get_help_desk_data", "get_slm_services", "index",
                                          "update", "remove_attachment"],
          },
          :view_all_incident_request => {
              :en => {:name => "View ALL", :description => "View ALL"},
              :zh => {:name => "查看所有", :description => "查看所有"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => ["index", "info_card"],
          },
          :reply_incident_request => {
              :en => {:name => "Reply", :description => "Reply"},
              :zh => {:name => "回复", :description => "回复"},
              :default_flag => "Y",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => ["apply_entry_header", "create", "get_entry_header_data", "index", "new", "get_incident_history_data"],
          },
          :pass_incident_request => {
              :en => {:name => "Pass", :description => "Pass"},
              :zh => {:name => "转交", :description => "转交"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => ["edit_pass", "edit_upgrade", "update_pass", "update_upgrade"],
              "icm/support_groups" => ["get_pass_member_options"],
          },
          :edit_incident_request => {
              :en => {:name => "Edit", :description => "Edit"},
              :zh => {:name => "编辑", :description => "编辑"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => ["edit", "update"],
          },
          :create_incident_request => {
              :en => {:name => "New", :description => "New"},
              :zh => {:name => "新建", :description => "新建"},
              :default_flag => "Y",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_config_relations" => ["create", "destroy"],
              "icm/incident_requests" => ["create", "new", "short_create"],
          },
          :create_icdt_rqst_for_other => {
              :en => {:name => "Summbit for other", :description => "Summbit for other"},
              :zh => {:name => "为他人提单", :description => "为他人提单"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => ["create", "new"],
          },
          :close_incident_request => {
              :en => {:name => "Close", :description => "Close"},
              :zh => {:name => "关闭", :description => "关闭"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => ["edit_close", "update_close"],
          },
          :assign_incident_request => {
              :en => {:name => "Assign", :description => "Assign"},
              :zh => {:name => "分配", :description => "分配"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => ["assignable_data", "assign_dashboard", "assign_request"],
          },
          :view_icm_kanban => {
              :en => {:name => "View ICM Kanban", :description => "View ICM Kanban"},
              :zh => {:name => "查看看板", :description => "查看看板"},
              :default_flag => "N",
              :login_flag => "Y",
              :public_flag => "N",
              "icm/incident_requests" => ["kanban_index"],
          },
          :view_watcher => {
              :en => {:name => "View Watcher", :description => "View Watcher"},
              :zh => {:name => "查看观察者", :description => "查看观察者"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "irm/watchers" => ["order"],
          },
          :edit_watcher => {
              :en => {:name => "Edit Watcher", :description => "Edit Watcher"},
              :zh => {:name => "编辑观察者", :description => "编辑观察者"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "irm/watchers" => ["add_watcher", "delete_watcher"],
          },
          :incident_request_assign_me => {
              :en => {:name => "Request", :description => "Request"},
              :zh => {:name => "领取", :description => "领取"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => ["assign_me_data", "edit_assign_me", "update_assign_me"],
          },
          :incident_request_edit_status => {
              :en => {:name => "Edit Status", :description => "Edit Status"},
              :zh => {:name => "修改状态", :description => "修改状态"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => ["edit_status", "update_status"],
          },
          :upgrade_incident_request => {
              :en => {:name => "Upgrade", :description => "Upgrade"},
              :zh => {:name => "升级", :description => "升级"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => ["edit_upgrade", "update_upgrade"],
              "icm/support_groups" => ["get_member_options"],
          },
          :edit_relation => {
              :en => {:name => "Edit Relation", :description => "Edit Relation"},
              :zh => {:name => "编辑相关问题", :description => "编辑相关问题"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => ["add_relation", "remove_relation"]
          },
          :permanent_close_incdnt_request => {
              :en => {:name => "Permanently Close", :description => "Permanently Close"},
              :zh => {:name => "永久关闭", :description => "永久关闭"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => ["edit_permanent_close", "update_permanent_close"],
          },
          :reopen_incident_request => {
              :en => {:name => "Reopen", :description => "Reopen"},
              :zh => {:name => "重新打开", :description => "重新打开"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => ["edit_reopen", "update_reopen"],
          },
          :edit_myself_request => {
              :en => {:name => "Edit Myself Request", :description => "Edit Myself Request"},
              :zh => {:name => "编辑自己的事故单", :description => "编辑自己的事故单"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => ["edit", "update"]
          },

          :remove_attachment => {
              :en => {:name => "Remove Attachment", :description => "Remove Attachment"},
              :zh => {:name => "删除附件", :description => "删除附件"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => ["remove_attachment"]
          },

          :edit_workload => {
              :en => {:name => "Edit Workload", :description => "Edit Workload"},
              :zh => {:name => "登记工时", :description => "登记工时"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => ["edit_workload", "update_workload"]
          },

          :remove_self_journal => {
              :en => {:name => "Remove Self Journal", :description => "Remove Self Journal"},
              :zh => {:name => "删除自己的回复", :description => "删除自己的回复"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => [:remove_journal]
          },

          :remove_any_journal => {
              :en => {:name => "Remove Any Journal", :description => "Remove Any Journal"},
              :zh => {:name => "删除任何回复", :description => "删除任何回复"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => [:remove_journal]
          },

          :edit_self_journal => {
              :en => {:name => "Edit Self Journal", :description => "Edit Self Journal"},
              :zh => {:name => "编辑自己的回复", :description => "编辑自己的回复"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => [:edit, :update]
          },

          :edit_any_journal => {
              :en => {:name => "Edit Any Journal", :description => "Edit Any Journal"},
              :zh => {:name => "编辑任何回复", :description => "编辑任何回复"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_journals" => [:edit, :update]
          },

          :cancel_request => {
              :en => {:name => "Cancel Request", :description => "Cancel Request"},
              :zh => {:name => "取消问题", :description => "取消问题"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => [:cancel_request, :enable_request]
          },

          :edit_incident_request_priority => {
              :en => {:name => "Edit Priority", :description => "Edit Priority"},
              :zh => {:name => "修改优先级", :description => "修改优先级"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_requests" => [:update]
          },
      }
  }
  #=================================END:INCIDENT_REQUEST=================================
  #=================================START:ICM_CLOSE_REASON=================================
  map.function_group :icm_close_reason, {
      :en => {:name => "Close Reason", :description => "Close Reason"},
      :zh => {:name => "关闭原因", :description => "创建、编辑事故单关闭原因"}, }
  map.function_group :icm_close_reason, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/close_reasons",
      :action => "index"}
  map.function_group :icm_close_reason, {
      :children => {
          :icm_close_reason => {
              :en => {:name => "Manage Incident Close Reason", :description => "Manage Incident Close Reason"},
              :zh => {:name => "管理事故单关闭原因", :description => "管理事故单关闭原因"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/close_reasons" => ["create", "edit", "get_data", "index", "new", "show", "update"],
          },
      }
  }
  #=================================END:ICM_CLOSE_REASON=================================

  #=================================START:ICM_RULE_SETTING=================================
  map.function_group :icm_rule_setting, {
      :en => {:name => "Rule Setting", :description => "Rule Setting"},
      :zh => {:name => "规则设置", :description => "创建、编辑事故单关闭规则"}, }
  map.function_group :icm_rule_setting, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/rule_settings",
      :action => "index"}
  map.function_group :icm_rule_setting, {
      :children => {
          :icm_rule_setting => {
              :en => {:name => "Manage Rule Setting", :description => "Manage Rule Setting"},
              :zh => {:name => "管理事故单规则设置", :description => "管理事故单规则设置"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/rule_settings" => ["create", "edit", "get_data", "index", "new", "show", "update"],
          },
      }
  }
  #=================================END:ICM_RULE_SETTING=================================

  #=================================START:ICM_URGENCE_CODE=================================
  map.function_group :icm_urgence_code, {
      :en => {:name => "Urgency", :description => "Urgency"},
      :zh => {:name => "紧急度", :description => "定义或编辑事故单紧急度"}, }
  map.function_group :icm_urgence_code, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/urgence_codes",
      :action => "index"}
  map.function_group :icm_urgence_code, {
      :children => {
          :icm_urgence_code => {
              :en => {:name => "Manage Urgency", :description => "Manage Urgency"},
              :zh => {:name => "管理事故单紧急度", :description => "管理事故单紧急度"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/urgence_codes" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:ICM_URGENCE_CODE=================================

  #=================================START:ICM_IMPACT_RANGE=================================
  map.function_group :icm_impact_range, {
      :en => {:name => "Impact Range", :description => "Impact Range"},
      :zh => {:name => "影响度", :description => "定义或编辑事故单影响度"}, }
  map.function_group :icm_impact_range, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/impact_ranges",
      :action => "index"}
  map.function_group :icm_impact_range, {
      :children => {
          :icm_impact_range => {
              :en => {:name => "Manage Impact Range", :description => "Manage Impact Range"},
              :zh => {:name => "管理事故单影响度", :description => "管理事故单影响度"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/impact_ranges" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:ICM_IMPACT_RANGE=================================

  #=================================START:ICM_PRIORITY_CODE=================================
  map.function_group :icm_priority_code, {
      :en => {:name => "Priority", :description => "Priority"},
      :zh => {:name => "优先级", :description => "查看根据紧急度和影响度定义，计算出的优先级"}, }
  map.function_group :icm_priority_code, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/priority_codes",
      :action => "index"}
  map.function_group :icm_priority_code, {
      :children => {
          :icm_priority_code => {
              :en => {:name => "Manage Priority", :description => "Manage Priority"},
              :zh => {:name => "管理事故单优先级", :description => "管理事故单优先级"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/priority_codes" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:ICM_PRIORITY_CODE=================================

  #=================================START:ICM_PHASE=================================
  map.function_group :icm_phase, {
      :en => {:name => "Phase", :description => "Phase"},
      :zh => {:name => "阶段", :description => "定义或编辑事故单阶段"}, }
  map.function_group :icm_phase, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/incident_phases",
      :action => "index"}
  map.function_group :icm_phase, {
      :children => {
          :icm_phase => {
              :en => {:name => "Manage Phase", :description => "Manage Phase"},
              :zh => {:name => "管理事故单阶段", :description => "管理事故单阶段"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_phases" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:ICM_PHASE=================================

  #=================================START:ICM_STATUS=================================
  map.function_group :icm_status, {
      :en => {:name => "Status", :description => "Status"},
      :zh => {:name => "状态", :description => "创建、编辑事故单状态，或定义状态转移规则"}, }
  map.function_group :icm_status, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/incident_statuses",
      :action => "index"}
  map.function_group :icm_status, {
      :children => {
          :icm_status => {
              :en => {:name => "Manage Status", :description => "Manage Status"},
              :zh => {:name => "管理事故单状态", :description => "管理事故单状态"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_statuses" => ["create", "edit", "edit_transform", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update", "update_transform"],
          },
      }
  }
  #=================================END:ICM_STATUS=================================

  #=================================START:ICM_SUPPORT_GROUP=================================
  map.function_group :icm_support_group, {
      :en => {:name => "Support Group", :description => "Support Group"},
      :zh => {:name => "支持组", :description => "定义支持组属性，或设置支持组分派规则"}, }
  map.function_group :icm_support_group, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/support_groups",
      :action => "index"}
  map.function_group :icm_support_group, {
      :children => {
          :icm_support_group => {
              :en => {:name => "Manage Support Group", :description => "Manage Support Group"},
              :zh => {:name => "管理支持组", :description => "管理支持组"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/support_groups" => ["create", "edit", "get_data", "index", "new", "show", "update"],
              "irm/group_members" => ["get_group_member_options"]
          },
      }
  }
  #=================================END:ICM_SUPPORT_GROUP=================================

  #=================================START:MAIL_REQUEST=================================
  map.function_group :mail_request, {
      :en => {:name => "Mail Request Conf.", :description => "Mail Request Conf."},
      :zh => {:name => "邮件事故单设置", :description => "创建或修改从邮件创建事故单的规则"}, }
  map.function_group :mail_request, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/mail_requests",
      :action => "index"}
  map.function_group :mail_request, {
      :children => {
          :view_mail_request => {
              :en => {:name => "View Mail Request Conf.", :description => "View Mail Request Conf."},
              :zh => {:name => "查看邮件事故单配置", :description => "查看邮件事故单配置"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/mail_requests" => ["get_data", "index", "show"],
          },
          :edit_mail_request => {
              :en => {:name => "Edit Mail Request Conf.", :description => "Edit Mail Request Conf."},
              :zh => {:name => "编辑邮件事故单配置", :description => "编辑邮件事故单配置"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/mail_requests" => ["create", "disable", "edit", "enable", "new", "update"],
          },
      }
  }
  #=================================END:MAIL_REQUEST=================================

  #=================================START:INCIDENT_CATEGORY=================================
  map.function_group :incident_category, {
      :en => {:name => "Incident Category", :description => "Incident Category"},
      :zh => {:name => "事故单分类设置", :description => "创建、编辑事故的分类，或为分类添加子分类"}, }
  map.function_group :incident_category, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/incident_categories",
      :action => "index"}
  map.function_group :incident_category, {
      :children => {
          :incident_category => {
              :en => {:name => "Manage Incident Category", :description => "Manage Incident Category"},
              :zh => {:name => "管理事故单分类", :description => "管理事故单分类"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/incident_categories" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
              "icm/incident_sub_categories" => ["create", "destroy", "edit", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:INCIDENT_CATEGORY=================================

  #=================================START:ASSIGN RULE=================================
  map.function_group :assign_rule, {
      :en => {:name => "Assign Rules", :description => "New or edit assign Rules"},
      :zh => {:name => "分派规则", :description => "创建、编辑分派规则"}, }
  map.function_group :assign_rule, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "icm/assign_rules",
      :action => "index"}
  map.function_group :assign_rule, {
      :children => {
          :assign_rule => {
              :en => {:name => "Manage Assign Rules", :description => "Manage Assign Rules"},
              :zh => {:name => "管理分派规则", :description => "管理分派规则"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "icm/assign_rules" => ["create", "edit", "get_data", "index", "new", "show", "update","up_rule","down_rule"]
          },
      }
  }
  #=================================END:ASSIGN RULE=================================

end