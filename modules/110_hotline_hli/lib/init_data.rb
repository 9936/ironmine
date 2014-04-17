#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
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