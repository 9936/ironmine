#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  map.function_group :imp_ui, {
      :en => {:name => "Import", :description => "Import"},
      :zh => {:name => "Import", :description => "Import"}
  }
  map.function_group :imp_ui, {
      :zone_code => "IMPORT",
      :controller => "imp/imports",
      :action => "index"}
  map.function_group :imp_ui, {
      :children => {
          :boa_boards => {
              :en => {:name => "Import", :description => "Import"},
              :zh => {:name => "Import", :description => "Import"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "imp/imports" => ["index"]
          }
      }
  }

end