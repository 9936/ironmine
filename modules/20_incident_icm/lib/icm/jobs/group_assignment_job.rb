module Icm
  module Jobs
    class GroupAssignmentJob < Struct.new(:incident_request_id,:assign_options)
      def perform
        # 待分配事故单
        request = Icm::IncidentRequest.unscoped.find(incident_request_id)
        Irm::Person.current = Irm::Person.find(request.requested_by)
        # 事故单所属系统
        system = nil
        system = Irm::ExternalSystem.where(:id=>request.external_system_id).first if request.external_system_id.present?

        # 如果事故单已经被分配,则中断分自动分配
        # 强制重分配选项 force_assign
        if assign_options && assign_options.is_a?(Hash) && assign_options[:force_assign]
          nil
        else
          return if request.support_group_id.present?&&request.support_person_id.present?
        end

        # assign_options为分配选项
        assign_result =  assign_options if  assign_options&&assign_options.is_a?(Hash)

        # assign_result 最后分配结果
        assign_result ||= {}

        # person  提单人
        person = Irm::Person.find(request.requested_by)

        # 如果分配选项中指定了支持组,则对支持组进行验证
        # 确认当前支持组是否有人满足处理该事故单的条件
        if assign_result[:support_group_id].present?
          return unless check_support_group(assign_result[:support_group_id],system.id)
        end

        # 指定事故单处理组
        unless request.support_group_id.present?||assign_result[:support_group_id].present?
          assign_result[:support_person_id] = nil
          # 在能处理当前系统事故单的待命组中选择合适的支持组
          support_group_scope = Icm::SupportGroup.enabled.oncall.with_system(request.external_system_id).assignable

          support_group_ids = support_group_scope.collect{|i| i.id}

          # 如果不存在可用的支持组，则中断自动分配
          return unless support_group_ids.any?

          #对事故单按照分派规则进行分单
          assign_rule = Icm::AssignRule.get_support_group_by_incident(request.id, request.external_system_id)
          if assign_rule.present? and assign_rule.support_group.present?
            assign_result[:support_group_id] = assign_rule.support_group
          else
            return
          end
        end
        # 在取得合适的支持组后，分配事故单处理人
        if assign_result[:support_group_id].present?
          unless assign_result[:support_person_id].present?
            support_group = Icm::SupportGroup.query(assign_result[:support_group_id]).first
            assign_result.merge!(:support_person_id => support_group.assign_member_id)
          end
        else
          return
        end
        #get the support information
        #generate incident journal
        if assign_result[:support_group_id].present?#&&assign_result[:support_person_id].present?
          ActiveRecord::Base.transaction do
            generate_journal(request,assign_result)
          end
        end
      end

      #为事故单生成回复
      def generate_journal(request,assign_result)
        person = Irm::Person.query(Irm::OperationUnit.current.primary_person_id).first
        if assign_result[:assign_dashboard]
          person = Irm::Person.find(assign_result[:assign_dashboard_operator])
        end
        Irm::Person.current = person
        language_code = person.language_code
        request_attributes = {:support_group_id=>assign_result[:support_group_id],
                              :support_person_id=>assign_result[:support_person_id],
                              :upgrade_group_id=>assign_result[:support_person_id],
                              :upgrade_person_id=>assign_result[:support_person_id],
                              :charge_group_id=>assign_result[:support_person_id],
                              :charge_person_id=>assign_result[:support_person_id]}
        journal_attributes = {:replied_by=>person.id,:reply_type=>"ASSIGN"}
        incident_status_id = Icm::IncidentStatus.transform(request.incident_status_id,journal_attributes[:reply_type],request.external_system_id)
        request_attributes.merge!(:incident_status_id=>incident_status_id)
        if assign_result[:assign_dashboard]
          journal_attributes.merge!(:message_body=>I18n.t(:label_icm_incident_assign_dashboard,{:locale=>language_code}))
        else
          journal_attributes.merge!(:message_body=>I18n.t(:label_icm_incident_auto_assign,{:locale=>language_code}))
        end
        incident_journal = Icm::IncidentJournal::generate_journal(request,request_attributes,journal_attributes)
      end

      def check_support_group(support_group_id,system_id)
        Icm::SupportGroup.where(:oncall_flag=>Irm::Constant::SYS_YES).assignable.query(support_group_id).first.present?
      end
    end
  end
end