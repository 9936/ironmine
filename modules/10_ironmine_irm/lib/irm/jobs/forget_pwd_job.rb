module Irm
  module Jobs
     class ForgetPwdJob<Struct.new(:email,:person_id,:reset_url)
       def perform
         params = {:to_emails => [email],:to_person_ids =>[person_id]}
         #将邮件回复中的时区设置到用户当前的时区
         send_at = Time.now
         time_zone = Irm::Person.find(person_id).time_zone

         time_zone ||= "Beijing"
         Time.zone = time_zone
         params[:object_params] = {:datetime => Time.now.in_time_zone.strftime('%Y-%m-%d %H:%M:%S'),:reset_url => reset_url,:email => email}
         # template 　
         mail_template = Irm::MailTemplate.where(:template_code=>"FORGOTPWD").first
         if mail_template
           #记录到邮件发送日志表
           logger_options = {
               :reference_target => "#{email}---------#{person_id}",
               :template_code => "FORGOTPWD"
           }

           mail_template.deliver_to(params.merge!({:logger_options => logger_options}))
        end
       end
     end
  end
end

