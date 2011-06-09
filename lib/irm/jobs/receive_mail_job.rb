module Irm
  module Jobs
    class ReceiveMailJob<Struct.new(:type)
      def perform
        Irm::MailManager.receive_mail
      end
    end
  end
end