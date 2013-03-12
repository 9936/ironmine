#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|


  #====================================START:PERSONAL_SETTING======================================
  map.menu :system_common_setting, {

      :children => {
        :service_management=>{
            :type => "menu",
            :entry => {
                :sequence => 50,
                :en => {:name => "Service Management", :description => "Service Management"},
                :zh => {:name => "服务管理", :description => "服务管理"}
            }
        }
      }
  }
  #====================================END:PERSONAL_SETTING======================================
  #====================================START:SERVICE_MANAGEMENT======================================
  #=================================START:CALENDAR=================================
  map.menu :system_common_setting, {
      :children => {
          :system_service_management => {
              :type => "menu",
              :entry => {
                  :sequence => 40,
                  :en => {:name => "Service Management", :description => "Service Management"},
                  :zh => {:name => "服务管理", :description => "服务管理"}
              }
          }
      }
  }
  map.menu :system_service_management, {
      :en => {:name => "Service Management", :description => "Service Management"},
      :zh => {:name => "服务管理", :description => "服务管理"},
      :children => {
          :work_calendar => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Work Calendar", :description => "Work Calendar"},
                  :zh => {:name => "工作日历", :description => "工作日历"}
              }
          },
          :service_agreement => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Argeement", :description => "Argeement"},
                  :zh => {:name => "服务协议", :description => "定义服务协议（SLA）"},
              }
          }
      }
  }

  #map.menu :service_management, {
  #    :en => {:name => "Service Management", :description => "Service Management"},
  #    :zh => {:name => "服务管理", :description => "服务管理"},
  #    :children => {
  #        :service_category => {
  #            :type => "function",
  #            :entry => {
  #                :sequence => 10,
  #                :en => {:name => "Category", :description => "Category"},
  #                :zh => {:name => "服务类别", :description => "定义运维服务类别"},
  #            }},
  #        :service_catalog => {
  #            :type => "function",
  #            :entry => {
  #                :sequence => 20,
  #                :en => {:name => "Catalog", :description => "Catalog"},
  #                :zh => {:name => "服务目录", :description => "定义运维服务目录"},
  #            }},
  #        :work_calendar => {
  #            :type => "function",
  #            :entry => {
  #                :sequence => 30,
  #                :en => {:name => "Work Calendar", :description => "Work Calendar"},
  #                :zh => {:name => "工作日历", :description => "工作日历"}
  #            }
  #        },
  #        :service_agreement => {
  #            :type => "function",
  #            :entry => {
  #                :sequence => 40,
  #                :en => {:name => "Argeement", :description => "Argeement"},
  #                :zh => {:name => "服务协议", :description => "定义服务协议（SLA）"},
  #            }
  #        }
  #
  #    }
  #}
  #====================================END:SERVICE_MANAGEMENT======================================


  #=================================START:SERVICE_CATEGORY=================================
  #map.function_group :service_category, {
  #    :en => {:name => "Category", :description => "Category"},
  #    :zh => {:name => "服务类别", :description => "定义运维服务类别"}, }
  #map.function_group :service_category, {
  #    :zone_code => "SYSTEM_SETTING",
  #    :controller => "slm/service_categories",
  #    :action => "index"}
  #map.function_group :service_category, {
  #    :children => {
  #        :service_category => {
  #            :en => {:name => "Manage Category", :description => "Manage Category"},
  #            :zh => {:name => "管理服务类别", :description => "管理服务类别"},
  #            :default_flag => "N",
  #            :login_flag => "N",
  #            :public_flag => "N",
  #            "slm/service_categories" => ["create", "edit", "get_data", "index", "new", "show", "update"],
  #        },
  #    }
  #}
  ##=================================END:SERVICE_CATEGORY=================================
  #
  ##=================================START:SERVICE_CATALOG=================================
  #map.function_group :service_catalog, {
  #    :en => {:name => "Catalog", :description => "Catalog"},
  #    :zh => {:name => "服务目录", :description => "定义运维服务目录"}, }
  #map.function_group :service_catalog, {
  #    :zone_code => "SYSTEM_SETTING",
  #    :controller => "slm/service_catalogs",
  #    :action => "index"}
  #map.function_group :service_catalog, {
  #    :children => {
  #        :service_catalog => {
  #            :en => {:name => "Manage Catalog", :description => "Manage Catalog"},
  #            :zh => {:name => "管理服务目录", :description => "管理服务目录"},
  #            :default_flag => "N",
  #            :login_flag => "N",
  #            :public_flag => "N",
  #            "slm/service_breaks" => ["create", "edit", "new", "update"],
  #            "slm/service_catalogs" => ["create", "edit", "get_data", "index", "new", "show", "update"],
  #            "slm/service_members" => ["create", "edit", "new", "update"],
  #        },
  #    }
  #}
  #=================================END:SERVICE_CATALOG=================================

  #=================================START:SERVICE_AGREEMENT=================================
  map.function_group :service_agreement, {
      :en => {:name => "Argeement", :description => "Argeement"},
      :zh => {:name => "服务协议", :description => "定义服务协议（SLA）"},
  }
  map.function_group :service_agreement, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "slm/service_agreements",
      :action => "index",
      :system_flag => 'Y'
  }
  map.function_group :service_agreement, {
      :children => {
          :service_agreement => {
              :en => {:name => "Manage Argeement", :description => "Manage Argeement"},
              :zh => {:name => "管理服务协议", :description => "管理服务协议"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "slm/service_agreements" => ["create", "edit", "get_data", "index", "new", "show", "update","add_exists_action","save_exists_action","destroy_action","show_relations"],
              "slm/time_triggers" => ["create", "edit", "index", "new", "update","destroy"]
          },
      }
  }
  #=================================END:SERVICE_AGREEMENT=================================


  map.function_group :work_calendar, {
      :en => {:name => "Work Calendar", :description => "Work Calendar"},
      :zh => {:name => "工作日历", :description => "工作日历"},
      :system_flag => 'Y'
  }
  map.function_group :work_calendar, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "slm/calendars",
      :action => "index"
  }
  map.function_group :work_calendar, {
      :children => {
          :work_calendar => {
              :en => {:name => "Work Calendar", :description => "Work Calendar"},
              :zh => {:name => "工作日历", :description => "工作日历"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "slm/calendars" => ["index", "show", "schedule_events", "get_data","edit","update", "new", "create", "multilingual_edit", "multilingual_update"],
              "slm/calendar_items" => ["destroy", "show", "get_data","edit","update", "new", "create", "multilingual_edit", "multilingual_update"]
          }
      }
  }
  #=================================START:CALENDAR=================================
end