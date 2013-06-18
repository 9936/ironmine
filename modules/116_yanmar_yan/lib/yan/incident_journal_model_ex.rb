module Yan::IncidentJournalModelEx
  def self.included(base)
    base.class_eval do
      after_create :write_system_id
      #回写回复数量到事故单中，方便统计
      def write_system_id
        self.update_attribute(:external_system_id, self.incident_request.external_system_id)
      end
    end
  end
end