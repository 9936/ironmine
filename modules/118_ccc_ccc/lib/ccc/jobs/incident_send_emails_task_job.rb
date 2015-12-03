module Ccc
  module Jobs
    class IncidentSendEmailsTaskJob < Struct.new(:template_code,:incident_request)
      def perform
        bo = Irm::BusinessObject.where(:business_object_code => template_code).first
        _params = {:object_params=>Irm::BusinessObject.liquid_attributes(bo,true)}
        params_dup = _params.dup

        template_params = {}
        template_params = params_dup[:object_params] if  params_dup[:object_params]
        Hash.recursive_stringify_keys(template_params)

        mail_options = {}

        to_emails = incident_request.attribute2
        email_template = Irm::MailTemplate.multilingual.where("template_code = ?","CREATE_INCIDENT_REQUEST").first
        mail_options.merge!(:to=>to_emails)
        # TemplateMailer.template_email(mail_options,email_template,template_params,header_options).deliver
        mail_options =  mail_options.dup
        before_subject = mail_options.delete(:before_subject)||""
        before_body = mail_options.delete(:before_body)||""
        after_subject = mail_options.delete(:after_subject)||""
        after_body = mail_options.delete(:after_body)||""

        send_options = mail_options
        send_options[:from] = Irm::MailManager.default_email_from if Irm::MailManager.default_email_from.present?
        # 设置邮件主题
        # 1，如果邮件主题为liquid模板，则使用liquid解释
        # 2，如果为普通文本则直接作为主题
        subject = %r{\{\{.*\}\}}.match(email_template[:subject])? email_template.render_subject(template_params):email_template[:subject]
        subject = before_subject + subject + after_subject
        send_options.merge!({:subject=>subject})
        # 设置邮件主体内容
        body = email_template.render_body(template_params)
        body = body.gsub(/<br\s*\/?>/i, "\n") unless "html".eql?(email_template.template_type)
        body = strip_tags(body) unless "html".eql?(email_template.template_type)
        body = (before_body.nil? ? "" : before_body) + body + (after_body.nil? ? "" : after_body)
        send_options.merge!({:body=>body})


        send_options.merge!({:content_type=>("html".eql?(email_template.template_type)) ? "text/html" : "text/plain"})

        MailSettingsTestMailer.smtp(send_options).deliver
      end
    end
  end
end