module Irm::HomeHelper
  def my_task_entries
    values = []
    Ironmine::Acts::Task::Helper.task_entries.each do |te|
      values << [Irm::BusinessObject.class_name_to_meaning(te),te]
    end
    values
  end

  def portlets_json
    json_hash = {}
    Irm::Portlet.multilingual.each do |p|
      json_hash.merge!({"m#{p.id}"=>{"t"=>p[:name],"url"=>url_for(p.url_options.merge({:wmode=>"portlet"}))}})
    end
    json_hash.to_json.html_safe
  end

  def portlets_config
    portle_config = Irm::PortletConfig.personal_config(Irm::Person.current.id)
    if(portle_config.present?&&portle_config[:config].present?)
      portle_config[:config]
    else
      portlets_str = Irm::Portlet.default.collect{|p| "'m#{p.id}:c1'"}.join(",")
      "{t1:[#{portlets_str}]}"
    end
  end

  def portlets_layout

  end

end
