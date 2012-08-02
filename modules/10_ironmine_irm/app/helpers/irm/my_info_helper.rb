module Irm::MyInfoHelper

  # generate application menu
  def current_application_menu
    return nil unless Irm::Person.current&&Irm::Person.current.profile
    applications = Irm::Person.current.profile.ordered_applications
    return nil unless applications.size>1
    application = ""

    application << <<-BEGIN_HEML
      <li class="dropdown">
        <a href="#" data-toggle="dropdown" class="dropdown-toggle">#{current_application_name} <b class="caret"></b></a>
        <ul class="dropdown-menu" >
          #{list_applications(applications)}
        </ul>
      </li>
    BEGIN_HEML

    application.html_safe

  end

  def current_application_name
    Irm::Application.multilingual.find(Irm::Application.current.id)[:name] if Irm::Application.current
  end

  # 生成一级菜单
  def list_applications(applications)
    links = ""
    applications.each do |a|
      next if Irm::Application.current&&a.id.eql?(Irm::Application.current.id)
      links << content_tag(:li,link_to(a[:name],{:controller=>"irm/navigations",:action=>"change_application",:application_id=>a.id}),{:class=>"menuItem"})
    end

    links.html_safe
  end

end