module Hli::IncidentJournalModelEx
  def self.included(base)
    base.class_eval do
      after_create :count_reply

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
      end
    end
  end
end