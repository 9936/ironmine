# -*- coding: utf-8 -*-
module Irm::SettingHelper
  def menu_entry_name(id)
    if(id)
      Irm::MenuEntry.multilingual_colmun.query(id).first[:name]
    end
  end


  # 生成设置一级菜单
  def setting_menu
    if Irm::Person.current.nil?
      return
    end
    menus = Irm::MenuManager.sub_entries_by_menu(Irm::Menu.root_menu.id)
    return nil unless menus&&menus.size>0
    links = ""
    menus.each do |m|
      links << content_tag(:div,link_to(m[:name],{:controller=>m[:controller],:action=>m[:action],:mi=>m[:menu_entry_id],:level=>1}),{:class=>"menuItem"})
    end

    links.html_safe
  end

  # 生成左侧菜单
  def sidebar_menu
    # 取得当前function_group对应的菜单层次
    menus = @setting_menus
    if (menus.nil?||menus.size<2)&&Irm::FunctionGroup.current
      menus = (Irm::MenuManager.function_group_menus[Irm::FunctionGroup.current.id]||[]).first
      menus = menus.dup
      menus << Irm::FunctionGroup.current.id
    end
    #如果菜单菜单中只有一个菜单则返回
    return nil unless menus.size>1

    parent_menu_id = menus[1]
    content = content_tag(:div, content_tag(:div, raw(content_tag(:img,"", {:width => 205, :height => 1, :title => "", :src => "/images/s.gif"}) + generate_sidebar_menu(parent_menu_id)), {:id => "AutoNumber5"}),{:id=>"MenuNavTree",:class=>"mTreeSelection"})
    script = %Q(
      GY.use("irm",function(Y){
        var current_menus = [#{menus.collect{|x| "'#{x}'"}.join(",")}];
        Y.irm.navTree("MenuNavTree",current_menus);
      });
    )
    (content+javascript_tag(script)).html_safe
  end

  # 递归生成子菜单
  def generate_sidebar_menu(menu_id,level=1)
    next_level = level+1
    entries = Irm::MenuManager.sub_entries_by_menu(menu_id)
    functions = ""
    if level == 1
      entries.each do |e|
        functions << content_tag(:div,content_tag(:h2,link_to(e[:name],{:controller=>e[:controller],:action=>e[:action],:mi=>e[:menu_entry_id],:level=>1},{:title=>e[:description], :class => "setupSection"})),{:class=>"setupNavtree"})
        if(e[:entry_type].eql?("MENU"))
          functions << content_tag(:div,generate_sidebar_menu(e[:menu_id],next_level),{:id=>"tree_#{e[:menu_id]}_child"})
        end
      end
    else
      entries.each do |e|
        if(e[:entry_type].eql?("MENU"))
            icon_link = link_to("",{},{:href=>"javascript:void(0)",:real=>"#{e[:menu_id]}",:class=>"NavIconLink NavTreeCol",:id=>"tree_#{e[:menu_id]}_icon"})
            font_link = link_to(e[:name],{:controller=>e[:controller],:action=>e[:action],:mi=>e[:menu_entry_id]},{:title=>e[:description],:class=>"setupFolder",:id=>"#{e[:menu_id]}_font"})
            child_div = content_tag(:div,generate_sidebar_menu(e[:menu_id],next_level),{:style=>"display:none;",:class=>"childContainer",:id=>"tree_#{e[:menu_id]}_child"})
            functions << content_tag(:div,icon_link+font_link+child_div,{:mi=>"#{e[:menu_id]}",:class=>"parent parent_#{level}",:id=>"#{e[:menu_id]}"})
        else
          function_group = Irm::MenuManager.function_groups[e[:function_group_id]]
          functions << content_tag(:div,link_to(e[:name],{:controller=>function_group[:controller],:action=>function_group[:action]}),{:class=>"setupLeaf",:ti=>e[:function_group_id],:mi=>e[:menu_entry_id]})
        end
      end
    end
    functions.html_safe
  end

  # 展开菜单下的 子项
  def generate_entries_table(menu_entry_id)
    menu_entry = Irm::MenuEntry.find(menu_entry_id)
    return nil unless menu_entry.sub_menu_id
    entries = Irm::MenuManager.sub_entries_by_menu(menu_entry.sub_menu_id)
    odd_index = (0..entries.length).reject{|i| i%2 ==1}
    content = ""
    odd_index.each do |i|
      tr = ""
      e = entries[i]
      tr << content_tag(:td,("• "+link_to(e[:description],{:controller=>e[:controller],:action=>e[:action],:mi=>e[:menu_entry_id]})).html_safe,{:width=>"50%"}) if e
      e = entries[i+1]
      tr << content_tag(:td,("• "+link_to(e[:description],{:controller=>e[:controller],:action=>e[:action],:mi=>e[:menu_entry_id]})).html_safe,{:width=>"50%"}) if e
      content << content_tag(:tr,tr.html_safe)
    end
    raw content

  end


  # 展开菜单子项
  def generate_entries_table_ext(entry)
    if(entry[:entry_type].eql?("MENU"))
       generate_entries_table(entry[:menu_entry_id])
    else
      tr = content_tag(:td,("•"+link_to(entry[:description],{:controller=>entry[:controller],:action=>entry[:action],:mi=>entry[:menu_entry_id]})).html_safe,{:width=>"50%"}) if entry
      content_tag(:tr,tr.html_safe).html_safe
    end
  end
end
