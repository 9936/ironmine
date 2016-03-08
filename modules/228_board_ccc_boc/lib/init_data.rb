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

  map.function_group :boc_board_second, {
                                   :en => {:name => "Board_Second", :description => "Board_Second"},
                                   :zh => {:name => "Board_Second", :description => "Board_Second"}
                               }
  map.function_group :boc_board_second, {
                                   :zone_code => "BOARD_SECOND",
                                   :controller => "boc/board_seconds",
                                   :action => "index"}
  map.function_group :boc_board_second, {
                                   :children => {
                                       :boc_board_seconds => {
                                           :en => {:name => "Board_Second", :description => "Board_Second"},
                                           :zh => {:name => "Board_Second", :description => "Board_Second"},
                                           :default_flag => "N",
                                           :login_flag => "N",
                                           :public_flag => "N",
                                           "boc/board_seconds" => ["index"]
                                       }
                                   }
                               }

  map.function_group :boc_board_third, {
                                          :en => {:name => "Board_Third", :description => "Board_Third"},
                                          :zh => {:name => "Board_Third", :description => "Board_Third"}
                                      }
  map.function_group :boc_board_third, {
                                          :zone_code => "BOARD_THIRD",
                                          :controller => "boc/board_thirds",
                                          :action => "index"}
  map.function_group :boc_board_third, {
                                          :children => {
                                              :boc_board_thirds => {
                                                  :en => {:name => "Board_Third", :description => "Board_Third"},
                                                  :zh => {:name => "Board_Third", :description => "Board_Third"},
                                                  :default_flag => "N",
                                                  :login_flag => "N",
                                                  :public_flag => "N",
                                                  "boc/board_thirds" => ["index"]
                                              }
                                          }
                                      }
end