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
        Ironmine::Application.config.action_mailer.smtp_settings[:user_name]
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