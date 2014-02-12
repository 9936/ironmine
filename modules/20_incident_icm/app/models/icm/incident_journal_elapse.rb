class Icm::IncidentJournalElapse < ActiveRecord::Base
  set_table_name :icm_incident_journal_elapses

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_presence_of :start_at,:end_at

  before_save :calculate_distance

  belongs_to :incident_journal

  scope :by_system,lambda{|external_system_id|
     joins("JOIN #{Icm::IncidentJournal.table_name} ON #{Icm::IncidentJournal.table_name}.id = #{self.table_name}.incident_journal_id").
         joins("JOIN #{Icm::IncidentRequest.table_name} ON #{Icm::IncidentRequest.table_name}.id = #{Icm::IncidentJournal..table_name}.incident_request_id").
         where("#{Icm::IncidentRequest.table_name}.external_system_id = ?",external_system_id)
  }

  def calculate_distance
     self.distance = self.end_at.to_i - self.start_at.to_i

     work_calendar = Icm::IncidentWorkCalendar.where(:external_system_id=>self.incident_journal.incident_request.external_system_id).first
     if work_calendar.present?
       self.real_distance = work_calendar.work_time(self.start_at,self.end_at)
     else
       self.real_distance = self.distance
     end

  end


  def self.recalculate_distance_by_system(external_system_id)
    self.by_system(external_system_id).each{|i| i.calculate_distance}
  end
end
