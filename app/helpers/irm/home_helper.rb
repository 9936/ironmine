module Irm::HomeHelper
  def my_task_entries
    values = []
    Ironmine::Acts::Task::Helper.task_entries.each do |te|
      values << [Irm::BusinessObject.class_name_to_meaning(te),te]
    end
    values
  end

  def portal_configs(default_layout_id)


    # 取出所有的portlet，过滤掉当前用户没有权限访问的
    portlets=Array.new
    Irm::Portlet.multilingual.each do |p|
       if(Irm::PermissionChecker.allow_to_url?({:controller=>p[:controller],:action=>p[:action]}))
            portlets.push(p)
       end
    end

    # 取出所有的portlet,并转化为json
    json_hash = {}
    portlets.each do |p|
      json_hash.merge!({"m#{p.id}"=>{"t"=>p[:name],"url"=>url_for(p.url_options.merge({:wmode=>"portlet"}))}})
    end
    portlet_str = json_hash.to_json.html_safe

    # 取得当前用户的portlet config
    portlet_config_str = ""
    portle_config = Irm::PortletConfig.personal_config(Irm::Person.current.id).first
    if(portle_config.present?&&portle_config[:config].present?)
      portlet_config_str = portle_config[:config]
    else
      portlets_str = Irm::Portlet.default.collect{|p| "'m#{p.id}:c1'"}.join(",")
      portlet_config_str = "{t1:[#{portlets_str}]}"
    end

    # 了得当前用户的portal layout
    portal_layout = nil
    if default_layout_id.present?
      portal_layout = Irm::PortalLayout.where(:id=>default_layout_id).first
    elsif(portle_config.present?&&portle_config[:portal_layout_id].present?)
      portal_layout = Irm::PortalLayout.where(:id=>portle_config[:portal_layout_id]).first
    else
      portal_layout = Irm::PortalLayout.where(:default_flag=>Irm::Constant::SYS_YES).first
    end

    unless portal_layout.present?
      portal_layout = Irm::PortalLayout.new(:layout=>"1,2,1")
    end

    # 生成portal layout配置
    layouts  = []

    layout_index = 0
    portal_layout[:layout].split(",").each do |limit|
      1.upto(limit.to_i).each  do |index|
        if(index==limit.to_i)
          layouts << "c#{layout_index+1}:'span-#{24/limit.to_i} last'"
        else
          layouts << "c#{layout_index+1}:'span-#{24/limit.to_i}'"
        end
        layout_index = layout_index+1
      end
    end if portal_layout[:layout]
    portal_layout_json = "{_default:{bg:'normal',#{layouts.join(",")}}}"

    [portlets,portal_layout,portlet_str,portlet_config_str,portal_layout_json,layout_index]
  end

  #获取供选择的portal_layout
  def available_portal_layouts
    Irm::PortalLayout.multilingual.collect{|p|[p[:name],p[:id]]}
  end


end
