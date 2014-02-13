class Icm::IncidentJournalElapse < ActiveRecord::Base
  set_table_name :icm_incident_journal_elapses

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  validates_presence_of :start_at, :end_at

  before_save :calculate_distance

  belongs_to :incident_journal

  scope :by_system, lambda { |external_system_id|
    joins("JOIN #{Icm::IncidentJournal.table_name} ON #{Icm::IncidentJournal.table_name}.id = #{self.table_name}.incident_journal_id").
        joins("JOIN #{Icm::IncidentRequest.table_name} ON #{Icm::IncidentRequest.table_name}.id = #{Icm::IncidentJournal.table_name}.incident_request_id").
        where("#{Icm::IncidentRequest.table_name}.external_system_id = ?", external_system_id)
  }

  scope :by_request, lambda { |incident_request_id|
    joins("JOIN #{Icm::IncidentJournal.table_name} ON #{Icm::IncidentJournal.table_name}.id = #{self.table_name}.incident_journal_id").
        where("#{Icm::IncidentJournal.table_name}.incident_request_id = ?", incident_request_id)
  }

  def calculate_distance
    self.distance = self.end_at.to_i - self.start_at.to_i

    work_calendar = Icm::IncidentWorkCalendar.where(:external_system_id => self.incident_journal.incident_request.external_system_id).first
    if work_calendar.present?
      self.real_distance = work_calendar.working_time(self.start_at, self.end_at)*60
    else
      self.real_distance = self.distance
    end

  end


  def self.recalculate_distance_by_system(external_system_id)
    self.select("#{self.table_name}.*").by_system(external_system_id).each { |i|
      i.calculate_distance
      i.save
    }
  end

  ##为所有的事故单耗时添加support_person_id字段,重新计算
  def self.rebuild
    Icm::IncidentRequest.where("1=1").each do |incident_request|
      Icm::IncidentRequest.transaction do

        first_person_change_history = Icm::IncidentHistory.where(:request_id => incident_request.id, :property_key => "support_person_id").order(:created_at).first
        elapse_options = {:support_person_id => nil}
        elapse_options[:support_person_id] = first_person_change_history.old_value if first_person_change_history.present?&&first_person_change_history.old_value.present?
        self.select("#{self.table_name}.*").by_request(incident_request.id).order("#{self.table_name}.created_at").each do |incident_journal_elapse|

          support_person_change_history = incident_journal_elapse.incident_journal.incident_histories.detect { |i| i.property_key.eql?("support_person_id") }

          if support_person_change_history
            elapse_options.merge!({:support_person_id => support_person_change_history.old_value})
          end

          incident_journal_elapse.update_attributes(elapse_options) unless  incident_journal_elapse.support_person_id.present?
          incident_journal_elapse.calculate_distance unless  incident_journal_elapse.real_distance == incident_journal_elapse.distance

          if support_person_change_history
            elapse_options.merge!({:support_person_id => support_person_change_history.new_value})
          end
        end
      end
    end
  end
end
