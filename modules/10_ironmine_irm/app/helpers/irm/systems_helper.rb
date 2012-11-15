module Irm::SystemsHelper
  def current_system_menu
    return nil unless Irm::Person.current&&Irm::Person.current.profile
    return nil unless params[:sid]
    systems = Irm::Person.current.external_systems
    return nil unless systems.size>1
    system = ""

    system << <<-BEGIN_HEML
    <ul class="nav nav-pills  pull-right" style="text-align: left;">
      <li class="dropdown">
        <a href="#" data-toggle="dropdown" class="dropdown-toggle">#{current_system[:system_name]} <b class="caret"></b></a>
        <ul class="dropdown-menu" style="min-width:130px;right:0;left:auto;" >
          #{list_systems(systems)}
        </ul>
      </li>
    </ul>
    BEGIN_HEML

    system.html_safe
  end

  def system_setting
    link = content_tag(:li,link_to(t(:label_irm_common_system_setting),{:controller => "irm/systems", :action => "index", :sid => current_system[:id]}),{:class=>"menuItem"})
    link.html_safe
  end


  def current_system
    Irm::ExternalSystem.current_system
  end

  # 生成系统菜单
  def list_systems(systems)
    links = ""
    systems.each do |s|
      menu = Irm::MenuManager.sub_entries_by_menu(Irm::Menu.system_menu.id,true,s.id).first
      links << content_tag(:li,link_to(s[:system_name],menu[:url_options].merge({:controller=>menu[:controller],:action=>menu[:action],:mi=>menu[:menu_entry_id],:level=>1})),{}) if menu
      #links << content_tag(:li,link_to(s[:system_name],{:controller => "irm/systems", :action => "index", :sid => s.id}),{:class=>"menuItem"})
    end

    links.html_safe
  end

end
