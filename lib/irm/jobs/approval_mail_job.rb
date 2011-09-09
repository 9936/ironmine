module Irm
  module Jobs
    class ApprovalMailJob<Struct.new(:step_instance_id)
      def perform
        Irm::Person.current = Irm::Person.anonymous
        step_instance = Irm::WfStepInstance.find(step_instance_id)
        step = Irm::WfApprovalStep.find(step_instance.step_id)
        process_instance = step_instance.wf_process_instance
        process = Irm::WfApprovalProcess.find(process_instance.process_id)
        bo_instance = process_instance.bo_instance

        recipient_id  = step_instance.assign_approver_id
        I18n.locale = Irm::Person.find(recipient_id).language_code
        # template params
        params = {:object_params => Irm::BusinessObject.liquid_attributes(bo_instance,true).merge(Irm::BusinessObject.liquid_attributes(step,true))}
        # mail options
        mail_options = {}

        #　mail approve_able
        approve_able = true
        unless Irm::WfSetting.email_approval?
          approve_able = false
        end

        if approve_able
          next_step = process_instance.simulate_approve_next_step(step.step_number)
          if next_step&&next_step.approver_mode.eql?("SELECT_BY_SUMBITTER")
            approve_able = false
          end
        end
        if approve_able
          mail_options.merge!(:before_body=>"<b>#{I18n.t(:label_irm_wf_step_instance_allow_mail_approve)}</b><br/><br/>")
          mail_options.merge!(:message_id=>Irm::BusinessObject.mail_message_id(step_instance,"mailapproval/allow"))
        else
          mail_options.merge!(:before_body=>"<b>#{I18n.t(:label_irm_wf_step_instance_not_allow_mail_approve)}</b><br/><br/>")
          mail_options.merge!(:message_id=>Irm::BusinessObject.mail_message_id(step_instance,"mailapproval/notallow"))
        end
        params.merge!(:mail_options=>mail_options)

        # header options
        header_options = {}
        header_options.merge!({"References"=>Irm::BusinessObject.mail_message_id(process_instance,"mailapproval")})
        params.merge!(:header_options=>header_options)

        # template 　
        mail_template = Irm::MailTemplate.find(process.mail_template_id)
        mail_template.deliver_to(params.merge(:to_person_ids=>[recipient_id]))
      end
    end
  end
end