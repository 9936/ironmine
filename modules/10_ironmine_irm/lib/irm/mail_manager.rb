module Irm
  module MailManager
    @@processor_classes = []
    @@processors = nil
    class << self
      def receive_mail
        case receive_method
          when :imap
            Irm::Mail::IMAP.check
          when :pop
            Irm::Mail::POP3.check
        end
      end

      def receive_method
        Ironmine::Application.config.fwk.mail_receive_method
      end

      def receive_interval
        Ironmine::Application.config.fwk.mail_receive_interval||'10m'
      end

      def pop_receive_options
        Ironmine::Application.config.fwk.mail_receive_pop
      end

      def imap_receive_options
        Ironmine::Application.config.fwk.mail_receive_imap
      end

      def default_email_from
        current_smtp_settings[:user_name]||Ironmine::Application.config.fwk.mail_send_from || "root.ironmine@gmail.com"
      end


      def add_processor(klass)
        raise "Receive Mail Processor must include Singleton module." unless klass.included_modules.include?(Singleton)
        @@processor_classes << klass
        clear_processors_instances
      end

      # Returns all the listerners instances.
      def processors
        @@processors ||= @@processor_classes.collect {|processor| processor.instance}
      end


      # Clears all the listeners.
      def clear_processors
        @@processor_classes = []
        clear_processors_instances
      end

      # Clears all the listeners instances.
      def clear_processors_instances
        @@processors = nil
      end

      def process_mail(email,parsed_email)
        result = false
        processors.each do |p|
          result = result||p.perform(email,parsed_email) if p.respond_to?(:perform)
        end
        return result
      end

      def current_smtp_settings
        smtp_settings =  Ironmine::Application.config.action_mailer.smtp_settings.dup
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
        smtp_settings

      end
    end
    class Processor
      include Singleton

      # Registers the listener
      def self.inherited(child)
        Irm::MailManager.add_processor(child)
        super
      end

    end
  end
end