require 'net/imap'

module Irm::Mail
  module IMAP
    class << self
      def check(imap_options={}, options={})
        mail_options  = (Ironmine::IMAP_MAIL_OPTIONS||{}).dup
        mail_options.merge!(imap_options)
        host = mail_options[:host] || '127.0.0.1'
        port = mail_options[:port] || '143'
        ssl = mail_options[:ssl]
        folder = mail_options[:folder] || 'INBOX'

        imap = Net::IMAP.new(host, port, ssl)
        imap.login(mail_options[:username], mail_options[:password]) unless mail_options[:username].nil?
        imap.select(folder)
        imap.search(['NOT', 'SEEN']).each do |message_id|
          msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
          logger.debug "Receiving message #{message_id}" if logger && logger.debug?
          if TemplateMailer.receive(msg)
            logger.debug "Message #{message_id} successfully received" if logger && logger.debug?
            if imap_options[:move_on_success]
              imap.copy(message_id, imap_options[:move_on_success])
            end
            imap.store(message_id, "+FLAGS", [:Seen, :Deleted])
          else
            logger.debug "Message #{message_id} can not be processed" if logger && logger.debug?
            imap.store(message_id, "+FLAGS", [:Seen])
            if imap_options[:move_on_failure]
              imap.copy(message_id, imap_options[:move_on_failure])
              imap.store(message_id, "+FLAGS", [:Deleted])
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
