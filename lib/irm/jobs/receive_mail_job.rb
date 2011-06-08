module Irm
  module Jobs
    class ReceiveMailJob<Struct.new(:type)
      def perform
        case Ironmine::MAIL_RECEIVE_TYPE.to_s
          when "imap"
            Irm::Mail::IMAP.check
          when "pop3"
            Irm::Mail::POP3.check
        end
      end
    end
  end
end