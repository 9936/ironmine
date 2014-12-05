module Ccc::IncidentJournalModelEx
  def self.included(base)
    base.class_eval do
      after_create :count_reply
      attr_accessor :keep_next_status
      #回写回复数量到事故单中，方便统计
      def count_reply
        ir = Icm::IncidentRequest.find(self.incident_request_id)
        count = ir.incident_journals.without_attribute_change_journal.enabled.size
        ir.update_attribute(:reply_count, count)
        count
      rescue
        -1
      end

      def generate_journal_number
        self.journal_number = Irm::Sequence.nextval(self.class.name)
      end
      private

      def validate_message_body
        return if self.reply_type == 'CLOSE'
        return if self.reply_type == 'REOPEN'
        return if self.reply_type == 'PASS'
        return if self.reply_type == 'STATUS'

        str = Irm::Sanitize.sanitize(self.message_body,'').strip
        if !str.present?||(str.length==1&&str.bytes.to_a.eql?([226, 128, 139]))
          self.errors.add(:message_body,I18n.t(:label_icm_incident_journal_message_body_not_blank))
        end

        #验证前后两条回复是否相同
        last_journal = Icm::IncidentJournal.
            where("incident_request_id = ?", self.incident_request_id).
            where("reply_type IN ('OTHER_REPLY', 'CUSTOMER_REPLY', 'SUPPORTER_REPLY')").
            order("created_at desc").first
        if last_journal.present?
          if self.message_body == last_journal.message_body && self.replied_by == last_journal.replied_by
            self.errors.add(:message_body,I18n.t(:label_icm_incident_journal_message_body_not_repeat))
          end
        end

        #Check if strict workload
          rq = Icm::IncidentRequest.find(self.incident_request_id)
          es = Irm::ExternalSystem.find(rq.external_system_id)
        unless self.replied_by.nil?
          pr = Irm::Person.find(self.replied_by)
          if es.strict_workload.eql?('Y') && !self.workload.present? && pr.email_address.end_with?("hand-china.com")
            self.errors.add(:message_body, 'Workload can not be blank')
          end
        end
      end
    end
  end
end