module Ccc
  module Jobs
    class IncidentSendEmailsTaskJob < Struct.new(:bo_id,:bo_code,:action_id,:action_type)
      def perform
        Irm::Person.current = Irm::Person.anonymous
        bo_id = bo_id
        bo_code = bo_code
        bo = Irm::BusinessObject.where(:business_object_code => bo_code).first
        action_id = action_id
        action_type = action_type
        action = action_type.constantize.find(action_id)
        bo_instance = eval(bo.generate_query(true)).where(:id=>bo_id).first
        action.perform(bo_instance) if bo_instance
    end
    end
  end
end