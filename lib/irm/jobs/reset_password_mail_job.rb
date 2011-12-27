module Irm
  module Jobs
    class ResetPasswordMailJob<Struct.new(:person_id,:person_options)
      def perform
        Irm::Person.current = Irm::Person.anonymous
        business_object = Irm::BusinessObject.where(:bo_model_name=>Irm::Person.name).first
        bo_instance = eval(business_object.generate_query(true)).where(:id=>person_id).first

        recipient_id  = person_id


        # template params
        params = {:object_params => Irm::BusinessObject.liquid_attributes(bo_instance,true)}
        # mail options
        mail_options = {}

        mail_options.merge!(:message_id=>Irm::BusinessObject.mail_message_id(Irm::Person.find(person_id),"reset/password"))

        params.merge!(:mail_options=>mail_options)

        params[:object_params][business_object.business_object_code.downcase].merge!(person_options.stringify_keys)

        # header options
        header_options = {}
        header_options.merge!({"References"=>Irm::BusinessObject.mail_message_id(Irm::Person.find(person_id),"reset/password")})
        params.merge!(:header_options=>header_options)

        # template 　
        mail_template = Irm::MailTemplate.where(:template_code=>"RESET_PASSWORD").first
        mail_template.deliver_to(params.merge(:to_person_ids=>[recipient_id])) if mail_template
      end
    end
  end
end