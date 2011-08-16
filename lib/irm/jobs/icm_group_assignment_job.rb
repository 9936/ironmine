module Irm
  module Jobs
    class IcmGroupAssignmentJob < Struct.new(:incident_request_id,:assign_options)
      include ActionController::UrlWriter
      def perform
        request = Icm::IncidentRequest.find(incident_request_id)
        return if request.support_group_id.present?&&request.support_person_id.present?
        assign_result =  assign_options if  assign_options&&assign_options.is_a?(Hash)
        assign_result ||= {}
        person = Irm::Person.find(request.requested_by)
        unless request.support_group_id.present?||assign_result[:support_group_id].present?
          assign_result[:support_person_id] = nil
          Irm::SupportGroup.where(:oncall_group_flag => Irm::Constant::SYS_YES).each do |ga|
            #按服务查找
            r1 = ga.group_assignments.query_service_catalog(request.service_code).where(:source_type => Slm::ServiceCatalog.name)
            #按系统查找
            unless r1.any?
              r1 = ga.group_assignments.query_external_system(request.external_system_code).where(:source_type => Uid::ExternalSystem.name)
            end

            #按人员查找
            unless r1.any?
              r1 = ga.group_assignments.where(:source_type => Irm::Person.name, :source_id => person.id)
            end

            #按部门查找
            unless r1.any?
              r1 = ga.group_assignments.where(:source_type => Irm::Department.name, :source_id => person.department_id)
            end

            #按组织查找
            unless r1.any?
              r1 = ga.group_assignments.where(:source_type => Irm::Organization.name, :source_id => person.organization_id)
            end

            #按公司查找
            unless r1.any?
              r1 = ga.group_assignments.where(:source_type => Irm::Company.name, :source_id => person.company_id)
            end
            if r1.any?
              support_group = Irm::SupportGroup.where("group_code = ?", r1.first.support_group.group_code).first
              assign_result[:support_group_id] = support_group.id if support_group
            end
          end
        end

        if assign_result[:support_group_id].present?
          support_group = Irm::SupportGroup.where("id = ?", assign_result[:support_group_id]).first
          unless assign_result[:support_person_id].present?
            assign_result.merge!(setup_support_person(support_group,request))
          end
        else
          assign_result.merge!(setup_default_person(request))
        end
        #get the support information
        #generate incident journal
        if assign_result[:support_group_id].present?&&assign_result[:support_person_id].present?
          ActiveRecord::Base.transaction do
            generate_journal(request,assign_result)
          end
        end
      end
      # get the person in the support group
      def setup_support_person(support_group,request)
        assign_result ={}
#        rule_setting = Icm::RuleSetting.list_all.where(:company_id=>request.company_id).first
        if support_group
          if "LONGEST_TIME_NOT_ASSIGN".eql?(support_group.assignment_process_code)
            assigner = Irm::SupportGroupMember.query_by_support_group_code(support_group.group_code).
                                               with_person.where("#{Irm::Person.table_name}.assignment_availability_flag = ?",Irm::Constant::SYS_YES).
                                               order("#{Irm::Person.table_name}.last_assigned_date").first
          elsif "MINI_OPEN_TASK".eql?(support_group.assignment_process_code)
            assigner = Irm::SupportGroupMember.query_by_support_group_code(support_group.group_code).
                                               with_person.where("#{Irm::Person.table_name}.assignment_availability_flag = ?",Irm::Constant::SYS_YES).
                                               order("#{Irm::Person.table_name}.open_tasks").first
          else
            #如果选择了不分配，则不进行支持人员的分配
            return assign_result
          end
          if assigner
            Delayed::Worker.logger.debug("GroupAssignmentJob find assigner: #{assigner[:person_id]}")
            assign_result.merge!({:support_person_id=>assigner[:person_id]})
            return  assign_result
          end
        end
        assign_result.merge!(setup_default_person(request))
        assign_result
      end

      # assign to admin
      def setup_default_person(request)
        assign_result ={}
        return assign_result
        company = Irm::Company.find(request.company_id)
        if company&&company.support_manager&&Irm::Person.query(company.support_manager).first
          assign_result.merge!(:support_person_id=>company.support_manager,:support_group_id=>nil)
        else
          assign_result.merge!(:support_person_id=>Irm::Person.admin.id,:support_group_id=>nil)
        end
        assign_result
      end
      #generate incident journal
      def generate_journal(request,assign_result)
        person = Irm::Person.where(:login_name=>"ironmine").first
        if assign_result[:assign_dashboard]
          person = Irm::Person.find(assign_result[:assign_dashboard_operator])
        end
        person ||= Irm::Person.current.id
        language_code = person.language_code
        request_attributes = {:support_group_id=>assign_result[:support_group_id],:support_person_id=>assign_result[:support_person_id]}
        journal_attributes = {:replied_by=>person.id}
        if assign_result[:assign_dashboard]
          journal_attributes.merge!(:message_body=>I18n.t(:label_icm_incident_assign_dashboard,{:locale=>language_code}))
        else
          journal_attributes.merge!(:message_body=>I18n.t(:label_icm_incident_auto_assign,{:locale=>language_code}))
        end
        incident_journal = Icm::IncidentJournal::generate_journal(request,request_attributes,journal_attributes)
        incident_journal = publish_pass_incident_request(incident_journal)
      end

      def publish_pass_incident_request(incident_journal)
        incident_journal.reload
        incident_journal = Icm::IncidentJournal.select_all.with_replied_by.find(incident_journal.id)
        #incident_request = Icm::IncidentRequest.list_all.find(incident_journal.incident_request_id)
        #person_ids = [incident_request.submitted_by,incident_request.requested_by,incident_journal.replied_by,incident_request.support_person_id]+incident_request.person_watchers.collect{|i| i.id}
        #person_ids.uniq!
        #journal_url = url_for({:host=>Irm::Constant::DEFAULT_HOST,
        #         :controller=>"icm/incident_journals",
        #         :action =>"new",
        #         :request_id=>incident_request.id,
        #         :anchor=>"journal_#{incident_journal.id}"})
        #Irm::EventManager.publish(:event_code=>"INCIDENT_REQUEST_PASS",
        #                          :params=>{:to_person_ids=>person_ids,
        #                                    :journal=>incident_journal.attributes.merge(:url=>journal_url,:change_message=>"not change"),
        #                                    :request=>incident_request.attributes})
        incident_journal
      end


    end
  end
end