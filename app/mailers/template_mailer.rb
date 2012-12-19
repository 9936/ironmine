require "iconv"
class TemplateMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => Irm::MailManager.default_email_from
  #
  # 使用邮件模板发送邮件
  #
  def email_template(to, email_template, options = {},mail_options={})
    admin_mail_address="root.ironmine@gmail.com"
    headers = {}
    # 设置邮件类型
    headers.merge!({:content_type=>("html".eql?(email_template.template_type))? "text/html":"text/plain"})
    # 设置邮件发送人
    headers.merge!({:from=>email_template.from.blank? ? email_template.from : admin_mail_address})
    # 设置邮件主题
    # 1，如果邮件主题为liquid模板，则使用liquid解释
    # 2，如果为普通文本则直接作为主题
    headers.merge!({:subject=>%r{\{\{.*\}\}}.match(email_template[:subject])? email_template.render_subject(options):email_template[:subject]})
    # 设置收件人
    headers.merge!({:to=>to})
    # 设置邮件主体内容
    headers.merge!({:body=>email_template.render_body(options)})
    # 设置其他发送邮件属性
    headers.merge!(mail_options)
    mail(headers)
  end


  def template_email(mail_options, email_template, template_params={}, header_options={},logger_options ={})
    before_subject = mail_options.delete(:before_subject)||""
    before_body = mail_options.delete(:before_body)||""
    after_subject = mail_options.delete(:after_subject)||""
    after_body = mail_options.delete(:after_body)||""

    send_options = mail_options

    # 设置邮件类型
    send_options.merge!({:content_type=>("html".eql?(email_template.template_type)) ? "text/html" : "text/plain"})
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
    headers(header_options)

    #################记录日志开始#################
    emails = []
    emails += mail_options[:to].split(",")
    emails += mail_options[:cc].split(",") if mail_options[:cc].present?
    emails += mail_options[:bcc].split(",") if mail_options[:bcc].present?

    emails.each do |email|
      mailer_log = Irm::MailerLog.new()
      mailer_log.reference_target = logger_options[:reference_target]
      mailer_log.to_params = email
      mailer_log.template_code = logger_options[:template_code]
      mailer_log.send_at = Time.now
      mailer_log.save
    end if emails.any?
    #################日志记录结束#################

    mail(send_options)



  end


  # receive email from inbox
  def receive(email)
    in_reply_to = email.in_reply_to
    bodies =  clear_message_body(email)
    parsed_email= {:message_id=>email.message_id,:in_reply_to=>in_reply_to,:bodies=>bodies}
    #ActiveSupport::Notifications.instrument("mail.receive", {:email=>email,:parsed_email=>{:message_id=>email.message_id,
    #                                                                                       :in_reply_to=>in_reply_to,
    #                                                                                       :bodies=>bodies}})
    return Irm::MailManager.process_mail(email,parsed_email)
  end


  def clear_message_body(email)
    parts = email.parts.collect {|c| (c.respond_to?(:parts) && !c.parts.empty?) ? c.parts : c}.flatten
    plain_text_bodies = []
    regex = Regexp.new("^[> ]*\s*[\r\n].*", Regexp::MULTILINE)
    parts.each do |p|
      if p.content_type == 'text/plain'
        plain_text_bodies << Iconv.iconv("UTF-8",p.charset, p.body.to_s.gsub(regex,"")).first
      else
        plain_text_body = strip_tags(Iconv.iconv("UTF-8",p.charset, p.body.to_s.gsub(regex,"")).first)
        plain_text_body.gsub! %r{^<!DOCTYPE .*$}, ''
        plain_text_bodies  << plain_text_body
      end
    end

    plain_text_bodies
  end
  Mail::Part
end
