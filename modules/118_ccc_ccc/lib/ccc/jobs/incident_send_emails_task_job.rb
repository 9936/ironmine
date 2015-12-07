module Ccc
  module Jobs
    class IncidentSendEmailsTaskJob < Struct.new(:template_code,:email,:incident_request_id)
      def perform
        bo_id = incident_request_id
        bo_code = "ICM_INCIDENT_REQUESTS"
        bo = Irm::BusinessObject.where(:business_object_code => bo_code).first
        bo_instance = eval(bo.generate_query(true)).where(:id=>bo_id).first
        # params确定模板参数
        params = {:object_params=>Irm::BusinessObject.liquid_attributes(bo_instance,true)}
        # mail_options确定发件人和收件人
        mail_options = {}
        mail_options.merge!(:to=>email)
        params.merge!(:mail_options=>mail_options)
        # header_options
        header_options = {}
        params.merge!(:header_options=>header_options)

        #记录到邮件发送日志表
        logger_options = {
            :reference_target => "BUSINESS_OBJECT:#{params}",
            :template_code => template_code
        }
        params.merge!(:code_type=>template_code)

        template_email = Irm::MailTemplate.where("template_code = ?",template_code).first

        person = Irm::Person.current
        I18n.locale =  person.language_code
        Time.zone = person.time_zone
        # params[:object_params] = Irm::BusinessObject.liquid_attributes(bo,true)

        template_email.deliver_to(params.merge(:logger_options => logger_options))
    end
    end
  end
end