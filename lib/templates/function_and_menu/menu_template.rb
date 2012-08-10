#-*- coding: utf-8 -*-
#====================================START MENUS======================================
Fwk::MenuManager.map do |map|
 <% menus.each do |menu| -%>
  #====================================START:<%= menu[:code] %>======================================
  map.menu :<%= menu[:code].downcase%>, {
    <% menu.menus_tls.each do |language| -%>
      :<%= language[:language] %> => {:name => "<%= language[:name] %>", :description => "<%= language[:description] %>"},
    <% end -%>
    <% if menu.menu_entries.any? -%>
      :children => {
        <% menu.menu_entries.each do |entry| -%>
          <% if entry[:sub_menu_id].present? -%>
           <% type = 'menu' -%>
           <% sub = Irm::Menu.find(entry[:sub_menu_id]) -%>
          <% else -%>
           <% type = 'function' -%>
           <% sub = Irm::FunctionGroup.find(entry[:sub_function_group_id])-%>
          <% end -%>
          :<%=sub[:code].downcase %> => {
              :type => "<%= type %>",
              :entry => {
                  :sequence => <%= entry[:display_sequence] %>,
                <% entry.menu_entries_tls.each do |language| -%>
                  :<%= language[:language] %> => {:name => "<%= language[:name] %>", :description => "<%= language[:description] %>"},
                <% end -%>}},
        <% end -%>
      }
    <% end -%>
  }
  #====================================END:<%= menu[:code] %>======================================

 <% end -%>
end
#====================================END MENUS======================================
