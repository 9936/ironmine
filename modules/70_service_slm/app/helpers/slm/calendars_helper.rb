module Slm::CalendarsHelper
  #获取当前年所定义的所有班次
  def available_schedules(calendar)
    calendar.calendar_items.where("calendar_year=?", Time.now.year)
  end

end
