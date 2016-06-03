#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  map.function_group :incident_request, {
      :children => {
          ##附加信息维护
          :edit_additional_info => {
              :zh => {:name => "附加信息维护", :description => "附加信息维护"},
              :en => {:name => "Edit Additional Info.", :description => "Edit Additional Info."},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              :system_flag => "Y",
              "icm/incident_journals" => ["edit_additional_info", "update_additional_info"]
          },
          :additional_info_area1 => {
              :zh => {:name => "附加信息1区", :description => "附加信息1区"},
              :en => {:name => "Additional Info. 1", :description => "Additional Info. 1"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              :system_flag => "Y",
              "icm/incident_journals" => ["edit_additional_info", "update_additional_info"]
          },
          ##状态
          :additional_info_area2 => {
              :zh => {:name => "附加信息2区", :description => "附加信息2区"},
              :en => {:name => "Additional Info. 2", :description => "Additional Info. 2"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              :system_flag => "Y",
              "icm/incident_journals" => ["edit_additional_info", "update_additional_info"]
          },
          :additional_info_area3 => {
              :zh => {:name => "附加信息3区", :description => "附加信息3区"},
              :en => {:name => "Additional Info. 3", :description => "Additional Info. 3"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              :system_flag => "Y",
              "icm/incident_journals" => ["edit_additional_info", "update_additional_info"]
          },

          :edit_workload_self => {
              :zh => {:name => "维护个人工时", :description => "维护个人工时"},
              :en => {:name => "Edit Personal Workload", :description => "Edit Personal Workload"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              :system_flag => "Y",
              "icm/incident_journals" => ["edit_worklaod", "update_worklaod"]
          },
          :submit_private_reply => {
              :zh => {:name => "提交私有附件", :description => "提交私有附件"},
              :en => {:name => "Submit Private File", :description => "Submit Private File"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              :system_flag => "Y",
              "icm/incident_journals" => ["update_additional_info"]
          },
          :view_my_private_reply => {
              :zh => {:name => "查看自己的私有附件", :description => "查看自己的私有附件"},
              :en => {:name => "View My Private File", :description => "View My Private File"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              :system_flag => "Y",
              "icm/incident_journals" => ["update_additional_info"]
          },
          :view_project_private_reply => {
              :zh => {:name => "查看项目私有附件", :description => "查看项目私有附件"},
              :en => {:name => "View Project Private File", :description => "View Project Private File"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              :system_flag => "Y",
              "icm/incident_journals" => ["update_additional_info"]
          },
          :edit_parents_v => {
              :zh => {:name => "Edit Person Parents", :description => "Edit Person Parents"},
              :en => {:name => "Edit Person Parents", :description => "Edit Person Parents"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              :system_flag => "N",
              "yan/parent_people" => ["delete_from_parent", "new_from_person","create_from_person","get_owned_parents_data","get_ava_parents_data"]
          }
      }
  }

  map.menu :management_setting, {
      :children => {
          :workload_management => {
                :type => "menu",
                :entry => {
                    :sequence => 150,
                    :en => {:name => "Workload Management", :description => "Workload Management"},
                    :zh => {:name => "工时管理", :description => "工时管理"},
                    :ja => {:name => "Workload Management", :description => "Workload Management"}
                }
          }
      }
  }

  map.menu :workload_management, {
      :en => {:name => "Workload Management", :description => "Workload Management"},
      :zh => {:name => "工时管理", :description => "工时管理"},
      :ja => {:name => "Workload Management", :description => "Workload Management"},
      :children => {
          :workload_authority => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Workload Management", :description => "Workload Management"},
                  :zh => {:name => "工时管理", :description => "工时管理"},
                  :ja => {:name => "Workload Management", :description => "Workload Management"}
              }
          },
          :edit_workload => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Register Workload", :description => "Register Workload"},
                  :zh => {:name => "工时登记", :description => "工时登记"},
                  :ja => {:name => "Register Workload", :description => "Register Workload"}
              }
          }
      }
  }

  map.function_group :edit_workload, {
                                       :en => {:name => "Register Workload", :description => "Register Workload"},
                                       :zh => {:name => "工时登记", :description => "工时登记"},
                                       :ja => {:name => "Register Workload", :description => "Register Workload"}
                                        }
  map.function_group :edit_workload, {
                                            :zone_code => "REGISTER_WORKLOAD",
                                            :controller => "yan/workload_register",
                                            :action => "index"}
  map.function_group :edit_workload, {
                                            :children => {
                                                :edit_workload => {
                                                    :en => {:name => "Register Workload", :description => "Register Workload"},
                                                    :zh => {:name => "工时登记", :description => "工时登记"},
                                                    :ja => {:name => "Register Workload", :description => "Register Workload"},
                                                    :default_flag => "N",
                                                    :login_flag => "N",
                                                    :public_flag => "N",
                                                    "yan/workload_register" => ["index","create_workload","update_workload","update_workload_by_resize","update_workload_by_drop","delete_workload","get_week_workload"],
                                                    "icm/incident_requests" => ["get_attend_incident"]
                                                }
                                            }
                                        }

  map.function_group :people_states, {
                                       :en => {:name => "People Status", :description => "People Status"},
                                       :zh => {:name => "People Status", :description => "People Status"},
                                       :ja => {:name => "People Status", :description => "People Status"}
                                   }
  map.function_group :people_states, {
                                       :zone_code => "PEOPLE_STATUS",
                                       :controller => "yan/people_states",
                                       :action => "index"}
  map.function_group :people_states, {
                                       :children => {
                                           :people_states => {
                                               :en => {:name => "People Status", :description => "People Status"},
                                               :zh => {:name => "People Status", :description => "People Status"},
                                               :ja => {:name => "People Status", :description => "People Status"},
                                               :default_flag => "N",
                                               :login_flag => "N",
                                               :public_flag => "N",
                                               "yan/people_states" => ["index"]
                                           }
                                       }
                                   }

  map.function_group :workload_authority, {
      :en => {:name => "Workload Management", :description => "Workload Management"},
      :zh => {:name => "工时管理", :description => "工时管理"},
      :ja => {:name => "Workload Management", :description => "Workload Management"}
  }
  map.function_group :workload_authority, {
      :zone_code => "WORKLOAD",
      :controller => "yan/workload_authorities",
      :action => "index"}
  map.function_group :workload_authority, {
      :children => {
          :workload_authority => {
              :en => {:name => "Workload Authority", :description => "Workload Authority"},
              :zh => {:name => "工时权限", :description => "工时权限"},
              :ja => {:name => "Workload Authority", :description => "Workload Authority"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "yan/workload_authorities" => ["index"]
          }
      }
  }

end