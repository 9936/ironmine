#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #登录访问
  map.function_group :home_page, {
      :children => {
          :login_function => {
              "sug/countries" => ["get_province_data"],
              "sug/provinces" => ["get_city_data"],
              "sug/cities" => ["get_district_data"],
          }
      }
  }

  #====================================Start 客户管理======================================
  map.menu :management_setting, {
      :children => {
          :customer_management => {
              :type => "menu",
              :entry => {
                  :sequence => 15,
                  :en => {:name => "Customer Setting", :description => "Customer Setting"},
                  :zh => {:name => "客户管理", :description => "客户管理"}
              }
          }
      }
  }
  map.menu :customer_management, {
      :en => {:name => "Customer Setting", :description => "Customer Setting"},
      :zh => {:name => "客户管理", :description => "客户管理"},
      :children => {
          :sug_customer => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Customer", :description => "Customer"},
                  :zh => {:name => "客户", :description => "客户"},
              }
          },
          :sug_contact => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Contact", :description => "Contact"},
                  :zh => {:name => "联系人", :description => "联系人"},
              }
          }
      }
  }

  map.function_group :sug_customer, {
      :en => {:name => "Customer", :description => "Customer"},
      :zh => {:name => "客户", :description => "客户"}
  }
  map.function_group :sug_customer, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "sug/customers",
      :action => "index"}
  map.function_group :sug_customer, {
      :children => {
          :sug_customer => {
              :en => {:name => "Manage Customer", :description => "Manage Customer"},
              :zh => {:name => "管理客户", :description => "管理客户"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "sug/customers" => ["create", "edit", "get_data", "index", "new", "show", "update"],
          },
      }
  }
  #====================================End 客户管理======================================
  map.function_group :sug_customer, {
      :en => {:name => "Customer", :description => "Customer"},
      :zh => {:name => "客户", :description => "客户"}
  }
  map.function_group :sug_customer, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "sug/customers",
      :action => "index"}
  map.function_group :sug_customer, {
      :children => {
          :sug_customer => {
              :en => {:name => "Manage Customer", :description => "Manage Customer"},
              :zh => {:name => "管理客户", :description => "管理客户"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "sug/customers" => ["create", "edit", "get_data", "index", "new", "show", "update", "nicknames", "create_nickname",
                                  "owned_contacts", "available_contacts", "create_contacts", "remove_contacts"]
          },
      }
  }
  #====================================Start 联系人======================================
  map.function_group :sug_contact, {
      :en => {:name => "Contact", :description => "Contact"},
      :zh => {:name => "联系人", :description => "联系人"},
  }
  map.function_group :sug_contact, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "sug/contacts",
      :action => "index"}
  map.function_group :sug_contact, {
      :children => {
          :sug_contact => {
              :en => {:name => "Manage Contact", :description => "Manage Contact"},
              :zh => {:name => "管理联系人", :description => "管理联系人"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "sug/contacts" => ["create", "edit", "get_data", "index", "new", "show", "update"],
          },
      }
  }
  #====================================End 联系人======================================

  #====================================Start 覆盖事故单菜单设置======================================
  map.menu :management_setting, {
      :children => {
          :incident_management => {
              :en => {:name => "Incident Setting", :description => "Incident Setting"},
              :zh => {:name => "服务单管理", :description => "服务单管理"},
              :type => "menu",
              :entry => {
                  :sequence => 50,
                  :en => {:name => "Incident Setting", :description => "Incident Setting"},
                  :zh => {:name => "服务单管理", :description => "服务单管理"}
              }
          }
      }
  }
  map.menu :incident_management, {
      :children => {
          :mail_request => {
              :type => "function",
              :entry => {
                  :sequence => 100,
                  :en => {:name => "Mail Request Conf.", :description => "Mail Request Conf."},
                  :zh => {:name => "邮服务单设置", :description => "邮服务单设置"},
              }
          },
          :incident_category => {
              :type => "function",
              :entry => {
                  :sequence => 35,
                  :en => {:name => "Incident Category", :description => "Incident Category"},
                  :zh => {:name => "分类设置", :description => "创建、编辑服务单的分类，或为分类添加子分类"},
              }
          },
          :sug_category => {
              :type => "function",
              :entry => {
                  :sequence => 36,
                  :en => {:name => "Category Tree", :description => "Category Tree"},
                  :zh => {:name => "三级类型", :description => "三级类型"},
              }
          }
      }
  }

  #====================================Start 技能======================================
  map.menu :user_management, {
      :children => {
          :sug_skill => {
              :type => "function",
              :entry => {
                  :sequence => 40,
                  :en => {:name => "Skill", :description => "Skill"},
                  :zh => {:name => "技能", :description => "技能管理"}
              }
          }
      }
  }


  map.function_group :sug_skill, {
      :en => {:name => "Skill", :description => "Skill"},
      :zh => {:name => "技能", :description => "技能管理"}
  }
  map.function_group :sug_skill, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "sug/skills",
      :action => "index"}
  map.function_group :sug_skill, {
      :children => {
          :sug_skill => {
              :en => {:name => "Skill Setting", :description => "Skill Setting"},
              :zh => {:name => "技能设置", :description => "技能设置"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "sug/skills" => ["create", "edit", "get_data", "index", "new", "show", "update",
                               "owned_categories", "available_categories", "create_categories", "remove_categories"]
          },
      }
  }
  #====================================End 技能======================================

  #====================================End 覆盖事故单菜单设置======================================

  map.function_group :sug_category, {
      :en => {:name => "Customer", :description => "Customer"},
      :zh => {:name => "客户", :description => "客户"}
  }
  map.function_group :sug_category, {
      :zone_code => "INCIDENT_SETTING",
      :controller => "sug/categories",
      :action => "index"}
  map.function_group :sug_category, {
      :children => {
          :sug_category => {
              :en => {:name => "Category Tree", :description => "Category Tree"},
              :zh => {:name => "三级类型设置", :description => "三级类型设置"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "sug/categories" => ["create", "edit", "get_data", "index", "new", "show", "update", "get_children"],
          },
      }
  }


  #=================================START:国家、省市地区=================================
  map.menu :cloud_base_setting, {
      :children => {
          :sug_regions => {
              :type => "function",
              :entry => {
                  :sequence => 40,
                  :en => {:name => "Regions", :description => "Regions"},
                  :zh => {:name => "省市地区", :description => "省市地区"},
              }
          }
      }
  }
  map.function_group :sug_regions, {
      :en => {:name => "Regions Settings", :description => "Regions Settings"},
      :zh => {:name => "省市地区", :description => "省市地区"}
  }
  map.function_group :sug_regions, {
      :zone_code => "SYSTEM_CUSTOM",
      :controller => "sug/countries",
      :action => "index"
  }
  map.function_group :sug_regions, {
      :children => {
          :sug_regions => {
              :en => {:name => "Regions Settings", :description => "Regions Settings"},
              :zh => {:name => "省市地区设置", :description => "省市地区设置"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "sug/countries" => ["index", "show", "get_data","edit","update", "new", "create"],
              "sug/provinces" => ["show", "get_data","edit","update", "new", "create"],
              "sug/cities" => ["show", "get_data","edit","update", "new", "create"],
              "sug/districts" => ["show", "get_data","edit","update", "new", "create"],
          }
      }
  }
  #=================================END:国家、省市地区=================================


end