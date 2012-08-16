module Hli::IncidentHistoryModelEx
  def self.included(base)
    base.class_eval do
      scope :select_all, lambda{
        select("#{table_name}.*")
      }
      scope :with_request, lambda{|request_id|
          joins(",#{Icm::IncidentJournal.table_name} ij").
          where("ij.id = #{table_name}.journal_id").
          where("ij.reply_type IN ('PASS', 'ASSIGN', 'UPGRADE')").
          where("#{table_name}.property_key IN ('support_person_id','support_group_id','incident_status_id','close_reason_id')").
          where("ij.incident_request_id = ?", request_id)
      }

      scope :only_with_request, lambda{|request_id|
          where("#{table_name}.request_id = ?", request_id)
      }

      scope :with_created_by, lambda{
        select("ip.full_name created_by_full_name").
            joins(",#{Irm::Person.table_name} ip").
            where("ip.id = #{table_name}.created_by")
      }

      scope :with_value_label, lambda{
        select("'' new_value_label, '' old_value_label")
      }

      scope :order_by_created_at, lambda{
        order("#{table_name}.created_at ASC")
      }

      scope :without_some_property_key, lambda{
        where("#{table_name}.property_key NOT IN (?)", ['charge_group_id', 'upgrade_person_id', 'upgrade_group_id', 'charge_person_id'])
      }

      def meaning
        return @history_meaning if @history_meaning
        title = I18n.t(("label_icm_incident_request_" + self.property_key.gsub(/\_id$/, "")).to_sym)
        old_meaning = nil
        new_meaning = nil
        old_meaning = I18n.t(:null_string) if self.old_value.nil?||self.old_value.blank?
        new_meaning = I18n.t(:null_string) if self.new_value.nil?||self.new_value.blank?
        case self.property_key
          when "support_person_id"
            if old_meaning.nil?
              real_value = Irm::Person.query_person_name(self.old_value).first
              old_meaning = real_value[:person_name] if real_value
            end
            if new_meaning.nil?
              real_value = Irm::Person.query_person_name(self.new_value).first
              new_meaning = real_value[:person_name] if real_value
            end
          when "support_group_id"
            if old_meaning.nil?
              real_value = Icm::SupportGroup.with_group(I18n.locale).query(self.old_value).first
              old_meaning = real_value[:name] if real_value
            end
            if new_meaning.nil?
              real_value = Icm::SupportGroup.with_group(I18n.locale).query(self.new_value).first
              new_meaning = real_value[:name] if real_value
            end
          when "incident_status_id"
            if old_meaning.nil?
              real_value = Icm::IncidentStatus.multilingual_colmun.query(self.old_value).first
              old_meaning = real_value[:name] if real_value
            end
            if new_meaning.nil?
              real_value = Icm::IncidentStatus.multilingual_colmun.query(self.new_value).first
              new_meaning = real_value[:name] if real_value
            end
          when "close_reason_id"
            if old_meaning.nil?
              real_value = Icm::CloseReason.multilingual_colmun.query(self.old_value).first
              old_meaning = real_value[:name] if real_value
            end
            if new_meaning.nil?
              real_value = Icm::CloseReason.multilingual_colmun.query(self.new_value).first
              new_meaning = real_value[:name] if real_value
            end
          when "new_reply" #回复
            old_meaning = ""
            new_meaning = new_value
          when "incident_request_id" #新建request
            old_meaning = ""
            begin
              new_meaning = self.old_value
            rescue
            end
          when "attachment" #附件
            old_meaning = ""
            new_meaning = self.old_value
          when "remove_attachment" #移除附件
            old_meaning = ""
            new_meaning = self.old_value
          when "hotline"
            old_meaning = self.old_value
            new_meaning = self.new_value
          when "real_processing_time" #解决问题实际耗时
            old_meaning = self.old_value
            new_meaning = self.new_value
          when "client_info" #客户端信息
            old_meaning = self.old_value
            new_meaning = self.new_value
          when "requested_by" #请求人
            if old_meaning.nil?
              real_value = Irm::Person.query_person_name(self.old_value).first
              old_meaning = real_value[:person_name] if real_value
            end
            if new_meaning.nil?
              real_value = Irm::Person.query_person_name(self.new_value).first
              new_meaning = real_value[:person_name] if real_value
            end
          when "submitted_by" #提交人
            if old_meaning.nil?
              real_value = Irm::Person.query_person_name(self.old_value).first
              old_meaning = real_value[:person_name] if real_value
            end
            if new_meaning.nil?
              real_value = Irm::Person.query_person_name(self.new_value).first
              new_meaning = real_value[:person_name] if real_value
            end
          when "contact_id" #联系人
            if old_meaning.nil?
              real_value = Irm::Person.query_person_name(self.old_value).first
              old_meaning = real_value[:person_name] if real_value
            end
            if new_meaning.nil?
              real_value = Irm::Person.query_person_name(self.new_value).first
              new_meaning = real_value[:person_name] if real_value
            end
          when "contact_number" #联系电话
            old_meaning = self.old_value
            new_meaning = self.new_value
          when "impact_range_id" #影响度
            if old_meaning.nil?
              real_value = Icm::ImpactRange.multilingual.query(self.old_value).first
              old_meaning = real_value[:name] if real_value
            end
            if new_meaning.nil?
              real_value = Icm::ImpactRange.multilingual.query(self.new_value).first
              new_meaning = real_value[:name] if real_value
            end
          when "urgence_id" #紧急度
            if old_meaning.nil?
              real_value = Icm::UrgenceCode.multilingual.query(self.old_value).first
              old_meaning = real_value[:name] if real_value
            end
            if new_meaning.nil?
              real_value = Icm::UrgenceCode.multilingual.query(self.new_value).first
              new_meaning = real_value[:name] if real_value
            end
          when "priority_id" #优先级
            if old_meaning.nil?
              real_value = Icm::PriorityCode.multilingual.query(self.old_value).first
              old_meaning = real_value[:name] if real_value
            end
            if new_meaning.nil?
              real_value = Icm::PriorityCode.multilingual.query(self.new_value).first
              new_meaning = real_value[:name] if real_value
            end
          when "title" #标题
            old_meaning = self.old_value
            new_meaning = self.new_value
          when "summary" #内容
            old_meaning = ""
            new_meaning = ""
          when "external_system_id" #应用系统
            if old_meaning.nil?
              real_value = Irm::ExternalSystem.multilingual.query(self.old_value).first
              old_meaning = real_value[:system_name] if real_value
            end
            if new_meaning.nil?
              real_value = Irm::ExternalSystem.multilingual.query(self.new_value).first
              new_meaning = real_value[:system_name] if real_value
            end
          when "incident_category_id"
            if old_meaning.nil?
              real_value = Icm::IncidentCategory.multilingual.query(self.old_value).first
              old_meaning = real_value[:name] if real_value
            end
            if new_meaning.nil?
              real_value = Icm::IncidentCategory.multilingual.query(self.new_value).first
              new_meaning = real_value[:name] if real_value
            end
          when "incident_sub_category_id"
            if old_meaning.nil?
              real_value = Icm::IncidentSubCategory.multilingual.query(self.old_value).first
              old_meaning = real_value[:name] if real_value
            end
            if new_meaning.nil?
              real_value = Icm::IncidentSubCategory.multilingual.query(self.new_value).first
              new_meaning = real_value[:name] if real_value
            end
          when "add_watcher"
            if old_meaning.nil?
              real_value = Irm::Person.query_person_name(self.old_value).first
              new_meaning = real_value[:person_name] if real_value
            end
          when "remove_watcher"
            if old_meaning.nil?
              real_value = Irm::Person.query_person_name(self.old_value).first
              old_meaning = real_value[:person_name] if real_value
            end
          when "add_relation"
            if old_meaning.nil?
              real_value = Irm::LookupValue.get_meaning("ICM_INCIDENT_REQUEST_REL_TYPE", self.old_value)
              old_meaning = real_value if real_value
            end
            if new_meaning.nil?
              real_value = Icm::IncidentRequest.query(self.new_value).first
              new_meaning = real_value[:request_number] + "#"+ real_value[:title] if real_value
            end
          when "remove_relation"
            if old_meaning.nil?
              real_value = Irm::LookupValue.get_meaning("ICM_INCIDENT_REQUEST_REL_TYPE", self.old_value)
              old_meaning = real_value if real_value
            end
            if new_meaning.nil?
              real_value = Icm::IncidentRequest.query(self.new_value).first
              new_meaning = real_value[:request_number] + "#"+ real_value[:title] if real_value
            end
          when "remove_journal"
            old_meaning = ""
            new_meaning = new_value
        end
        old_meaning = "" if old_meaning.nil?
        new_meaning = "" if new_meaning.nil?
        @history_meaning = {:title=>title,:new_meaning=>new_meaning,:old_meaning=>old_meaning}
        return @history_meaning
      end

      def to_s
        return nil unless ["support_person_id","support_group_id","incident_status_id","close_reason_id", "new_reply"].include?(self.property_key)
        "#{meaning[:title]}: #{meaning[:old_meaning]} ==> #{meaning[:new_meaning]}"
      end
    end
  end
end