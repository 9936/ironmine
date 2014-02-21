#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:Sales=================================
  map.function_group :dev_management, {
      :en => {:name => "Development Management", :description => "Development Management"},
      :zh => {:name => "开发管理", :description => "开发管理"}
  }
  map.function_group :dev_management, {
      :zone_code => "DEV_MAN",
      :controller => "dem/dev_managements",
      :action => "index"}
  map.function_group :dev_management, {
      :children => {
          :sales_opportunity => {
              :en => {:name => "Development Management", :description => "Development Management"},
              :zh => {:name => "开发管理", :description => "开发管理"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "dem/dev_managements" => ["index", "new", "create", "edit", "update", "show", "get_data", "destroy"]
          }
      }
  }
  #=================================END:Sales=================================
end