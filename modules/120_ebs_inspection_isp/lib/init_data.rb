#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #====================================START:INSPECTION======================================
  map.menu :management_setting, {
      :children => {
          :ebs_inspection=>{
              :type => "menu",
              :entry => {
                  :sequence => 140,
                  :en => {:name => "EBS inspection", :description => "EBS inspection"},
                  :zh => {:name => "EBS巡检", :description => "EBS巡检"}
              }
          }
      }
  }
  #====================================END:INSPECTION======================================
  map.menu :ebs_inspection, {
      :en => {:name => "EBS inspection", :description => "EBS inspection"},
      :zh => {:name => "EBS巡检", :description => "EBS巡检"},
      :children => {
          :programs => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Inspection Programs", :description => "Inspection Programs"},
                  :zh => {:name => "巡检方案", :description => "巡检方案"}
              }
          },
          :check_items => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Inspection Items", :description => "Inspection Items"},
                  :zh => {:name => "巡检项", :description => "巡检项"}
              }
          }
      }
  }
  #====================================START:PROGRAMS======================================
  map.function_group :programs, {
      :en => {:name => "Inspection Programs", :description => "Inspection Programs"},
      :zh => {:name => "巡检方案", :description => "巡检方案"}
  }
  map.function_group :programs, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "isp/programs",
      :action => "index"
  }
  map.function_group :programs, {
      :children => {
          :programs => {
              :en => {:name => "Inspection Programs", :description => "Inspection Programs"},
              :zh => {:name => "巡检方案", :description => "巡检方案"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "isp/programs" => ["index", "show", "new", "create","edit","update","multilingual_edit", "multilingual_update",
                                 "get_data","new_execute","create_execute", "new_trigger", "create_trigger"],
              "isp/connections" => ["show", "new", "create","edit","update", "get_data","destroy", "add_items", "save_items", "get_items_data", "remove_item"],
              "isp/check_templates" => ["show", "new", "create","edit","update", "get_data","destroy"]
          }
      }
  }
  #====================================END:PROGRAMS======================================

  #====================================START:CHECKITEMS======================================
  map.function_group :check_items, {
      :en => {:name => "Inspection Items", :description => "Inspection Items"},
      :zh => {:name => "巡检项", :description => "巡检项"}
  }
  map.function_group :check_items, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "isp/check_items",
      :action => "index"
  }
  map.function_group :check_items, {
      :children => {
          :check_items => {
              :en => {:name => "Inspection Items", :description => "Inspection Items"},
              :zh => {:name => "巡检项", :description => "巡检项"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "isp/check_items" => ["index","show", "new", "create","edit","update", "get_data","destroy"],
              "isp/check_parameters" => ["show", "new", "create","edit","update", "get_data","destroy"],
              "isp/alert_filters" => ["show", "new", "create","edit","update", "get_data","destroy","get_operator_data"]
          }
      }
  }
  #====================================END:PROGRAMS======================================
end