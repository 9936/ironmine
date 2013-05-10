module Isp
  module Jobs
    class ProgramScheduleJob<Struct.new(:program_schedule_id)
      def perform
        #a = Isp::Jobs::ProgramScheduleJob.new('004v000B4scOyAqJAntjKi')
        #a.perform
        Irm::Person.current = Irm::Person.anonymous
        program_schedule = Isp::ProgramSchedule.unscoped.where(:id => program_schedule_id,:run_status=>"PENDING").first
        if program_schedule.present?
          begin
            program_schedule.update_attribute(:run_status,"RUNNING")
            program_trigger = program_schedule.program_trigger
            Irm::Person.current = Irm::Person.find(program_trigger.person_id)
            ::I18n.locale = Irm::Person.current.language_code
            program = program_trigger.program

            to_people = Irm::Person.query_by_ids(program_trigger.receiver_person_ids)
            to_mails = to_people.collect{|p| p.email_address if Irm::Constant::SYS_YES.eql?(p.notification_flag)}.compact.join(",")

            ProgramMailer.program_email(program.id, program_schedule, {:to => to_mails}).deliver
            program_schedule.update_attribute(:run_status,"DONE")
          end
        end
      end
    end
  end
end