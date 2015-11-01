module Yan::IncidentJournalModelEx
  def self.included(base)
    base.class_eval do
      has_one :incident_workloads, :foreign_key => "incident_journal_id"
      after_create :write_system_id
      validate :validate_workload_when_update, :on => :update

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

        #Check  workload
        unless self.replied_by.nil?
          pr = Irm::Person.find(self.replied_by)

          status = nil
          status_record = Icm::IncidentHistory.where("request_id = '#{self.incident_request_id}' AND property_key = 'incident_status_id'").order("created_at DESC").first
          if status_record.present?
            status = status_record.new_value
          end
          if (!self.workload_c.present? || !self.workload_t.present?) && pr.workload_flag.eql?("Y") && (status.eql?("000K00091nRTl3hfwbJuHg") || status.eql?("000K00091oEOpAuVx0QTVQ") || status.eql?("000K00091nRTl3hfuk332W"))
            self.errors.add(:workload_message, 'Workload can not be blank')
          end
          if (!self.people_count_c.present? || !self.people_count_t.present?) && pr.workload_flag.eql?("Y") && (status.eql?("000K00091nRTl3hfwbJuHg") || status.eql?("000K00091oEOpAuVx0QTVQ") || status.eql?("000K00091nRTl3hfuk332W"))
            self.errors.add(:workload_message, 'The number of Consultants/Technicians can not be blank')
          end
          # 只有填写了workload才会继续验证
          if self.workload_c.present? && self.workload_t.present?
            # 验证不能小于0
            if self.workload_c < 0 || self.workload_t < 0 || self.people_count_c < 0 || self.people_count_t < 0
              self.errors.add(:workload_message, 'Those value can not be smaller than 0')
            end

            # 验证 人员数和工时只能同时为0，或同时不为0
            if self.people_count_c == 0 && self.workload_c != 0
              self.errors.add(:workload_message, 'The number of Consultants should not be 0 when the Workload is not 0')
            end
            if self.people_count_c != 0 && self.workload_c == 0
              self.errors.add(:workload_message, 'The Workload should not be 0 when the number of Consultants is not 0')
            end
            if self.people_count_t == 0 && self.workload_t != 0
              self.errors.add(:workload_message, 'The number of Technicians should not be 0 when the Workload is not 0')
            end
            if self.people_count_t != 0 && self.workload_t == 0
              self.errors.add(:workload_message, 'The Workload should not be 0 when the number of Technicians is not 0')
            end

            # 找出当前支持人员所在当前状态的开始时间/历史记录里的上一次时间
            start_time = nil
            status_time_record = Icm::IncidentHistory.where("request_id = '#{self.incident_request_id}' AND property_key = 'incident_status_id'").order("created_at DESC").first
            supporter_time_record = Icm::IncidentHistory.where("request_id = '#{self.incident_request_id}' ").order("created_at DESC").first

            if supporter_time_record.present? && status_time_record.present?
              if supporter_time_record.created_at > status_time_record.created_at
                start_time=supporter_time_record.created_at
              else
                start_time=status_time_record.created_at
              end
            end
            time = ((Time.now - start_time)/60).to_i
            if self.workload_c > time || self.workload_t > time
              self.errors.add(:workload_message, "Workload should be smaller than #{time} minutes")
            end

          end

        end
      end

      def validate_workload_when_update
        cur_workload = Icm::IncidentWorkload.find_by_incident_journal_id(self.id)
        if !cur_workload.nil?
          if !self.workload_c.present? || !self.workload_t.present?
            self.errors.add(:workload_message, 'Workload can not be blank')
          end
          if !self.people_count_c.present? || !self.people_count_t.present?
            self.errors.add(:workload_message, 'The number of Consultants/Technicians can not be blank')
          end
          # 只有填写了workload才会继续验证
          if self.workload_c.present? && self.workload_t.present?
            # 验证不能小于0
            if self.workload_c < 0 || self.workload_t < 0 || self.people_count_c < 0 || self.people_count_t < 0
              self.errors.add(:workload_message, 'Those value can not be smaller than 0')
            end

            # 验证 人员数和工时只能同时为0，或同时不为0
            if self.people_count_c == 0 && self.workload_c != 0
              self.errors.add(:workload_message, 'The number of Consultants should not be 0 when the Workload is not 0')
            end
            if self.people_count_c != 0 && self.workload_c == 0
              self.errors.add(:workload_message, 'The Workload should not be 0 when the number of Consultants is not 0')
            end
            if self.people_count_t == 0 && self.workload_t != 0
              self.errors.add(:workload_message, 'The number of Technicians should not be 0 when the Workload is not 0')
            end
            if self.people_count_t != 0 && self.workload_t == 0
              self.errors.add(:workload_message, 'The Workload should not be 0 when the number of Technicians is not 0')
            end

            time = ((cur_workload.end_time - cur_workload.start_time)/60).to_i
            if self.workload_c > time || self.workload_t > time
              self.errors.add(:workload_message, "Workload should be smaller than #{time} minutes")
            end

          end
        end
      end



    end
  end
end