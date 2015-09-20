module Yan::IncidentJournalModelEx
  def self.included(base)
    base.class_eval do
      after_create :write_system_id

      def write_system_id
        self.update_attribute(:external_system_id, self.incident_request.external_system_id)
      end

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
        unless self.replied_by.nil?
          pr = Irm::Person.find(self.replied_by)
          status = Icm::IncidentHistory.where("request_id = '#{self.incident_request_id}' AND property_key = 'incident_status_id'").order("created_at DESC").first.new_value
          if (!self.workload_c.present? || !self.workload_t.present? || !self.people_count_c.present? || !self.people_count_t.present?) && pr.workload_flag.eql?("Y") && (status.eql?("000K00091nRTl3hfwbJuHg") || status.eql?("000K00091oEOpAuVx0QTVQ"))
            self.errors.add(:message_body, 'Workload can not be blank')
          end
          start_time = Icm::IncidentHistory.where("request_id = '#{self.incident_request_id}' AND property_key = 'support_person_id' AND new_value = '#{self.replied_by}'").order("created_at DESC").first.created_at
          if self.workload_c.present? && self.workload_t.present?
            time = ((Time.now - start_time)/3600).round(2)
            if self.workload_c > time || self.workload_c > time
              self.errors.add(:message_body, "Workload Should be less than #{time}")
            end
          end
        end
      end
    end
  end
end