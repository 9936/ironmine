module Irm::SystemsHelper
  def current_system_menu
    return nil unless Irm::Person.current&&Irm::Person.current.profile
    systems = Irm::Person.current.external_systems
    return nil unless systems.size>1
    system = ""

    system << <<-BEGIN_HEML
      <li class="dropdown">
        <a href="#" data-toggle="dropdown" class="dropdown-toggle">#{current_system[:system_name]} <b class="caret"></b></a>
        <ul class="dropdown-menu" style="min-width:130px;right:0;left:auto;" >
          #{list_systems(systems)}
        </ul>
      </li>
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
    puts "#{systems.to_json}"
    links = ""
    systems.each do |s|
      links << content_tag(:li,link_to(s[:system_name],{:controller => "irm/systems", :action => "index", :sid => s.id}),{:class=>"menuItem"})
    end

    links.html_safe
  end

end
