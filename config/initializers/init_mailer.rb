#扩展发送邮件程序，便于全局控制是否启用邮件服务器发送邮件
require 'mail'
module ExtendsMailer
  def self.included(base)
    base.class_eval do
      def mail(headers={}, &block)
        #如果数据库中存在记录则直接用数据库中的数据
        smtp_setting = Irm::SmtpSetting.first
        if smtp_setting.present?
          if smtp_setting.authentication_flag.eql?(Irm::Constant::SYS_NO)
            smtp_setting.username = nil
            smtp_setting.password = nil
            smtp_setting.authentication = nil
          end

          smtp_settings.merge!({
               :address => smtp_setting.host_name,
               :port => smtp_setting.port,
               :user_name => smtp_setting.username,
               :password => smtp_setting.password,
               :active_flag => smtp_setting.active_flag,
               :enable_starttls_auto => smtp_setting.tls_flag.eql?(Irm::Constant::SYS_YES)? true : false,
               :authentication => smtp_setting.authentication
          })
        end


        if smtp_settings[:active_flag] && smtp_settings[:active_flag].eql?(Irm::Constant::SYS_NO)
          return
        else
          #################记录日志开始#################
          emails = []
          emails += headers[:to].split(",")
          emails += headers[:cc].split(",") if headers[:cc].present?
          emails += headers[:bcc].split(",") if headers[:bcc].present?

          if headers[:logger]
            logger_options = headers[:logger]
            reference_target = logger_options[:reference_target] if logger_options[:reference_target]
            template_code = logger_options[:template_code] if logger_options[:template_code]
          else
            reference_target = ""
            template_code = ""
          end
          #日志记录中带上邮件标题
          reference_target = "#{reference_target}----#{headers[:subject]}"

          emails.each do |email|
            mailer_log = Irm::MailerLog.new()
            mailer_log.reference_target = reference_target
            mailer_log.to_params = email
            mailer_log.template_code = template_code
            mailer_log.send_at = Time.now
            mailer_log.save
          end if emails.any?
          #################日志记录结束#################
        end
        #################删除header中的logger#################

        headers.delete(:logger) if headers[:logger]

        #################删除header中的logger#################


        # Guard flag to prevent both the old and the new API from firing
        # Should be removed when old API is removed
        @mail_was_called = true
        m = @_message

        # At the beginning, do not consider class default for parts order neither content_type
        content_type = headers[:content_type]
        parts_order  = headers[:parts_order]

        # Call all the procs (if any)
        default_values = self.class.default.merge(self.class.default) do |k,v|
          v.respond_to?(:call) ? v.bind(self).call : v
        end

        # Handle defaults
        headers = headers.reverse_merge(default_values)
        headers[:subject] ||= default_i18n_subject

        # Apply charset at the beginning so all fields are properly quoted
        m.charset = charset = headers[:charset]

        # Set configure delivery behavior
        wrap_delivery_behavior!(headers.delete(:delivery_method))

        # Assign all headers except parts_order, content_type and body
        assignable = headers.except(:parts_order, :content_type, :body, :template_name, :template_path)
        assignable.each { |k, v| m[k] = v }

        # Render the templates and blocks
        responses, explicit_order = collect_responses_and_parts_order(headers, &block)
        create_parts_from_responses(m, responses)

        # Setup content type, reapply charset and handle parts order
        m.content_type = set_content_type(m, content_type, headers[:content_type])
        m.charset      = charset

        if m.multipart?
          parts_order ||= explicit_order || headers[:parts_order]
          m.body.set_sort_order(parts_order)
          m.body.sort_parts!
        end

        m
      end
    end
  end
end

ActionMailer::Base.send(:include, ExtendsMailer)

module ExtendsSmtp
  def self.included(base)
    base.class_eval do
      def deliver!(mail)
        if settings[:active_flag] and settings[:active_flag].eql?('N')
          return
        end
        # Set the envelope from to be either the return-path, the sender or the first from address
        envelope_from = mail.return_path || mail.sender || mail.from_addrs.first
        if envelope_from.blank?
          raise ArgumentError.new('A sender (Return-Path, Sender or From) required to send a message')
        end

        destinations ||= mail.destinations if mail.respond_to?(:destinations) && mail.destinations
        if destinations.blank?
          raise ArgumentError.new('At least one recipient (To, Cc or Bcc) is required to send a message')
        end

        message ||= mail.encoded if mail.respond_to?(:encoded)
        if message.blank?
          raise ArgumentError.new('A encoded content is required to send a message')
        end

        smtp = Net::SMTP.new(settings[:address], settings[:port])
        if settings[:enable_starttls_auto]
          if smtp.respond_to?(:enable_starttls_auto)
            unless settings[:openssl_verify_mode]
              smtp.enable_starttls_auto
            else
              openssl_verify_mode = settings[:openssl_verify_mode]
              if openssl_verify_mode.kind_of?(String)
                openssl_verify_mode = "OpenSSL::SSL::VERIFY_#{openssl_verify_mode.upcase}".constantize
              end
              context = Net::SMTP.default_ssl_context
              context.verify_mode = openssl_verify_mode
              smtp.enable_starttls_auto(context)
            end
          end
        end

        response = nil
        smtp.start(settings[:domain], settings[:user_name], settings[:password], settings[:authentication]) do |smtp|
          response = smtp.sendmail(message, envelope_from, destinations)
        end

        return settings[:return_response] ? response : self
      end
    end
  end
end

::Mail::SMTP.send(:include, ExtendsSmtp)