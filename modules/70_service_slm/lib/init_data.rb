#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #====================================START:SERVICE_MANAGEMENT======================================
  map.menu :service_management, {
      :en => {:name => "Service Management", :description => "Service Management"},
      :zh => {:name => "服务管理", :description => "服务管理"},
      :children => {
          :service_category => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Category", :description => "Category"},
                  :zh => {:name => "服务类别", :description => "定义运维服务类别"},
              }},
          :service_catalog => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Catalog", :description => "Catalog"},
                  :zh => {:name => "服务目录", :description => "定义运维服务目录"},
              }},
          :service_agreement => {
              :type => "function",
              :entry => {
                  :sequence => 30,
                  :en => {:name => "Argeement", :description => "Argeement"},
                  :zh => {:name => "服务协议", :description => "定义服务协议（SLA）"},
              }},
      }
  }
  #====================================END:SERVICE_MANAGEMENT======================================


  #=================================START:SERVICE_CATEGORY=================================
  map.function_group :service_category, {
      :en => {:name => "Category", :description => "Category"},
      :zh => {:name => "服务类别", :description => "定义运维服务类别"}, }
  map.function_group :service_category, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "slm/service_categories",
      :action => "index"}
  map.function_group :service_category, {
      :children => {
          :service_category => {
              :en => {:name => "Manage Category", :description => "Manage Category"},
              :zh => {:name => "管理服务类别", :description => "管理服务类别"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "slm/service_categories" => ["create", "edit", "get_data", "index", "new", "show", "update"],
          },
      }
  }
  #=================================END:SERVICE_CATEGORY=================================

  #=================================START:SERVICE_CATALOG=================================
  map.function_group :service_catalog, {
      :en => {:name => "Catalog", :description => "Catalog"},
      :zh => {:name => "服务目录", :description => "定义运维服务目录"}, }
  map.function_group :service_catalog, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "slm/service_catalogs",
      :action => "index"}
  map.function_group :service_catalog, {
      :children => {
          :service_catalog => {
              :en => {:name => "Manage Catalog", :description => "Manage Catalog"},
              :zh => {:name => "管理服务目录", :description => "管理服务目录"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "slm/service_breaks" => ["create", "edit", "new", "update"],
              "slm/service_catalogs" => ["create", "edit", "get_data", "index", "new", "show", "update"],
              "slm/service_members" => ["create", "edit", "new", "update"],
          },
      }
  }
  #=================================END:SERVICE_CATALOG=================================

  #=================================START:SERVICE_AGREEMENT=================================
  map.function_group :service_agreement, {
      :en => {:name => "Argeement", :description => "Argeement"},
      :zh => {:name => "服务协议", :description => "定义服务协议（SLA）"}, }
  map.function_group :service_agreement, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "slm/service_agreements",
      :action => "index"}
  map.function_group :service_agreement, {
      :children => {
          :service_agreement => {
              :en => {:name => "Manage Argeement", :description => "Manage Argeement"},
              :zh => {:name => "管理服务协议", :description => "管理服务协议"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "slm/service_agreements" => ["create", "edit", "get_data", "index", "new", "show", "update"],
          },
      }
  }
  #=================================END:SERVICE_AGREEMENT=================================
end