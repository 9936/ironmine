module Slm::CalendarItemsHelper

  def available_calendar_types
    rule_types = []
    if has_main_rule?(params[:calendar_id])
      rule_types << [t(:label_slm_calendar_item_type_include),'INCLUDE']
      rule_types << [t(:label_slm_calendar_item_type_exclude), 'EXCLUDE']
    else
      rule_types << [t(:label_slm_calendar_item_type_all), 'ALL']
    end
    rule_types
  end

  def has_main_rule?(calendar_id)
    Slm::CalendarItem.with_calendar(calendar_id).where("relation_type=?", 'ALL').any?
  end

  def relation_type_meaning(type)
    case type
      when "INCLUDE"
        t(:label_slm_calendar_item_type_include)
      when "EXCLUDE"
        t(:label_slm_calendar_item_type_exclude)
      when "ALL"
        t(:label_slm_calendar_item_type_all)
      else
        ""
    end
  end

  def time_mode_obj_meaning(time_mode_obj)
    case time_mode_obj[:freq]
      when "DAILY"
        t(:label_irm_todo_event_recurrence_every_day, :m => time_mode_obj[:daily][:interval])
      when "WEEKLY"
        week_meaning = t(:label_irm_todo_event_recurrence_every_week, :m => time_mode_obj[:weekly][:interval])
        weeks = []
        time_mode_obj[:weekly][:days].each do |week_day|
          weeks << week_meaning(week_day)
        end
        "#{week_meaning} #{weeks}"
      when "MONTHLY"
        if time_mode_obj[:monthly][:type].eql?("DAY")
          t(:label_irm_todo_event_recurrence_day_of_every_month, :m => time_mode_obj[:monthly][:day][:interval], :n => time_mode_obj[:monthly][:day][:dayno])
        else
          t(:label_irm_todo_event_recurrence_weekday_of_every_month, :m => time_mode_obj[:monthly][:week][:interval], :n => time_mode_obj[:monthly][:week][:weekno]) + week_meaning(time_mode_obj[:monthly][:week][:weekday])
        end
      when "YEARLY"
        t(:label_irm_todo_event_recurrence_every_year, :m => time_mode_obj[:yearly][:interval])
    end

  end

  def week_meaning(week_day)
    week_label = ""
    case week_day
      when "MO"
        week_label = (t "date.day_names")[1]
      when "TU"
        week_label = (t "date.day_names")[2]
      when "WE"
        week_label = (t "date.day_names")[3]
      when "TH"
        week_label = (t "date.day_names")[4]
      when "FR"
        week_label = (t "date.day_names")[5]
      when "SA"
        week_label = (t "date.day_names")[6]
      when "SU"
        week_label = (t "date.day_names")[0]
      else
        ""
    end
    week_label
  end
end
