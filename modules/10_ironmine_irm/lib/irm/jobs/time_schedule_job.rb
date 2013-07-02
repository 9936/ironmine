module Irm
  module Jobs
    class TimeScheduleJob<Struct.new(:time_schedule_id)
      def perform
        Irm::Person.current = Irm::Person.anonymous
        time_schedule = Irm::TimeSchedule.unscoped.where(:id => time_schedule_id, :run_status=>"PENDING").first
        if time_schedule.present?
          #找到对应的Time_trigger
          time_trigger = time_schedule.time_trigger
          source = time_trigger.source_type
          source_id = time_trigger.source_id
          if source && source_id
            time_schedule.update_attribute(:run_status,"RUNNING")

            #执行目标中的真正逻辑代码
            source_obj = source.constantize.find(source_id)
            source_obj.perform #if source_obj.present? && source_obj.respond_to?(:perform)

            time_schedule.update_attribute(:run_status,"DONE")
          end
        end
      end
    end
  end
end