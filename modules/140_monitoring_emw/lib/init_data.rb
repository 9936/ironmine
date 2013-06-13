#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:EBS=================================
  map.function_group :ebs_modules, {
      :en => {:name => "EBS Modules", :description => "EBS Modules"},
      :zh => {:name => "EBS 模块", :description => "EBS 模块"}
  }
  map.function_group :ebs_modules, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "emw/ebs_modules",
      :action => "index"
  }
  map.function_group :ebs_modules, {
      :children => {
          :ebs_modules => {
              :en => {:name => "EBS Modules", :description => "EBS Modules"},
              :zh => {:name => "EBS 模块", :description => "EBS 模块"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "emw/ebs_modules" => ["index", "show", "get_data","edit","update", "new", "create", "multilingual_edit", "multilingual_update"]
          }
      }
  }
  #=================================START:CALENDAR=================================

end