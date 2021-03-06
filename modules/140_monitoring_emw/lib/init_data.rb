#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:EBS=================================
  map.function_group :ebs_modules, {
      :en => {:name => "EBS Modules", :description => "EBS Modules"},
      :zh => {:name => "EBS 模块", :description => "EBS 模块"}
  }
  map.function_group :ebs_modules, {
      :zone_code => "EBS_MONITOR",
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
              "emw/ebs_modules" => ["index", "show", "get_data","edit","update", "new", "create"],
              "emw/interfaces" => ["index", "show", "get_data","edit","update", "new", "create"],
              "emw/interface_tables" => ["show", "get_data","edit","update", "new", "create","import"],
              "emw/interface_columns" => ["show", "edit","update", "new", "create","destroy"],
              "emw/error_tables" => ["show", "edit","update", "new", "create","destroy"]

          }
      }
  }
  #=================================START:CALENDAR=================================

  #=================================START:MONITOR_PROGRAM=================================
  map.function_group :ebs_monitor_program, {
      :en => {:name => "Monitor Program", :description => "Monitor Program"},
      :zh => {:name => "监控方案", :description => "监控方案"}
  }
  map.function_group :ebs_monitor_program, {
      :zone_code => "EBS_MONITOR",
      :controller => "emw/monitor_programs",
      :action => "index"
  }
  map.function_group :ebs_monitor_program, {
      :children => {
          :ebs_monitor_program => {
              :en => {:name => "Monitor Program", :description => "Monitor Program"},
              :zh => {:name => "监控方案", :description => "监控方案"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "emw/monitor_programs" => ["index", "show", "get_data","edit","update", "new", "execute",
                                           "create", "get_target_data","new_target", "create_target", "remove_target"],
              "emw/monitor_histories" => ["index","show","get_data"],
              "emw/connections" => ["index","new", "edit", "create", "update" ,"show","get_data", "destroy"]
          }
      }
  }
  #=================================START:MONITOR_PROGRAM=================================

  #=================================START:DATABASE=================================
  map.function_group :ebs_database, {
      :en => {:name => "database", :description => "database"},
      :zh => {:name => "数据库", :description => "数据库"}
  }
  map.function_group :ebs_database, {
      :zone_code => "EBS_MONITOR",
      :controller => "emw/databases",
      :action => "index"
  }
  map.function_group :ebs_database, {
      :children => {
          :ebs_database => {
              :en => {:name => "database", :description => "database"},
              :zh => {:name => "数据库", :description => "数据库"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "emw/databases" => ["index","new", "edit", "create", "update" ,"show","get_data"],
              "emw/database_items" => ["index","new", "edit", "create", "update" ,"show","get_data","destroy"]
          }
      }
  }
  #=================================END:DATABASE=================================

  #=================================START:COMPONENT=================================
  map.function_group :ebs_component, {
      :en => {:name => "component", :description => "component"},
      :zh => {:name => "应用组件", :description => "应用组件"}
  }
  map.function_group :ebs_component, {
      :zone_code => "EBS_MONITOR",
      :controller => "emw/components",
      :action => "index"
  }
  map.function_group :ebs_component, {
      :children => {
          :ebs_component => {
              :en => {:name => "component", :description => "component"},
              :zh => {:name => "应用组件", :description => "应用组件"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "emw/components" => ["index","new", "edit", "create", "update" ,"show","get_data"],
              "emw/component_items" => ["index","new", "edit", "create", "update" ,"show","get_data","destroy"]
          }
      }
  }
  #=================================END:COMPONENT=================================


end