module Irm
  class MailManager
    def self.receive_mail
      case receive_method
        when :imap
          Irm::Mail::IMAP.check
        when :pop
          Irm::Mail::POP3.check
      end
    end

    def self.receive_method
      Ironmine::Application.config.ironmine.mail_receive_method
    end

    def self.receive_interval
      Ironmine::Application.config.ironmine.mail_receive_interval||'10m'
    end

    def self.pop_receive_options
      Ironmine::Application.config.ironmine.mail_receive_pop
    end

    def self.imap_receive_options
      Ironmine::Application.config.ironmine.mail_receive_imap
    end

    def self.default_email_from
      Ironmine::Application.config.action_mailer.smtp_settings[:user_name]
    end
  end
end