module Irm
  module Jobs
    class ReportScheduleJob<Struct.new(:report_schedule_id)
      def perform
        report_schedule = Irm::ReportSchedule.where(:id => report_schedule_id,:run_status=>"PENDING").first
        if(report_schedule)
          begin
            report_schedule.update_attribute(:run_status,"RUNNING")
            report_trigger = report_schedule.report_trigger
            temp_person_id = Irm::Person.current.id
            temp_language = ::I18n.locale
            Irm::Person.current = Irm::Person.find(report_trigger.person_id)
            ::I18n.locale = Irm::Person.current.language_code
            report = report_trigger.report
            to_people = Irm::Person.query_by_ids(report_trigger.receiver_person_ids)
            to_mails = to_people.collect{|p| p.email_address if Irm::Constant::SYS_YES.eql?(p.notification_flag)}.compact.join(",")
            ReportMailer.report_email(report.id,report_schedule.id,{:to=>to_mails}).deliver
            Irm::Person.current = Irm::Person.find(temp_person_id)
            ::I18n.locale = temp_language
            report_schedule.update_attribute(:run_status,"DONE")
          end
        end
      end
    end
  end
end