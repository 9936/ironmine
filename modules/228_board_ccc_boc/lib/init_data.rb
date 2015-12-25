#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  map.function_group :boc_board, {
                                   :en => {:name => "Board", :description => "Board"},
                                   :zh => {:name => "Board", :description => "Board"}
                               }
  map.function_group :boc_board, {
                                   :zone_code => "BOARD",
                                   :controller => "boc/boards",
                                   :action => "index"}
  map.function_group :boc_board, {
                                   :children => {
                                       :boa_boards => {
                                           :en => {:name => "Board", :description => "Board"},
                                           :zh => {:name => "Board", :description => "Board"},
                                           :default_flag => "N",
                                           :login_flag => "N",
                                           :public_flag => "N",
                                           "boc/boards" => ["index"]
                                       }
                                   }
                               }
end