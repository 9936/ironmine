# -*- coding: utf-8 -*-
module Irm::MenusHelper
  def available_menus
    Irm::Menu.enabled.multilingual
  end

  def menu_tree_data
    menus = available_menus
    #menu_entries = Irm::MenuEntry.where("sub_menu_id !=?", '').count.index_by(&:sub_menu_id)
    data = {:root => []}
    menus.each do |menu|
      menu_entry = Irm::MenuEntry.where(:sub_menu_id => menu.id).first
      if menu_entry.present?
        data[menu_entry.menu_id.to_sym] ||= []
        data[menu_entry.menu_id.to_sym] << menu
      else
        data[:root] << menu
      end
    end
    ul_html = "<ul id='menu_tree' class='treeview-red'>"
    data[:root].each do |menu|
      ul_html << build_menu_tree(menu,data)
    end
    ul_html << "</ul>"
    raw ul_html
  end

  def build_menu_tree(menu, data)
    li_html = ''
    if data[menu.id.to_sym].present?
      li_html << "<li>
                    <span class='name' >#{menu[:name]}</span>
                    <span class='actions'>#{link_to(t(:edit),{:action => "edit", :id => menu[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span> |
                    <span class='actions'>#{link_to(t(:show),{:action => "show", :id => menu[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span>
                    <ul>"
      li_html << "<li><span class='actions add-child'>#{link_to(t(:new),{:action => "new", :parent_id => menu[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span></li>"
      data[menu.id.to_sym].each do |sub_menu|
        li_html << build_menu_tree(sub_menu, data)
      end
      li_html << "</ul></li>"
    else
      li_html << "<li>
                    <span class='name'>#{menu[:name]}</span>
                    <span class='actions'>#{link_to(t(:edit),{:action => "edit", :id => menu[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span> |
                    <span class='actions'>#{link_to(t(:show),{:action => "show", :id => menu[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span>"

      li_html << "<ul><li><span class='actions add-child'>#{link_to(t(:new),{:action => "new", :parent_id => menu[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span></li>"
      li_html << "</ul></li>"
    end
    li_html
  end

end