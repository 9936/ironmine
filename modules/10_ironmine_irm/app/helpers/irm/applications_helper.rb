module Irm::ApplicationsHelper
  def application_tab_str(application)
    if(application.tabs_str.present?)
      return application.tabs_str
    end
    if(application.application_tabs.length > 0)
      return application.application_tabs.collect{|i| i.tab_id}.join(",")
    else
      return ""
    end
  end


  def application_default_tab_id(application)
    if application.default_tab_id.present?
      return application.default_tab_id
    end

    if application.application_tabs.length > 0
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

  #将任务的重复规则转变为文字含义
  def week_to_num
    {"MO" => 1, "TU" => 2, "WE" => 3, "TH" => 4, "FR" => 5, "SA" => 6, "SU" => 0}
  end
  def rule_meaning(task)
    rule_hash = task.to_rrule_hash
    meaning = ""
    rule_hash[:interval] ||= 1
    if rule_hash[:interval] && rule_hash[:interval]> 0
      case rule_hash[:freq]
        when "DAILY"
          meaning << t(:label_rule_n_daily, :n => rule_hash[:interval])

        when "WEEKLY"
          meaning << t(:label_rule_n_weekly, :n => rule_hash[:interval])
          rule_hash[:byday].each do |week_day|
            meaning << t("date.day_names")[week_to_num[week_day]]
            meaning << ","
          end
        when "MONTHLY"
          meaning << t(:label_rule_n_monthly, :n => rule_hash[:interval])
          if rule_hash[:bysetpos].present? && rule_hash[:bysetpos] > 0
            meaning << t(:label_n_setpos, :n => rule_hash[:bysetpos])
            meaning << t("date.day_names")[week_to_num[rule_hash[:byday]]]
          elsif rule_hash[:bymonthday].present?
            meaning << t(:label_n_monthday, :n => rule_hash[:bymonthday][0])
          end
      end
    end
    meaning
  end

end
