class Icm::IncidentWorkCalendar < ActiveRecord::Base
  set_table_name :icm_incident_work_calendars

  def self.incident_work_calendar(external_system_id)
    self.where(:external_system_id => external_system_id).first||self.new(:external_system_id => external_system_id)
  end
end
