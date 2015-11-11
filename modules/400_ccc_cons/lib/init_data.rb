#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|

  map.menu :management_setting, {
          :children => {
            :cons_management => {
              :type => "menu",
              :entry => {
                  :sequence => 150,
                  :en => {:name => "Data Setting", :description => "Data Setting"},
                  :zh => {:name => "数据管理", :description => "数据管理"}
              }
            }
          }
      }
  map.menu :cons_management, {
      :en => {:name => "Data Setting", :description => "Data Setting"},
      :zh => {:name => "数据管理", :description => "数据管理"},
      :children => {
          :cons_categories => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Consultant List", :description => "Consultant List"},
                  :zh => {:name => "顾问列表", :description => "顾问列表"}
              }
          },
          # 客户主数据
          :cus_categories => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Customer List", :description => "Customer List"},
                  :zh => {:name => "客户列表", :description => "客户列表"}
              }
          },
          # 公司主数据
          :com_categories => {
              :type => "function",
              :entry => {
                  :sequence => 30,
                  :en => {:name => "Company List", :description => "Company List"},
                  :zh => {:name => "公司列表", :description => "公司列表"}
              }
          },
          # 项目主数据
          :pro_categories => {
              :type => "function",
              :entry => {
                  :sequence => 40,
                  :en => {:name => "Product List", :description => "Product List"},
                  :zh => {:name => "项目列表", :description => "项目列表"}
              }
          },
          # 行业数据
          :ind_categories => {
              :type => "function",
              :entry => {
                  :sequence => 50,
                  :en => {:name => "Industry List", :description => "Industry List"},
                  :zh => {:name => "行业", :description => "行业"}
              }
          },
          # 连接类型
          :connect_categories => {
              :type => "function",
              :entry => {
                  :sequence => 60,
                  :en => {:name => "Connect List", :description => "Connect List"},
                  :zh => {:name => "连接类型", :description => "连接类型"}
              }
          },
          # 项目类型
          :ptype_categories => {
              :type => "function",
              :entry => {
                  :sequence => 70,
                  :en => {:name => "Project Type List", :description => "Project Type List"},
                  :zh => {:name => "项目类型", :description => "项目类型"}
              }
          },
          # 计价方式
          :price_categories => {
              :type => "function",
              :entry => {
                  :sequence => 80,
                  :en => {:name => "Pricing Type List", :description => "Pricing Type List"},
                  :zh => {:name => "计价方式", :description => "计价方式"}
              }
          },
          # 顾问类型
          :cons_type_categories => {
              :type => "function",
              :entry => {
                  :sequence => 90,
                  :en => {:name => "Consultans Type List", :description => "Consultans Type List"},
                  :zh => {:name => "顾问类型", :description => "顾问类型"}
              }
          },
          # 模块
          :module_categories => {
              :type => "function",
              :entry => {
                  :sequence => 100,
                  :en => {:name => "Module List", :description => "Module List"},
                  :zh => {:name => "模块", :description => "模块"}
              }
          },
          # 状态
          :status_categories => {
              :type => "function",
              :entry => {
                  :sequence => 110,
                  :en => {:name => "Status List", :description => "Status List"},
                  :zh => {:name => "状态", :description => "状态"}
              }
          },
          # 组别
          # :group_categories => {
          #     :type => "function",
          #     :entry => {
          #         :sequence => 120,
          #         :en => {:name => "Group List", :description => "Group List"},
          #         :zh => {:name => "组别", :description => "组别"}
          #     }
          # },
          # Level
          :level_categories => {
              :type => "function",
              :entry => {
                  :sequence => 130,
                  :en => {:name => "Level List", :description => "Level List"},
                  :zh => {:name => "Level", :description => "Level"}
              }
          }
      }
  }

  map.function_group :level_categories, {
                                          :en => {:name => "Level List", :description => "Level List"},
                                          :zh => {:name => "Level", :description => "Level"}
                                      }
  map.function_group :level_categories, {
                                          :zone_code => "Level List",
                                          :controller => "cons/level",
                                          :action => "index"
                                      }
  map.function_group :level_categories, {
                                          :children => {
                                              :level_categories => {
                                                  :en => {:name => "Level List", :description => "Level List"},
                                                  :zh => {:name => "Level", :description => "Level"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  "cons/level" => ["index","create","new","show","edit","update"]
                                              },
                                          }
                                      }

  # map.function_group :group_categories, {
  #                                         :en => {:name => "Group List", :description => "Group List"},
  #                                         :zh => {:name => "组别", :description => "组别"}
  #                                      }
  # map.function_group :group_categories, {
  #                                          :zone_code => "Group List",
  #                                          :controller => "cons/group",
  #                                          :action => "index"
  #                                      }
  # map.function_group :group_categories, {
  #                                          :children => {
  #                                              :group_categories => {
  #                                                  :en => {:name => "Group List", :description => "Group List"},
  #                                                  :zh => {:name => "组别", :description => "组别"},
  #                                                  :default_flag => "N",
  #                                                  :login_flag => "N",
  #                                                  :public_flag => "N",
  #                                                  "cons/group" => ["index","create","new","show","edit","update"]
  #                                              },
  #                                          }
  #                                      }


  map.function_group :status_categories, {
                                           :en => {:name => "Status List", :description => "Status List"},
                                           :zh => {:name => "状态", :description => "状态"}
                                       }
  map.function_group :status_categories, {
                                           :zone_code => "Status List",
                                           :controller => "cons/status",
                                           :action => "index"
                                       }
  map.function_group :status_categories, {
                                           :children => {
                                               :status_categories => {
                                                   :en => {:name => "Status List", :description => "Status List"},
                                                   :zh => {:name => "状态", :description => "状态"},
                                                   :default_flag => "N",
                                                   :login_flag => "N",
                                                   :public_flag => "N",
                                                   "cons/status" => ["index","create","new","show","edit","update"]
                                               },
                                           }
                                       }

  map.function_group :module_categories, {
                                           :en => {:name => "Module List", :description => "Module List"},
                                           :zh => {:name => "模块", :description => "模块"}
                                          }
  map.function_group :module_categories, {
                                              :zone_code => "Module List",
                                              :controller => "cons/module",
                                              :action => "index"
                                          }
  map.function_group :module_categories, {
                                              :children => {
                                                  :module_categories => {
                                                      :en => {:name => "Module List", :description => "Module List"},
                                                      :zh => {:name => "模块", :description => "模块"},
                                                      :default_flag => "N",
                                                      :login_flag => "N",
                                                      :public_flag => "N",
                                                      "cons/module" => ["index","create","new","show","edit","update"]
                                                  },
                                              }
                                          }


  map.function_group :cons_type_categories, {
                                              :en => {:name => "Consultans Type List", :description => "Consultans Type List"},
                                              :zh => {:name => "顾问类型", :description => "顾问类型"}
                                      }
  map.function_group :cons_type_categories, {
                                          :zone_code => "Consultans Type List",
                                          :controller => "cons/consType",
                                          :action => "index"
                                      }
  map.function_group :cons_type_categories, {
                                          :children => {
                                              :cons_type_categories => {
                                                  :en => {:name => "Consultans Type List", :description => "Consultans Type List"},
                                                  :zh => {:name => "顾问类型", :description => "顾问类型"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  "cons/consType" => ["index","create","new","show","edit","update"]
                                              },
                                          }
                                      }


  map.function_group :price_categories, {
                                          :en => {:name => "Pricing Type List", :description => "Pricing Type List"},
                                          :zh => {:name => "计价方式", :description => "计价方式"}
                                      }
  map.function_group :price_categories, {
                                          :zone_code => "Pricing Type List",
                                          :controller => "cons/price",
                                          :action => "index"
                                      }
  map.function_group :price_categories, {
                                          :children => {
                                              :price_categories => {
                                                  :en => {:name => "Pricing Type List", :description => "Pricing Type List"},
                                                  :zh => {:name => "计价方式", :description => "计价方式"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  "cons/price" => ["index","create","new","show","edit","update"]
                                              },
                                          }
                                      }


  map.function_group :ptype_categories, {
                                          :en => {:name => "Project Type List", :description => "Project Type List"},
                                          :zh => {:name => "项目类型", :description => "项目类型"}
                                        }
  map.function_group :ptype_categories, {
                                            :zone_code => "Project Type List",
                                            :controller => "cons/projectType",
                                            :action => "index"
                                        }
  map.function_group :ptype_categories, {
                                            :children => {
                                                :ptype_categories => {
                                                    :en => {:name => "Project Type List", :description => "Project Type List"},
                                                    :zh => {:name => "项目类型", :description => "项目类型"},
                                                    :default_flag => "N",
                                                    :login_flag => "N",
                                                    :public_flag => "N",
                                                    "cons/projectType" => ["index","create","new","show","edit","update"]
                                                },
                                            }
                                        }

  map.function_group :connect_categories, {
                                            :en => {:name => "Connect List", :description => "Connect List"},
                                            :zh => {:name => "连接类型", :description => "连接类型"}
                                    }
  map.function_group :connect_categories, {
                                        :zone_code => "Connect List",
                                        :controller => "cons/connect",
                                        :action => "index"
                                    }
  map.function_group :connect_categories, {
                                        :children => {
                                            :connect_categories => {
                                                :en => {:name => "Connect List", :description => "Connect List"},
                                                :zh => {:name => "连接类型", :description => "连接类型"},
                                                :default_flag => "N",
                                                :login_flag => "N",
                                                :public_flag => "N",
                                                "cons/connect" => ["index","create","new","show","edit","update"]
                                            },
                                        }
                                    }


  map.function_group :ind_categories, {
                                        :en => {:name => "Industry List", :description => "Industry List"},
                                        :zh => {:name => "行业", :description => "行业"}
                                    }
  map.function_group :ind_categories, {
                                        :zone_code => "Industry List",
                                        :controller => "cons/industry",
                                        :action => "index"
                                    }
  map.function_group :ind_categories, {
                                          :children => {
                                              :ind_categories => {
                                                  :en => {:name => "Industry List", :description => "Industry List"},
                                                  :zh => {:name => "行业", :description => "行业"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  "cons/industry" => ["index","create","new","show","edit","update"]
                                              },
                                          }
                                   }

  map.function_group :pro_categories, {
      :en => {:name => "Product List", :description => "Product List"},
      :zh => {:name => "项目列表", :description => "项目列表"}
  }
  map.function_group :pro_categories, {
      :zone_code => "Product List",
      :controller => "cons/product",
      :action => "index"
  }
  map.function_group :pro_categories, {
      :children => {
          :pro_categories => {
              :en => {:name => "Product List", :description => "Product List"},
              :zh => {:name => "项目列表", :description => "项目列表"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "cons/product" => ["index","create","new","show","edit","update"]
          },
      }
  }

  map.function_group :com_categories, {
      :en => {:name => "Company List", :description => "Company List"},
      :zh => {:name => "公司列表", :description => "公司列表"}
  }
  map.function_group :com_categories, {
      :zone_code => "Company List",
      :controller => "cons/company",
      :action => "index"
  }
  map.function_group :com_categories, {
      :children => {
          :com_categories => {
              :en => {:name => "Company List", :description => "Company List"},
              :zh => {:name => "公司列表", :description => "公司列表"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "cons/company" => ["index","create","new","show","edit","update"]
          },
      }
  }

  map.function_group :cus_categories, {
     :en => {:name => "Customer List", :description => "Customer List"},
     :zh => {:name => "客户列表", :description => "客户列表"}
  }
  map.function_group :cus_categories, {
     :zone_code => "Customer List",
     :controller => "cons/customer",
     :action => "index"
  }
  map.function_group :cus_categories, {
     :children => {
         :cus_categories => {
             :en => {:name => "Customer List", :description => "Customer List"},
             :zh => {:name => "客户列表", :description => "客户列表"},
             :default_flag => "N",
             :login_flag => "N",
             :public_flag => "N",
             "cons/customer" => ["index","create","new","show","edit","update","searchCustomerNo"]
         },
     }
  }

  map.function_group :cons_categories, {
           :en => {:name => "Consultant List", :description => "Consultant List"},
           :zh => {:name => "顾问列表", :description => "顾问列表"}
  }
  map.function_group :cons_categories, {
           :zone_code => "Consultant List",
           :controller => "cons/consultants",
           :action => "index"
  }
  map.function_group :cons_categories, {
      :children => {
          :cons_categories => {
              :en => {:name => "Consultant List", :description => "Consultant List"},
              :zh => {:name => "顾问列表", :description => "顾问列表"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "cons/consultants" => ["index","create","new","show","edit","update"]
          },
      }
  }
  end