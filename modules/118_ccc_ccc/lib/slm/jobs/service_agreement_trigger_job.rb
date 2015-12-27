module Slm
  module Jobs
    class ServiceAgreementTriggerJob<Struct.new(:options)
      def perform

        sla_instance_trigger = Slm::SlaInstanceTrigger.unscoped.where(:id => options[:sla_instance_trigger_id]).first

        return unless sla_instance_trigger.present?

        Irm::Person.current = Irm::Person.unscoped.find(sla_instance_trigger.created_by)

        time_trigger = Slm::TimeTrigger.find(sla_instance_trigger.time_trigger_id)

        sla_instance = Slm::SlaInstance.find(sla_instance_trigger.sla_instance_id)

        business_object = Irm::BusinessObject.where(:bo_model_name=>sla_instance.bo_type).first

        time_trigger_actions = Slm::TimeTriggerAction.where(:time_trigger_id=>time_trigger.id)

        time_trigger_actions.each do |action|
          # 如果时间达到100%的时候插入到超时记录表中
          if time_trigger.duration_percent==100
          Ccc::SlaConIncident.create({:supporter_id=>Icm::IncidentRequest.find(sla_instance.bo_id).support_person_id,
                                      :incident_request_id=>sla_instance.bo_id,
                                      :sla_instance_id=>sla_instance.id
                                     })
          end
          Delayed::Job.enqueue(Irm::Jobs::ActionProcessJob.new({:bo_id => sla_instance.bo_id, :bo_code => business_object.business_object_code, :action_id => action.action_id, :action_type => action.action_type}))
        end
      end
    end
  end
end
