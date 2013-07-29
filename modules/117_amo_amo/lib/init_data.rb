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

      }
  }
end