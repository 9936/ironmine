class Icm::IncidentWorkCalendar < ActiveRecord::Base
  set_table_name :icm_incident_work_calendars

  def self.incident_work_calendar(external_system_id)
    self.where(:external_system_id => external_system_id).first||self.new(:external_system_id => external_system_id)
  end

  #计算两个时间的间隔
  def working_time(start_time,end_time)
    calendar = Slm::Calendar.find(self.id)
    time_zone = self.time_zone
    calendar.working_time_with_zone(time_zone,start_time,end_time)
  end

end
