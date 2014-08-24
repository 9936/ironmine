#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  map.menu :board, {
      :en => {:name => "Board", :description => "Board"},
      :zh => {:name => "Board", :description => "Board"},
      :children => {
          :ndm_dev_phase_template => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Phase Templates", :description => "Phase Templates"},
                  :zh => {:name => "阶段模板", :description => "阶段模板"},
              }},
          :ndm_project => {
              :type => "function",
              :entry => {
                  :sequence => 20,
                  :en => {:name => "Projects", :description => "Projects"},
                  :zh => {:name => "开发项目", :description => "开发项目"},
              }}
      }
  }


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
          :dem_project => {
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