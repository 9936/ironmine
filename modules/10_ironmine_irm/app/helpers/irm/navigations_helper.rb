# -*- coding: utf-8 -*-
module Irm::NavigationsHelper

  def sub_entries(menu_id)
    Irm::MenuManager.sub_entries_by_menu(menu_id)
  end

  def menu_by_code(menu_code)
    Irm::MenuManager.menus[menu_code]
  end

  # 生成二级菜单
  def render_tabs(selected_tab=true)
    return unless Irm::Application.current
    tabs  = Irm::Application.current.ordered_tabs
    return nil unless tabs&&tabs.any?

    tds = ""

    tabs.each do |tab|
      next unless Irm::PermissionChecker.allow_to_url?({:controller=>tab[:controller],:action=>tab[:action]})
      style = ""
      style = "currentTab" if selected_tab&&Irm::FunctionGroup.current&&tab.function_group_id.eql?(Irm::FunctionGroup.current.id)
      tds << content_tag(:td,content_tag(:div,link_to(tab[:name],{:controller=>tab[:controller],:action=>tab[:action]},{:title=>tab[:description]})),{:class=>style,:nowrap=>"nowrap"})
    end
    tds.html_safe

  end


    # 生成二级菜单
  def render_bootstrap_tabs(selected_tab=true)
    return unless Irm::Application.current
    tabs  = Irm::Application.current.ordered_tabs
    return nil unless tabs&&tabs.any?

    tds = ""

    tabs.each do |tab|
      next unless Irm::PermissionChecker.allow_to_url?({:controller=>tab[:controller],:action=>tab[:action]})
      style = ""
      style = "current-tab" if selected_tab&&Irm::FunctionGroup.current&&tab.function_group_id.eql?(Irm::FunctionGroup.current.id)
      tds << content_tag(:td,content_tag(:div,link_to(tab[:name],{:controller=>tab[:controller],:action=>tab[:action]},{:title=>tab[:description]})),{:class=>style,:nowrap=>"nowrap"})
    end
    tds.html_safe

  end

  def function_nav(menu_code)
    render :partial=>"irm/navigations/function_nav",:locals=>{:menu_code=>menu_code}
  end


end
