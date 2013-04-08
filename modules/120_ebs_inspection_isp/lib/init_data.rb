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
          }
      }
  }

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
              "isp/programs" => ["index", "show", "new", "create","edit","update","multilingual_edit", "multilingual_update", "get_data"],
              "isp/connections" => ["show", "new", "create","edit","update", "get_data","destroy"],
              "isp/check_parameters" => ["show", "new", "create","edit","update", "get_data","destroy"],
              "isp/check_items" => ["show", "new", "create","edit","update", "get_data","destroy"]
          }
      }
  }
end