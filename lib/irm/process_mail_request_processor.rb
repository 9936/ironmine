module Irm
  class ProcessMailRequestProcessor < Irm::MailManager::Processor
    def perform(email,parsed_email)
      people  = Irm::Person.unscoped.where(:email_address=>email.from_addrs.to_a.first).enabled

      return false unless people.any?
      # get the parsed email
      # use the plain mail message content
      return false unless parsed_email[:bodies].size>0

      if email.to.present? #&& parsed_email[:action_type] && parsed_email[:action_type].eql?("REQUEST")
        people.each do |person|
          Irm::Person.current = person
          Irm::OperationUnit.current = Irm::OperationUnit.find(person.opu_id)
          rules = Icm::MailRequest.where("username = ? AND opu_id = ?", email.to, person.opu_id).enabled

          #如果在不同opu下搜索出同一个email的person，则返回失败
          return false unless rules.size == 1
          rule = rules.first

          sys = Irm::ExternalSystem.find(rule.external_system_id)
          return false unless Irm::Person.current.external_systems.include?(sys)

          incident_request = Icm::IncidentRequest.new()
          content = parsed_email[:bodies][0]
          return false unless content.size > 0
          incident_request.summary =content
          prepared_for_create(incident_request, rule, email)

          Irm::Person.current = nil
          if incident_request.save
            #如果没有填写support_group, 插入Delay Job任务
            if incident_request.support_group_id.nil? || incident_request.support_group_id.blank?
              Delayed::Job.enqueue(Irm::Jobs::IcmGroupAssignmentJob.new(incident_request.id),
                                   [{:bo_code => "ICM_INCIDENT_REQUESTS", :instance_id => incident_request.id}])
            end
            return true
          else
            return false
          end
        end
      else
        false
      end
    rescue
      false
    end

    def prepared_for_create(incident_request, rule, email)
      incident_request.external_system_id = rule.external_system_id
#      incident_request.service_code = rule.service_code
      incident_request.incident_category_id = rule.incident_category_id if rule.incident_category_id.present?
      incident_request.incident_sub_category_id = rule.incident_sub_category_id if rule.incident_sub_category_id.present?
      incident_request.support_group_id = rule.support_group_id if rule.support_group_id.present?
      incident_request.support_person_id = rule.support_person_id if rule.support_person_id.present?
      incident_request.title = email.subject
      incident_request.impact_range_id = rule.impact_range_id if rule.impact_range_id.present?
      incident_request.urgence_id = rule.urgency_id if rule.urgency_id.present?
      incident_request.request_type_code = rule.request_type_code if rule.request_type_code.present?
      incident_request.report_source_code = rule.report_source_code if rule.report_source_code.present?
      incident_request.incident_status_id = rule.incident_status_id if rule.incident_status_id.present?

      incident_request.submitted_by = Irm::Person.current.id
      incident_request.requested_by = Irm::Person.current.id
      incident_request.contact_id = Irm::Person.current.id
      incident_request.contact_number = Irm::Person.current.bussiness_phone

      incident_request.submitted_date = email.date
      incident_request.last_request_date = email.date
      incident_request.last_response_date = 1.minute.ago
      incident_request.next_reply_user_license="SUPPORTER"
      if incident_request.incident_status_id.nil?||incident_request.incident_status_id.blank?
        incident_request.incident_status_id = Icm::IncidentStatus.default_id
      end
      if incident_request.request_type_code.nil?||incident_request.request_type_code.blank?
        incident_request.request_type_code = "REQUESTED_TO_CHANGE"
      end

      if incident_request.report_source_code.nil?||incident_request.report_source_code.blank?
        incident_request.report_source_code = "MAIL_SUBMIT"
      end
      if incident_request.requested_by.present?
        incident_request.contact_id = incident_request.requested_by
      end

      if !incident_request.contact_number.present?&&incident_request.contact_id.present?
        incident_request.contact_number = Irm::Person.find(incident_request.contact_id).bussiness_phone
      end

      incident_request.summary = "<pre>"+incident_request.summary+"</pre>"
    end
  end
end