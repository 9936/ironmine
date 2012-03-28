module Irm::MyInfoHelper

  # generate application menu
  def current_application_menu
    return nil unless Irm::Person.current&&Irm::Person.current.profile
    applications = Irm::Person.current.profile.ordered_applications
    return nil unless applications.size>1
    application = ""
    application_script = <<-BEGIN_SCRIPT
    <script type="text/javascript">
      $(document).ready(function(){
          $("#pageMenu").menubutton();
      });
    </script>
    BEGIN_SCRIPT
    application << application_script
    application << <<-BEGIN_HEML
      <span id="pageMenu" class="menu-parent" style="float:right;">
        <div class="menuLabel">
          <span tabindex="0" id="pageMenuTop" style="">#{current_application_name}</span>
          <div class="menuLabel-tr"></div>
          <div class="menuLabel-tl"></div>
          <div id="pageMenu-arrow"></div>
        </div>
         <div class="menu-content" style="padding:10px 15px;padding:0\\9;">
         <div class="tsidMenu-tr"></div>
         <div class="tsidMenu-tl"></div>
         <div class="tsidMenu-tc"></div>
         <div style="display:block;" class="menuItems">
          #{list_applications(applications)}
         </div>
         <div class="tsidMenu-br"></div><div class="tsidMenu-bl"></div><div class="tsidMenu-bc"></div></div>
        </div>
      </span>
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
      links << content_tag(:span,link_to(a[:name],{:controller=>"irm/navigations",:action=>"change_application",:application_id=>a.id}),{:class=>"menuItem"})
    end

    links.html_safe
  end

end