#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  map.function_group :boa_board, {
      :en => {:name => "Board", :description => "Board"},
      :zh => {:name => "Board", :description => "Board"}
  }
  map.function_group :boa_board, {
      :zone_code => "BOARD",
      :controller => "boa/boards",
      :action => "index"}
  map.function_group :boa_board, {
      :children => {
          :boa_boards => {
              :en => {:name => "Board", :description => "Board"},
              :zh => {:name => "Board", :description => "Board"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "boa/boards" => ["index"]
          }
      }
  }

end