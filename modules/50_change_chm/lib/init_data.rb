#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #====================================START:CHANGE_MANAGEMENT======================================
  map.menu :change_management, {
      :en => {:name => "Change Management", :description => "Change setting"},
      :zh => {:name => "变更管理", :description => "变更相关设置与管理"},
      :children => {
          :change_status => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Status", :description => "Define,edit change status"},
                  :zh => {:name => "状态", :description => "创建、编辑事故单状态"},
              }},
          :change_priority => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Priority", :description => "Define,edit change priority"},
                  :zh => {:name => "优先级", :description => "查看,编辑根据紧急度和影响度定义，计算出的优先级"},
              }},
          :change_urgency => {
              :type => "function",
              :entry => {
                  :sequence => 30,
                  :en => {:name => "Urgency", :description => "Define,edit change urgency"},
                  :zh => {:name => "紧急度", :description => "定义或编辑事故单紧急度"},
              }},
          :change_impact => {
              :type => "function",
              :entry => {
                  :sequence => 40,
                  :en => {:name => "Impact", :description => "Define,edit change impact"},
                  :zh => {:name => "影响度", :description => "定义或编辑事故单影响度"},
              }},
          :change_plan_type => {
              :type => "function",
              :entry => {
                  :sequence => 50,
                  :en => {:name => "Change Plan Type", :description => "Submit,edit change plan type"},
                  :zh => {:name => "计划类型", :description => "查看,提交,编辑,操作变更单计划类型"},
              }},
          :change_task_phase => {
              :type => "function",
              :entry => {
                  :sequence => 60,
                  :en => {:name => "Task Phase", :description => "Submit,edit change task phase"},
                  :zh => {:name => "任务阶段", :description => "查看,提交,编辑,操作变更任务阶段"},
              }},
          :change_task_template => {
              :type => "function",
              :entry => {
                  :sequence => 70,
                  :en => {:name => "Task Template", :description => "Submit,edit change task template"},
                  :zh => {:name => "任务模板", :description => "查看,提交,编辑,操作变更任务模板及模板任务"},
              }},
          :advisory_board => {
              :type => "function",
              :entry => {
                  :sequence => 80,
                  :en => {:name => "Change Approve Board", :description => "Mangage Change Approve Board"},
                  :zh => {:name => "变更委员会", :description => "查看,添加,编辑变更委员会"},
              }},
      }
  }
  #====================================END:CHANGE_MANAGEMENT======================================

  #=================================START:CHANGE_STATUS=================================
  map.function_group :change_status, {
      :en => {:name => "Status", :description => "Define,edit change status"},
      :zh => {:name => "状态", :description => "创建、编辑事故单状态"}, }
  map.function_group :change_status, {
      :zone_code => "CHANGE_SETTING",
      :controller => "chm/change_statuses",
      :action => "index"}
  map.function_group :change_status, {
      :children => {
          :change_status => {
              :en => {:name => "Change Status", :description => "Change Status"},
              :zh => {:name => "变更单状态", :description => "变更单状态"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_statuses" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:CHANGE_STATUS=================================

  #=================================START:CHANGE_PRIORITY=================================
  map.function_group :change_priority, {
      :en => {:name => "Priority", :description => "Define,edit change priority"},
      :zh => {:name => "优先级", :description => "查看,编辑根据紧急度和影响度定义，计算出的优先级"}, }
  map.function_group :change_priority, {
      :zone_code => "CHANGE_SETTING",
      :controller => "chm/change_priorities",
      :action => "index"}
  map.function_group :change_priority, {
      :children => {
          :change_priority => {
              :en => {:name => "Change Priority", :description => "Change Priority"},
              :zh => {:name => "变更单优先级", :description => "变更单优先级"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_priorities" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:CHANGE_PRIORITY=================================

  #=================================START:CHANGE_URGENCY=================================
  map.function_group :change_urgency, {
      :en => {:name => "Urgency", :description => "Define,edit change urgency"},
      :zh => {:name => "紧急度", :description => "定义或编辑事故单紧急度"}, }
  map.function_group :change_urgency, {
      :zone_code => "CHANGE_SETTING",
      :controller => "chm/change_urgencies",
      :action => "index"}
  map.function_group :change_urgency, {
      :children => {
          :change_urgency => {
              :en => {:name => "Change Urgency", :description => "Change Urgency"},
              :zh => {:name => "变更单紧急度", :description => "变更单紧急度"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_urgencies" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:CHANGE_URGENCY=================================

  #=================================START:CHANGE_IMPACT=================================
  map.function_group :change_impact, {
      :en => {:name => "Impact", :description => "Define,edit change impact"},
      :zh => {:name => "影响度", :description => "定义或编辑事故单影响度"}, }
  map.function_group :change_impact, {
      :zone_code => "CHANGE_SETTING",
      :controller => "chm/change_impacts",
      :action => "index"}
  map.function_group :change_impact, {
      :children => {
          :change_impact => {
              :en => {:name => "Change Impact", :description => "Change Impact"},
              :zh => {:name => "变更单影响度", :description => "变更单影响度"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_impacts" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:CHANGE_IMPACT=================================

  #=================================START:CHANGE_REQUEST=================================
  map.function_group :change_request, {
      :en => {:name => "Change Request", :description => "Submit,edit change request"},
      :zh => {:name => "变更单", :description => "查看,提交,编辑,操作变更单"}, }
  map.function_group :change_request, {
      :zone_code => "CHANGE_SETTING",
      :controller => "chm/change_requests",
      :action => "index"}
  map.function_group :change_request, {
      :children => {
          :change_request => {
              :en => {:name => "Change Request", :description => "Change Request"},
              :zh => {:name => "变更单", :description => "变更单"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_requests" => ["get_data", "index", "show", "show_approve", "show_implement", "show_plan"],
          },
          :new_change_request => {
              :en => {:name => "New Change Request", :description => "New Change Request"},
              :zh => {:name => "新建变更单", :description => "新建变更单"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_requests" => ["create", "incident_new", "new"],
          },
          :edit_change_request => {
              :en => {:name => "Edit Change Request", :description => "Edit Change Request"},
              :zh => {:name => "编辑变更单", :description => "编辑变更单"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_requests" => ["edit", "update"],
          },
          :change_journal => {
              :en => {:name => "Reply Change Request", :description => "Reply Change Request"},
              :zh => {:name => "回复变理单", :description => "回复变理单"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_journals" => ["create"],
          },
          :change_plan => {
              :en => {:name => "Manage Change Plan", :description => "Manage Change Plan"},
              :zh => {:name => "管理变更计划", :description => "管理变更计划"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_plans" => ["change", "create", "refresh", "update"],
          },
          :change_task => {
              :en => {:name => "Change Task", :description => "Change Task"},
              :zh => {:name => "变更任务", :description => "变更任务"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_tasks" => ["create", "destroy", "edit", "new", "show", "template_create", "template_new", "update"],
              "chm/change_task_templates" => ["show_tasks"],
          },
          :change_incident => {
              :en => {:name => "Change relative to incident", :description => "Change relative to incident"},
              :zh => {:name => "变更关联事故单", :description => "变更关联事故单"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_requests" => ["show_incident", "show_config"],
              "chm/change_incident_relations" => ["create", "destroy", "incident_requests"],
              "chm/change_config_relations" => ["create", "destroy"],
          },
          :change_approve => {
              :en => {:name => "Change Approve History", :description => "Change Approve History"},
              :zh => {:name => "变更审批", :description => "查看变更的审批记录"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_approvals" => ["create", "destroy", "get_available_member", "new", "submit"],
          },
          :perform_change_task => {
              :en => {:name => "Perform Change Task", :description => "Perform Change Task"},
              :zh => {:name => "更新变理任务", :description => "更新分配到个人的变更任务"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
          },
      }
  }
  #=================================END:CHANGE_REQUEST=================================

  #=================================START:CHANGE_PLAN_TYPE=================================
  map.function_group :change_plan_type, {
      :en => {:name => "Change Plan Type", :description => "Submit,edit change plan type"},
      :zh => {:name => "计划类型", :description => "查看,提交,编辑,操作变更单计划类型"}, }
  map.function_group :change_plan_type, {
      :zone_code => "CHANGE_SETTING",
      :controller => "chm/change_plan_types",
      :action => "index"}
  map.function_group :change_plan_type, {
      :children => {
          :change_plan_type => {
              :en => {:name => "Change Plan Type", :description => "Change Plan Type"},
              :zh => {:name => "计划类型", :description => "计划类型"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_plan_types" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:CHANGE_PLAN_TYPE=================================

  #=================================START:CHANGE_TASK_PHASE=================================
  map.function_group :change_task_phase, {
      :en => {:name => "Task Phase", :description => "Submit,edit change task phase"},
      :zh => {:name => "任务阶段", :description => "查看,提交,编辑,操作变更任务阶段"}, }
  map.function_group :change_task_phase, {
      :zone_code => "CHANGE_SETTING",
      :controller => "chm/change_task_phases",
      :action => "index"}
  map.function_group :change_task_phase, {
      :children => {
          :change_task_phase => {
              :en => {:name => "Change Task Phase", :description => "Change Task Phase"},
              :zh => {:name => "变更任务阶段", :description => "变更任务阶段"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_task_phases" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:CHANGE_TASK_PHASE=================================

  #=================================START:CHANGE_TASK_TEMPLATE=================================
  map.function_group :change_task_template, {
      :en => {:name => "Task Template", :description => "Submit,edit change task template"},
      :zh => {:name => "任务模板", :description => "查看,提交,编辑,操作变更任务模板及模板任务"}, }
  map.function_group :change_task_template, {
      :zone_code => "CHANGE_SETTING",
      :controller => "chm/change_task_templates",
      :action => "index"}
  map.function_group :change_task_template, {
      :children => {
          :change_task_template => {
              :en => {:name => "Change Task Template", :description => "Change Task Template"},
              :zh => {:name => "变更任务模板", :description => "变更任务模板"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/change_task_templates" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
              "chm/change_template_tasks" => ["create", "destroy", "edit", "new", "show", "update"],
          },
      }
  }
  #=================================END:CHANGE_TASK_TEMPLATE=================================

  #=================================START:ADVISORY_BOARD=================================
  map.function_group :advisory_board, {
      :en => {:name => "Change Approve Board", :description => "Mangage Change Approve Board"},
      :zh => {:name => "变更委员会", :description => "查看,添加,编辑变更委员会"}, }
  map.function_group :advisory_board, {
      :zone_code => "CHANGE_SETTING",
      :controller => "chm/advisory_boards",
      :action => "index"}
  map.function_group :advisory_board, {
      :children => {
          :advisory_board => {
              :en => {:name => "Advisory Board", :description => "Manage Advisory Board"},
              :zh => {:name => "变更委员会", :description => "管理变更委员会,变理委员会成员"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "chm/advisory_boards" => ["create", "edit", "get_data", "index", "new", "show", "update"],
              "chm/advisory_board_members" => ["create", "destroy", "get_data", "new"],
          },
      }
  }
  #=================================END:ADVISORY_BOARD=================================
end