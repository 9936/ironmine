class Icm::IncidentJournalElapse < ActiveRecord::Base
  set_table_name :icm_incident_journal_elapses

  query_extend

  validates_presence_of :start_at,:end_at

  before_save :calculate_distance

  private
  def calculate_distance
     self.distance = self.end_at.to_i - self.start_at.to_i
     self.real_distance = self.distance
  end
end
