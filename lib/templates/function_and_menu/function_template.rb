# -*- coding: utf-8 -*-
#======================================START FUNCTION GROUPS======================================

Fwk::MenuAndFunctionManager.map do |map|
<% function_groups.each do |group| -%>
  #=================================START:<%= group[:code]%>=================================
  map.function_group :<%= group[:code].downcase %>, {<% group.function_groups_tls.each do |language| -%><%= "\n" %>:<%=language[:language] %>=>{:name=>"<%= language[:name] %>", :description=>"<%= language[:description] %>"},<% end -%>}
  map.function_group :<%= group[:code].downcase %>, {<%= "\n" %>:zone_code=>"<%= group[:zone_code]%>",<%= "\n" %>:controller=>"<%= group[:controller]%>", <%= "\n" %>:action=>"<%= group[:action]%>"}
  map.function_group :<%= group[:code].downcase %>, {
      :children => {
        <% group.functions.each do |function|-%>
          :<%= function[:code].downcase %> => {
             <%function.functions_tls.each do |language|-%>
              :<%= language[:language]%>=>{:name=>"<%= language[:name]%>", :description=>"<%= language[:description]%>"},
             <% end -%>
              :default_flag =>"<%= function[:default_flag] %>",
              :login_flag => "<%= function[:login_flag] %>",
              :public_flag =>"<%= function[:public_flag] %>",
             <% permissions = Irm::Permission.where(:function_id => function.id) -%>
             <% controllers = {} -%>
             <% permissions.each do |permission| -%>
               <% controllers[permission[:controller].to_sym] ||= [] -%>
               <% controllers[permission[:controller].to_sym] << permission[:action].to_s unless controllers[permission[:controller].to_sym].include?(permission[:action].to_s) -%>
             <% end -%>
             <% controllers.each do |k, v|-%>
              "<%= k%>" => <%= v %>,
             <% end -%>
          },
        <% end -%>
      }
  }
  #=================================END:<%= group[:code]%>=================================

<% end -%>
end

#======================================END FUNCTION GROUPS======================================
