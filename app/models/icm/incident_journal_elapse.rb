class Icm::IncidentJournalElapse < ActiveRecord::Base
  set_table_name :icm_incident_journal_elapses

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_presence_of :start_at,:end_at

  before_save :calculate_distance

  belongs_to :incident_journal

  private
  def calculate_distance
     self.distance = self.end_at.to_i - self.start_at.to_i
     self.real_distance = self.distance
  end
end
