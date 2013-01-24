module Irm::ApplicationsHelper
  def application_tab_str(application)
    if(application.tabs_str.present?)
      return application.tabs_str
    end
    if(application.application_tabs.any?)
      return application.application_tabs.collect{|i| i.tab_id}.join(",")
    else
      return ""
    end
  end

  def application_default_tab_id(application)
    if(application.default_tab_id.present?)
      return application.default_tab_id
    end
    if(application.application_tabs.any?)
       tab = application.application_tabs.detect{|i| i.default_flag.eql?(Irm::Constant::SYS_YES)}
       if tab
         return tab.tab_id
       else
         return nil
       end
    else
      return nil
    end
  end


  def available_applications
    Irm::Application.multilingual.collect{|i| [i[:name],i.id]}
  end


  #清空日志时间段选择
  def available_time_period
    time_period = []
    #(1..6).each do |i|
    #  time_period << [t(:label_period_x_days_ago, :x => i), "#{i}day"]
    #end
    #(1..4).each do |i|
    #  time_period << [t(:label_period_x_weeks_ago, :x => i), "#{i}week"]
    #end
    (3..11).each do |i|
      time_period << [t(:label_period_x_months_ago, :x => i), "#{i}month"]
    end
    (1..2).each do |i|
      time_period << [t(:label_period_x_years_ago, :x => i), "#{i}year"]
    end
    #time_period << [t(:label_period_log_clear_all), 'ALL']
    time_period
  end

end
