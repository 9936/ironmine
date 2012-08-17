#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:EXTERNAL_LOINGID=================================
  map.function_group :external_loingid, {
      :en => {:name => "External LoginID", :description => "External LoginID"},
      :zh => {:name => "外部LoginID", :description => "外部LoginID"}, }
  map.function_group :external_loingid, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "uid/external_logins",
      :action => "index"}
  map.function_group :external_loingid, {
      :children => {
          :external_loingid => {
              :en => {:name => "Manage External LoginID", :description => "Manage External LoginID"},
              :zh => {:name => "管理外部LoginID", :description => "管理外部LoginID"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
          },
      }
  }
  #=================================END:EXTERNAL_LOINGID=================================

  #=================================START:LOGIN_MAPPING=================================
  map.function_group :login_mapping, {
      :en => {:name => "LoginID Mapping", :description => "LoginID Mapping"},
      :zh => {:name => "用户&外部用户映射", :description => "用户&外部用户映射"}, }
  map.function_group :login_mapping, {
      :zone_code => "SYSTEM_SETTING",
      :controller => "uid/login_mappings",
      :action => "index"}
  map.function_group :login_mapping, {
      :children => {
          :login_mapping => {
              :en => {:name => "Manage LoginID Mapping", :description => "Manage LoginID Mapping"},
              :zh => {:name => "管理用户&外部用户映射", :description => "管理用户&外部用户映射"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
          },
      }
  }
  #=================================END:LOGIN_MAPPING=================================
end