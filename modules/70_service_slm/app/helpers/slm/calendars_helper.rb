module Slm::CalendarsHelper
  #获取当前年所定义的所有班次
  def available_schedules(calendar)
    puts "=============1111==============="
    calendar.calendar_items.where("calendar_year=?", Time.now.year).order("start_at ASC, end_at ASC")
    puts "==============2222====================================="
    []
  end

  def available_calendars(system_id)
    Slm::Calendar.where(:external_system_id=>system_id).multilingual.enabled.collect{|v| [v[:name],v.id]}
  end

end
