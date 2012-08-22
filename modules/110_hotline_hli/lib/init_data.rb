#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
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
          },
          :edit_self_hotline_project => {
              :en => {:name => "Edit Self Project", :description => "Edit Self Project"},
              :zh => {:name => "编辑自己的项目", :description => "编辑自己的项目"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N"
          }
      }
  }

  map.menu :hotline, {
      :en => {:name => "Hotline", :description => "Hotline"},
      :zh => {:name => "Hotline", :description => "Hotline"},
      :children => {
          :hotline_project => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Hotline", :description => "Hotline"},
                  :zh => {:name => "Hotline", :description => "Hotline"},
              }
          }
      }
  }
end