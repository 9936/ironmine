#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #登录访问
  map.function_group :home_page, {
      :children => {
          :login_function => {
              "win/order_bases" => ["index"],
              "win/order_bases" => ["import"],
              "win/order_bases" => ["get_data"],
          }
      }
  }

end