#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|

  map.function_group :master, {
      :en => {:name => "Master", :description => "Master"},
      :zh => {:name => "Master", :description => "Master"}, }
  map.function_group :master, {
      :zone_code => "MASTER",
      :controller => "mam/masters",
      :action => "index"}
  map.function_group :master, {
      :children => {
          :view_master => {
              :en => {:name => "View", :description => "View"},
              :zh => {:name => "查看", :description => "查看"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["index", "get_data"]
          },
          :new_master => {
              :en => {:name => "New", :description => "New"},
              :zh => {:name => "New", :description => "New"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["new", "create", "new_item", "new_scs", "new_urs"]
          },
          :edit_master => {
              :en => {:name => "Edit", :description => "Edit"},
              :zh => {:name => "Edit", :description => "Edit"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["edit", "update"]
          }

      }
  }

  map.menu :management_setting, {
      :children => {
          :mam_system => {
              :type => "menu",
              :entry => {
                  :sequence => 100,
                  :en => {:name => "MM System", :description => "MM System"},
                  :zh => {:name => "MM System", :description => "MM System"}
              }
          }
      }
  }

  map.menu :mam_system, {
      :en => {:name => "MM System", :description => "MM System"},
      :zh => {:name => "MM System", :description => "MM System"},
      :children => {
          :mam_system => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "MM System", :description => "MM System"},
                  :zh => {:name => "MM System", :description => "MM System"}
              }
          }
      }
  }

  map.function_group :mam_system, {
      :en => {:name => "MM System", :description => "MM System"},
      :zh => {:name => "MM System", :description => "MM System"}, }
  map.function_group :mam_system, {
      :zone_code => "MM_SYSTEM",
      :controller => "mam/systems",
      :action => "index"}
  map.function_group :mam_system, {
      :children => {
          :manage_system => {
              :en => {:name => "View", :description => "View"},
              :zh => {:name => "查看", :description => "查看"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/systems" => ["index", "get_data", "new", "create", "edit", "update"],
              "mam/system_people" => ["add_people", "get_available_people_data"]
          }
      }
  }

end