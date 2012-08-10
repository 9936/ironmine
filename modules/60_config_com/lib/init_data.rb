#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #====================================START:CONFIG_MANAGEMENT======================================
  map.menu :config_management, {
      :en => {:name => "Config Management", :description => "Config Management"},
      :zh => {:name => "配置管理", :description => "配置管理相关设置"},
      :children => {
          :config_item_status => {
              :type => "function",
              :entry => {
                  :sequence => 40,
                  :en => {:name => "Config Item Status", :description => "Config Item Status"},
                  :zh => {:name => "配置项状态", :description => "配置项状态"},
              }},
          :config_relation_type => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Config Relation Type", :description => "Config Relation Type"},
                  :zh => {:name => "配置项关系类型", :description => "配置项关系类型"},
              }},
          :config_class => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Config Class", :description => "Config Class"},
                  :zh => {:name => "配置项分类", :description => "配置项分类"},
              }},
      }
  }
  #====================================END:CONFIG_MANAGEMENT======================================

  #=================================START:CONFIG_ITEM_STATUS=================================
  map.function_group :config_item_status, {
      :en => {:name => "Config Item Status", :description => "Config Item Status"},
      :zh => {:name => "配置项状态", :description => "配置项状态"}, }
  map.function_group :config_item_status, {
      :zone_code => "CONFIG_MANAGEMENT",
      :controller => "com/config_item_statuses",
      :action => "index"}
  map.function_group :config_item_status, {
      :children => {
          :config_item_status => {
              :en => {:name => "Config Item Status", :description => "Config Item Status"},
              :zh => {:name => "配置项状态", :description => "配置项状态"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "com/config_item_statuses" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:CONFIG_ITEM_STATUS=================================

  #=================================START:CONFIG_RELATION_TYPE=================================
  map.function_group :config_relation_type, {
      :en => {:name => "Config Relation Type", :description => "Config Relation Type"},
      :zh => {:name => "配置项关系类型", :description => "配置项关系类型"}, }
  map.function_group :config_relation_type, {
      :zone_code => "CONFIG_MANAGEMENT",
      :controller => "com/config_relation_types",
      :action => "index"}
  map.function_group :config_relation_type, {
      :children => {
          :config_relation_type => {
              :en => {:name => "Config Relation Type", :description => "Config Relation Type"},
              :zh => {:name => "配置项关系类型", :description => "配置项关系类型"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "com/config_relation_members" => ["create", "destroy", "edit", "get_data", "index", "new", "show", "update"],
              "com/config_relation_types" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:CONFIG_RELATION_TYPE=================================

  #=================================START:CONFIG_CLASS=================================
  map.function_group :config_class, {
      :en => {:name => "Config Class", :description => "Config Class"},
      :zh => {:name => "配置项分类", :description => "配置项分类"}, }
  map.function_group :config_class, {
      :zone_code => "CONFIG_MANAGEMENT",
      :controller => "com/config_classes",
      :action => "index"}
  map.function_group :config_class, {
      :children => {
          :config_class => {
              :en => {:name => "Config Class", :description => "Config Class"},
              :zh => {:name => "配置项分类", :description => "配置项分类"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "com/config_attributes" => ["create", "edit", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
              "com/config_classes" => ["create", "edit", "get_class_tree", "get_data", "index", "multilingual_edit", "multilingual_update", "new", "show", "update"],
          },
      }
  }
  #=================================END:CONFIG_CLASS=================================

  #=================================START:CONFIG_ITEM=================================
  map.function_group :config_item, {
      :en => {:name => "Config Item", :description => "Config Item"},
      :zh => {:name => "配置项", :description => "配置项"}, }
  map.function_group :config_item, {
      :zone_code => "CONFIG_MANAGEMENT",
      :controller => "com/config_items",
      :action => "index"}
  map.function_group :config_item, {
      :children => {
          :config_item => {
              :en => {:name => "Config Item", :description => "Config Item"},
              :zh => {:name => "配置项", :description => "配置项"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "com/config_items" => ["index", "show", "destroy", "new", "get_dynamic_attributes", "create", "edit", "update", "get_data"],
              "com/config_item_relations" => ["index", "show", "destroy", "new", "create", "edit", "update", "get_data"],
          },
      }
  }
  #=================================END:CONFIG_ITEM=================================

end