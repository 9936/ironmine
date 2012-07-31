require 'net/imap'

module Irm::Mail
  module IMAP
    class << self
      def check(imap_options={}, options={})
        mail_options  = (Irm::MailManager.imap_receive_options||{}).dup
        mail_options.merge!(imap_options)
        host = mail_options[:host] || '127.0.0.1'
        port = mail_options[:port] || '143'
        ssl = mail_options[:ssl]
        folder = mail_options[:folder] || 'INBOX'
        move_on_failure = mail_options[:move_on_failure]||"IRMSEEN"
        move_on_success = mail_options[:move_on_success]||"IRMPROCESSED"


        imap = Net::IMAP.new(host, port, ssl)
        imap.login(mail_options[:username], mail_options[:password]) unless mail_options[:username].nil?
        imap.select(folder)
        puts "Message #{imap.search(['NOT', 'SEEN'])} successfully received"

        imap.search(['NOT', 'SEEN']).each do |message_id|
          envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
          puts envelope.in_reply_to
          next unless envelope&&envelope.in_reply_to&&envelope.in_reply_to.start_with?("<ironmine")

          msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']

          logger.debug "Receiving message #{message_id}" if logger && logger.debug?
          if TemplateMailer.receive(msg)
            logger.debug "Message #{message_id} successfully received" if logger && logger.debug?
            if move_on_success
              unless imap.list("", move_on_success)
                imap.create("#{move_on_success}")
              end
              imap.copy(message_id, move_on_success)
            end
            imap.store(message_id, "+FLAGS", [:Seen])
          else
            logger.debug "Message #{message_id} can not be processed" if logger && logger.debug?
            imap.store(message_id, "+FLAGS", [:Seen])
            if move_on_failure
              unless imap.list("", move_on_failure)
                imap.create("#{move_on_failure}")
              end
              imap.copy(message_id, move_on_failure)
              #imap.store(message_id, "+FLAGS", [:Deleted])
            end
          end
        end
        imap.expunge
      end

      private

      def logger
        Rails.logger
      end
    end
  end
end
