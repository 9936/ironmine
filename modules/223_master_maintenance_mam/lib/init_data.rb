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
              "mam/masters" => ["index", "get_data", "show"]
          },
          :new_master => {
              :en => {:name => "New", :description => "New"},
              :zh => {:name => "New", :description => "New"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["new", "create",
                                "new_item", "new_scs", "new_urs",
                                "get_ur_data","get_item_data",
                                "add_item","create_reply", "add_ur",
                                "create_scs", "create_urs", "create_item",
                                "delete_ur", "delete_item"]
          },
          :edit_master => {
              :en => {:name => "Edit", :description => "Edit"},
              :zh => {:name => "Edit", :description => "Edit"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["new_item", "new_scs", "new_urs",
                                "get_ur_data","edit_item","edit_scs",
                                "edit_urs", "update",
                                "update_item", "update_scs", "update_urs",
                                "get_item_data", "delete_item", "add_item",
                                "delete_ur", "delete_item",
                                "create_scs"]
          },
          :create_reply => {
              :en => {:name => "New Reply", :description => "New Reply"},
              :zh => {:name => "New Reply", :description => "New Reply"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["create_reply"]
          },
          :update_assign =>{
              :en => {:name => "Assign", :description => "Assign"},
              :zh => {:name => "Assign", :description => "Assign"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["update_assign"],
              "icm/support_groups" => ["get_member_options"]
          },
          :update_receive =>{
              :en => {:name => "Receive", :description => "Receive"},
              :zh => {:name => "Receive", :description => "Receive"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["update_assign"]
          },
          :update_status =>{
              :en => {:name => "Update Status", :description => "Update Status"},
              :zh => {:name => "Update Status", :description => "Update Status"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["update_status"]
          },
          :update_close =>{
              :en => {:name => "Close", :description => "Close"},
              :zh => {:name => "Close", :description => "Close"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "mam/masters" => ["update_status"]
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
              "mam/systems" => ["index", "get_data", "new", "create", "edit", "update","show","add_people_create",
                                "add_people", "get_owned_members_data", "delete_person", "get_memberable_data",
                                "add_support_group_create",
                                "add_support_groups", "get_owned_groups_data", "delete_support_group", "get_groupable_data"]
          }
      }
  }

end