#-*- coding: utf-8 -*-
Fwk::ApiParamsManager.map do |map|
  map.controller "irm/api_people", {
      #获取知识列表
      :show => {
          :name => "查看用户接口",
          :description => "查看用户接口",
          :params => [
              {:name => :id, :classify => [:input, :output], :type => "String", :required => "Y", :description => "用户ID或登录名"},
              {:name => :login_name, :classify => [:output], :type => "String", :description => "用户登录名"},
              {:name => :first_name, :classify => [:output], :type => "String", :description => "用户名"},
              {:name => :full_name, :classify => [:output], :type => "String", :description => "全名"},
              {:name => :language_code, :classify => [:output], :type => "String", :description => "语言编码"},
              {:name => :time_zone, :classify => [:output], :type => "String", :description => "用户时区"}
          ]
      }
  }
end
