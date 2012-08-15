module Irm
  module Jobs
     class ForgetPwdJob<Struct.new(:email,:person_id,:reset_url)
       def perform
         params = {:to_emails => [email],:to_person_ids =>[person_id]}
         params[:object_params] = {:date => Time.now,:reset_url => reset_url}
         # template 　
         mail_template = Irm::MailTemplate.where(:template_code=>"FORGOTPWD").first
         mail_template.deliver_to(params) if mail_template
       end
     end
  end
end