#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:SKM_WIKI=================================
  map.function_group :win_order_base, {
      :en => {:name => "Order Base", :description => "Order Base"},
      :zh => {:name => "Order Base", :description => "Order Base"}, }
  map.function_group :win_order_base, {
      :zone_code => "SYSTEM_CUSTOM",
      :controller => "win/order_bases",
      :action => "index"}
  map.function_group :win_order_base, {
      :children => {
          :order_base => {
              :en => {:name => "Order Base", :description => "Order Base"},
              :zh => {:name => "Order Base", :description => "Order Base"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "win/order_bases" => ["get_data", "index", "import"]
          }
      }
  }
  #=================================END:SKM_WIKI=================================

  #=================================START:SKM_WIKI=================================
  map.function_group :win_customer_order, {
      :en => {:name => "Customer Order", :description => "Customer Order"},
      :zh => {:name => "客户订单", :description => "客户订单"}, }
  map.function_group :win_customer_order, {
      :zone_code => "SYSTEM_CUSTOM",
      :controller => "win/customer_orders",
      :action => "index"}
  map.function_group :win_customer_order, {
      :children => {
          :customer_order => {
              :en => {:name => "Customer Order", :description => "Customer Order"},
              :zh => {:name => "客户订单", :description => "客户订单"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "win/customer_orders" => ["get_data", "index", "import"]
          }
      }
  }
  #=================================END:SKM_WIKI=================================

end