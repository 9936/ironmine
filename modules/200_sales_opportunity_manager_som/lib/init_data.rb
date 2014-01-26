#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:Sales=================================
  map.function_group :sales_opportunity, {
      :en => {:name => "Sales Opportunity", :description => "Sales Opportunity"},
      :zh => {:name => "销售信息", :description => "销售信息"}
  }
  map.function_group :sales_opportunity, {
      :zone_code => "SALES",
      :controller => "som/sales_opportunities",
      :action => "index"}
  map.function_group :sales_opportunity, {
      :children => {
          :sales_opportunity => {
              :en => {:name => "Sales Opportunity Management", :description => "Sales Opportunity Management"},
              :zh => {:name => "销售信息管理", :description => "销售信息管理"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "som/sales_opportunities" => ["edit_reason", "update_reason", "get_data", "index", "create", "new", "edit", "show", "update", "destroy"],
              "som/communicate_infos"=> ["get_data", "index", "create", "new", "edit", "show", "update", "destroy"]
          },
          :potential_customer => {
              :en => {:name => "Sales Customer Management", :description => "Sales Customer Management"},
              :zh => {:name => "销售客户管理", :description => "销售客户管理"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "som/potential_customers" => ["get_data", "new_modal", "create_modal", "get_options", "index", "create", "new", "edit", "show", "update", "destroy"]
          },
          :send_setting => {
              :en => {:name => "Send Setting", :description => "Send Setting"},
              :zh => {:name => "定时发送设置", :description => "定时发送设置"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "som/send_summaries" => ["new", "create"]
          }
      }
  }
  #=================================END:Sales=================================
end