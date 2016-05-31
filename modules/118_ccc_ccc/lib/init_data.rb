#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  map.menu :system_incident_setting, {
                                       :en => {:name => "Incident Setting", :description => "Incident Setting"},
                                       :zh => {:name => "事故单设置", :description => "事故单设置"},
                                       :children => {
                                           :system_incident_status_control => {
                                               :type => "function",
                                               :entry => {
                                                   :sequence => 150,
                                                   :en => {:name => "Status Control", :description => "Status Control"},
                                                   :zh => {:name => "状态控制", :description => "状态控制"},
                                               }
                                           },
                                       }
                                   }

  map.function_group :system_incident_status_control, {
                                                        :en => {:name => "Status Control", :description => "Status Control"},
                                                        :zh => {:name => "状态控制", :description => "状态控制"},
                                                        # :system_flag => 'Y'
                                                    }
  map.function_group :system_incident_status_control, {
                                                        :zone_code => "INCIDENT_SETTING",
                                                        :controller => "ccc/status_cons",
                                                        :action => "index"
                                                    }
  map.function_group :system_incident_status_control, {
                                                        :children => {
                                                            :system_incident_status_control => {
                                                                :en => {:name => "Status Control", :description => "Status Control"},
                                                                :zh => {:name => "状态控制", :description => "状态控制"},
                                                                :default_flag => "N",
                                                                :login_flag => "N",
                                                                :public_flag => "N",
                                                                "ccc/status_cons" => ["index","new","create","edit","update","get_data"]
                                                            }
                                                        }
                                                    }
  map.menu :external_system_management, {
                                          :en => {:name => "External System", :description => "External System"},
                                          :zh => {:name => "应用系统", :description => "应用系统"},
                                          :children => {
                                              :project_type_info => {
                                                  :type => "function",
                                                  :entry => {
                                                      :sequence => 50,
                                                      :en => {:name => "Project Type", :description => "Project Type"},
                                                      :zh => {:name => "项目类型", :description => "新建、查看、编辑一项目类型"},
                                                  }},
                                              :price_type_info => {
                                                  :type => "function",
                                                  :entry => {
                                                      :sequence => 60,
                                                      :en => {:name => "Price Type", :description => "Price Type"},
                                                      :zh => {:name => "计价方式", :description => "新建、查看、编辑一计价方式"},
                                                  }}
                                          }
                                      }

  map.function_group :project_type_info, {
                                           :en => {:name => "Project Type Info", :description => "Project Type Info"},
                                           :zh => {:name => "项目类型", :description => "新建、查看、编辑一项目类型"}
                                       }
  map.function_group :project_type_info, {
                                           :zone_code => "SYSTEM_SETTING",
                                           :controller => "ccc/project_types",
                                           :action => "index"}
  map.function_group :project_type_info, {
                                           :children => {
                                               :project_type_info => {
                                                   :en => {:name => "Manage Project Type", :description => "Manage Project Type"},
                                                   :zh => {:name => "管理项目类型", :description => "管理项目类型"},
                                                   :default_flag => "N",
                                                   :login_flag => "N",
                                                   :public_flag => "N",
                                                   "ccc/project_types" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                               },
                                           }
                                       }


  map.function_group :price_type_info, {
                                         :en => {:name => "Price Type Info", :description => "Price Type Info"},
                                         :zh => {:name => "计价方式", :description => "新建、查看、编辑一计价方式"}
                                     }
  map.function_group :price_type_info, {
                                         :zone_code => "SYSTEM_SETTING",
                                         :controller => "ccc/price_types",
                                         :action => "index"}
  map.function_group :price_type_info, {
                                         :children => {
                                             :price_type_info => {
                                                 :en => {:name => "Manage Price Type", :description => "Manage Price Type"},
                                                 :zh => {:name => "管理计价方式", :description => "管理计价方式"},
                                                 :default_flag => "N",
                                                 :login_flag => "N",
                                                 :public_flag => "N",
                                                 "ccc/price_types" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                             },
                                         }
                                     }

  map.menu :user_management, {
                               :en => {:name => "User Management", :description => "User Management"},
                               :zh => {:name => "管理用户", :description => "管理用户"},
                               :children => {
                                   :consultant_level_info => {
                                       :type => "function",
                                       :entry => {
                                           :sequence => 40,
                                           :en => {:name => "Consultant Level Info", :description => "Consultant Level Info"},
                                           :zh => {:name => "顾问等级", :description => "新建、查看、编辑一顾问等级"},
                                       }
                                   },
                                   :consultant_module_info => {
                                       :type => "function",
                                       :entry => {
                                           :sequence => 50,
                                           :en => {:name => "Consultant Module Info", :description => "Consultant Module Info"},
                                           :zh => {:name => "模块", :description => "新建、查看、编辑一模块"},
                                       }
                                   },
                                   :consultant_status_info => {
                                       :type => "function",
                                       :entry => {
                                           :sequence => 60,
                                           :en => {:name => "Consultant Status Info", :description => "Consultant Status Info"},
                                           :zh => {:name => "顾问状态", :description => "新建、查看、编辑一顾问状态"},
                                       }
                                   },
                                   :consultant_type_info => {
                                       :type => "function",
                                       :entry => {
                                           :sequence => 70,
                                           :en => {:name => "Consultant Type Info", :description => "Consultant Type Info"},
                                           :zh => {:name => "顾问类型", :description => "新建、查看、编辑一顾问类型"},
                                       }
                                   },
                                   :customer_status_info => {
                                       :type => "function",
                                       :entry => {
                                           :sequence => 80,
                                           :en => {:name => "Customer Status Info", :description => "Customer Status Info"},
                                           :zh => {:name => "客户状态", :description => "新建、查看、编辑一客户状态"},
                                       }
                                   },
                                   :blog => {
                                       :type => "function",
                                       :entry => {
                                           :sequence => 100,
                                           :en => {:name => "blog", :description => "blog"},
                                           :zh => {:name => "曲小妍的博客", :description => "查看添加编辑删除博客"},
                                       }
                                   },
                                   :sex_info => {
                                       :type => "function",
                                       :entry => {
                                           :sequence => 90,
                                           :en => {:name => "Sex Info", :description => "Sex Info"},
                                           :zh => {:name => "性别", :description => "新建、查看、编辑一性别"},
                                       }
                                   }

                               }
                           }
  map.function_group :consultant_level_info, {
                                               :en => {:name => "Consultant Level Info", :description => "Consultant Level Info"},
                                               :zh => {:name => "顾问等级", :description => "新建、查看、编辑一顾问等级"}
                                           }
  map.function_group :consultant_level_info, {
                                               :zone_code => "SYSTEM_SETTING",
                                               :controller => "ccc/consultant_levels",
                                               :action => "index"}
  map.function_group :consultant_level_info, {
                                               :children => {
                                                   :consultant_level_info => {
                                                       :en => {:name => "Manage Consultant Level", :description => "Manage Consultant Level"},
                                                       :zh => {:name => "管理顾问等级", :description => "管理顾问等级"},
                                                       :default_flag => "N",
                                                       :login_flag => "N",
                                                       :public_flag => "N",
                                                       "ccc/consultant_levels" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                                   },
                                               }
                                           }

  map.function_group :consultant_module_info, {
                                                :en => {:name => "Consultant Module Info", :description => "Consultant Module Info"},
                                                :zh => {:name => "模块", :description => "新建、查看、编辑一模块"},
                                            }
  map.function_group :consultant_module_info, {
                                                :zone_code => "SYSTEM_SETTING",
                                                :controller => "ccc/consultant_modules",
                                                :action => "index"}
  map.function_group :consultant_module_info, {
                                                :children => {
                                                    :consultant_module_info => {
                                                        :en => {:name => "Manage Consultant Module", :description => "Manage Consultant Module"},
                                                        :zh => {:name => "管理模块", :description => "管理模块"},
                                                        :default_flag => "N",
                                                        :login_flag => "N",
                                                        :public_flag => "N",
                                                        "ccc/consultant_modules" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                                    },
                                                }
                                            }
  map.function_group :consultant_status_info, {
                                                :en => {:name => "Consultant Status Info", :description => "Consultant Status Info"},
                                                :zh => {:name => "顾问状态", :description => "新建、查看、编辑一顾问状态"},
                                            }
  map.function_group :consultant_status_info, {
                                                :zone_code => "SYSTEM_SETTING",
                                                :controller => "ccc/consultant_statuses",
                                                :action => "index"}
  map.function_group :consultant_status_info, {
                                                :children => {
                                                    :consultant_status_info => {
                                                        :en => {:name => "Manage Consultant Status", :description => "Manage Consultant Status"},
                                                        :zh => {:name => "管理顾问状态", :description => "管理顾问状态"},
                                                        :default_flag => "N",
                                                        :login_flag => "N",
                                                        :public_flag => "N",
                                                        "ccc/consultant_statuses" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                                    },
                                                }
                                            }

  map.function_group :consultant_type_info, {
                                              :en => {:name => "Consultant Type Info", :description => "Consultant Type Info"},
                                              :zh => {:name => "顾问类型", :description => "新建、查看、编辑一顾问类型"},
                                          }
  map.function_group :consultant_type_info, {
                                              :zone_code => "SYSTEM_SETTING",
                                              :controller => "ccc/consultant_types",
                                              :action => "index"}
  map.function_group :consultant_type_info, {
                                              :children => {
                                                  :consultant_type_info => {
                                                      :en => {:name => "Manage Consultant Type", :description => "Manage Consultant Type"},
                                                      :zh => {:name => "管理顾问类型", :description => "管理顾问类型"},
                                                      :default_flag => "N",
                                                      :login_flag => "N",
                                                      :public_flag => "N",
                                                      "ccc/consultant_types" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                                  },
                                              }
                                          }
  map.function_group :blog, {
                              :en => { :name => "blog", :description => "blog" },
                              :zh => { :name => "博客", :description => "博客" }, }
  map.function_group :blog, {
                              :zone_code => "SYSTEM_SETTING",
                              :controller => "ccc/blog",
                              :action => "index" }
  map.function_group :blog, {
                              :children => {
                                  :blog => {
                                      :en => { :name => "blog", :description => "blog" },
                                      :zh => { :name => "曲小妍的博客", :description => "曲小妍的博客" },
                                      :default_flag => "Y",
                                      :login_flag => "N",
                                      :public_flag => "N",
                                      "ccc/blog" => ["index", "get_data", "new", "create", "edit", "update", "show", "delete"]


                                  },
                              }
                          }


  map.function_group :customer_status_info, {
                                              :en => {:name => "Customer Status Info", :description => "Customer Status Info"},
                                              :zh => {:name => "客户状态", :description => "新建、查看、编辑一客户状态"},
                                          }
  map.function_group :customer_status_info, {
                                              :zone_code => "SYSTEM_SETTING",
                                              :controller => "ccc/customer_statuses",
                                              :action => "index"}
  map.function_group :customer_status_info, {
                                              :children => {
                                                  :customer_status_info => {
                                                      :en => {:name => "Manage Customer Status", :description => "Manage Customer Status"},
                                                      :zh => {:name => "管理客户状态", :description => "管理客户状态"},
                                                      :default_flag => "N",
                                                      :login_flag => "N",
                                                      :public_flag => "N",
                                                      "ccc/customer_statuses" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                                  },
                                              }
                                          }






  map.function_group :sex_info, {
                                  :en => {:name => "Sex Info", :description => "Sex Info"},
                                  :zh => {:name => "性别", :description => "新建、查看、编辑一性别"},
                              }
  map.function_group :sex_info, {
                                  :zone_code => "SYSTEM_SETTING",
                                  :controller => "ccc/sexes",
                                  :action => "index"}
  map.function_group :sex_info, {
                                  :children => {
                                      :sex_info => {
                                          :en => {:name => "Manage Sex", :description => "Manage Sex"},
                                          :zh => {:name => "管理性别", :description => "管理性别"},
                                          :default_flag => "N",
                                          :login_flag => "N",
                                          :public_flag => "N",
                                          "ccc/sexes" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                      },
                                  }
                              }


  map.menu :organization_management, {
                                       :en => {:name => "Organization Information", :description => "Organization Information"},
                                       :zh => {:name => "组织信息", :description => "组织信息"},
                                       :children => {
                                           :industry_info => {
                                               :type => "function",
                                               :entry => {
                                                   :sequence => 40,
                                                   :en => {:name => "Industry Info", :description => "Industry Info"},
                                                   :zh => {:name => "所属行业", :description => "新建、查看、编辑一行业"},
                                               }
                                           },
                                           :conn_type_info => {
                                               :type => "function",
                                               :entry => {
                                                   :sequence => 50,
                                                   :en => {:name => "Connect Type Info", :description => "Connect Type Info"},
                                                   :zh => {:name => "连接类型", :description => "新建、查看、编辑一连接类型"},
                                               }
                                           }

                                       }
                                   }

  map.function_group :conn_type_info, {
                                        :en => {:name => "Connect Type Info", :description => "Connect Type Info"},
                                        :zh => {:name => "连接类型", :description => "新建、查看、编辑一连接类型"}, }
  map.function_group :conn_type_info, {
                                        :zone_code => "SYSTEM_SETTING",
                                        :controller => "ccc/conn_types",
                                        :action => "index"}
  map.function_group :conn_type_info, {
                                        :children => {
                                            :conn_type_info => {
                                                :en => {:name => "Manage Connect Type", :description => "Manage Connect Type"},
                                                :zh => {:name => "管理连接类型", :description => "管理连接类型"},
                                                :default_flag => "N",
                                                :login_flag => "N",
                                                :public_flag => "N",
                                                "ccc/conn_types" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                            },
                                        }
                                    }

  map.function_group :industry_info, {
                                       :en => {:name => "Industry Info", :description => "Industry Info"},
                                       :zh => {:name => "所属行业", :description => "新建、查看、编辑一行业"}, }
  map.function_group :industry_info, {
                                       :zone_code => "SYSTEM_SETTING",
                                       :controller => "ccc/industries",
                                       :action => "index"}
  map.function_group :industry_info, {
                                       :children => {
                                           :industry_info => {
                                               :en => {:name => "Manage Industry Info", :description => "Manage Industry Info"},
                                               :zh => {:name => "管理行业信息", :description => "管理行业信息"},
                                               :default_flag => "N",
                                               :login_flag => "N",
                                               :public_flag => "N",
                                               "ccc/industries" => ["edit","get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update","create"]
                                           },
                                       }
                                   }


  map.menu :management_setting, {
                                  :children => {
                                      :hotline_project => {
                                          :type => "menu",
                                          :entry => {
                                              :sequence => 100,
                                              :en => {:name => "Hotline", :description => "Hotline"},
                                              :zh => {:name => "Hotline", :description => "Hotline"}
                                          }
                                      }
                                  }
                              }

  map.menu :hotline_project, {
                               :en => {:name => "Hotline", :description => "Hotline"},
                               :zh => {:name => "Hotline", :description => "Hotline"},
                               :children => {
                                   :hotline_project => {
                                       :type => "function",
                                       :entry => {
                                           :sequence => 10,
                                           :en => {:name => "Hotline", :description => "Hotline"},
                                           :zh => {:name => "Hotline", :description => "Hotline"}
                                       }
                                   }
                               }
                           }

  map.function_group :hotline_project, {
                                         :en => {:name => "Hotline Project", :description => "Hotline Project"},
                                         :zh => {:name => "Hotline项目", :description => "Hotline项目"}, }
  map.function_group :hotline_project, {
                                         :zone_code => "SYSTEM_SETTING",
                                         :controller => "irm/projects",
                                         :action => "index"}

  map.function_group :hotline_project, {
                                         :children => {
                                             :hotline_project_new => {
                                                 :en => {:name => "Create Project", :description => "Create Project"},
                                                 :zh => {:name => "创建项目", :description => "创建项目"},
                                                 :default_flag => "N",
                                                 :login_flag => "N",
                                                 :public_flag => "N",
                                                 "irm/projects" => ["new","edit","update", "create", "add_person", "create_person"]
                                             },
                                             :view_hotline_project => {
                                                 :en => {:name => "View Project", :description => "View Project"},
                                                 :zh => {:name => "查看项目", :description => "查看项目"},
                                                 :default_flag => "N",
                                                 :login_flag => "N",
                                                 :public_flag => "N",
                                                 "irm/projects" => ["index","get_data", "show", "get_support_person_list_data", "get_customer_list_data"]
                                             },
                                             :edit_hotline_project => {
                                                 :en => {:name => "Edit Project", :description => "Edit Project"},
                                                 :zh => {:name => "编辑项目", :description => "编辑项目"},
                                                 :default_flag => "N",
                                                 :login_flag => "N",
                                                 :public_flag => "N",
                                                 "irm/projects" => ["edit","update","add_person", "create_person", "add_supporters", "add_customers",
                                                                    "remove_project_supporter", "add_customer_to_project", "add_supporter_to_project",
                                                                    "remove_project_customer", "get_available_project_supporter_data",
                                                                    "get_available_project_customer_data"]
                                             }
                                         }
                                     }

  map.function_group :work_calendar, {
                                       :children => {
                                           :synch_work_calendar => {
                                               :en => {:name => "Synch Work Calendar", :description => "Synch Work Calendar"},
                                               :zh => {:name => "工作日历复制", :description => "工作日历复制"},
                                               :default_flag => "N",
                                               :login_flag => "N",
                                               :public_flag => "N",
                                               "slm/calendars" => ["synch"]
                                           }

                                       }
                                   }

  map.function_group :incident_request, {
                                          :children => {
                                              :change_urgence_in_submit => {
                                                  :en => {:name => "Change Urgence during Submit", :description => "Change Urgence during Submit"},
                                                  :zh => {:name => "Change Urgence during Submit", :description => "Change Urgence during Submit"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  "icm/incident_requests" => ["get_data"],
                                              },
                                              :quick_edit_status => {
                                                  :zh => {:name => "Quick Status Edition", :description => "Quick Status Edition"},
                                                  :en => {:name => "Quick Status Edition", :description => "Quick Status Edition"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  :system_flag => "Y",
                                                  "icm/incident_journals" => ["update_status"]
                                              },
                                              :edit_additional_info => {
                                                  :zh => {:name => "附加信息维护", :description => "附加信息维护"},
                                                  :en => {:name => "Edit Additional Info.", :description => "Edit Additional Info."},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  :system_flag => "Y",
                                                  "icm/incident_requests" => ["edit", "update"]
                                              },
                                              :additional_info_area1 => {
                                                  :zh => {:name => "附加信息1区", :description => "附加信息1区"},
                                                  :en => {:name => "Additional Info. 1", :description => "Additional Info. 1"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  :system_flag => "Y",
                                                  "icm/incident_requests" => ["edit", "update"]
                                              },
                                              ##状态
                                              :additional_info_area2 => {
                                                  :zh => {:name => "附加信息2区", :description => "附加信息2区"},
                                                  :en => {:name => "Additional Info. 2", :description => "Additional Info. 2"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  :system_flag => "Y",
                                                  "icm/incident_requests" => ["edit", "update"]
                                              },
                                              :additional_info_area3 => {
                                                  :zh => {:name => "附加信息3区", :description => "附加信息3区"},
                                                  :en => {:name => "Additional Info. 3", :description => "Additional Info. 3"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  :system_flag => "Y",
                                                  "icm/incident_requests" => ["edit", "update"]
                                              },
                                          }
                                      }
end