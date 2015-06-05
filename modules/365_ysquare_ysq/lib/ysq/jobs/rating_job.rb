module Yan
  module Jobs
    class RatingJob<Struct.new(:incident_request_id)
      def perform
        incident_request = Icm::IncidentRequest.unscoped.select_all.find(incident_request_id)
        Irm::Person.current = Irm::Person.find(incident_request.submitted_by)

        # template 　
        mail_template = Irm::MailTemplate.where(:template_code=>"INCIDENT_RATING").first

        params = {:object_params=>Irm::BusinessObject.liquid_attributes(incident_request,true)}
        if mail_template.present? && incident_request.vip_person_ids.any?
          #记录到邮件发送日志表
          logger_options = {
              :reference_target => "incident request rating #{params}",
              :template_code => "INCIDENT_RATING"
          }
          mail_template.deliver_to(params.merge(:to_person_ids => incident_request.vip_person_ids, :logger_options => logger_options ))
        end
      end
    end
  end
end