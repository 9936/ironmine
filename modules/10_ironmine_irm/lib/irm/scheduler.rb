module Irm
  class Scheduler<Struct.new(:scheduler, :logger)
    def perform
      # receive email
      scheduler.every Irm::MailManager.receive_interval do
        logger.debug "schedule receive mail job"
        Irm::MailManager.receive_mail
      end
      # sync report schedule
      scheduler.cron '0 0 0 * * *' do
        logger.debug "sync report schedule"
        Irm::ReportTrigger.unscoped.all.each { |i|
          Irm::Person.current = Irm::Person.unscoped.find(i.created_by)
          i.sync_schedule
        }
      end

      # Generate incident request from mail
      scheduler.every Irm::MailManager.receive_interval do
        logger.debug "schedule receive mail and generate request job"
        Icm::MailRequest.receive_mail
      end
    end
  end
end