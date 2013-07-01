module Irm
  module Jobs
    class TimeScheduleJob<Struct.new(:time_schedule_id)
      def perform
        Irm::Person.current = Irm::Person.anonymous
        time_schedule = Irm::TimeSchedule.unscoped.where(:id => time_schedule_id, :run_status=>"PENDING").first
        if time_schedule.present?
          begin
            #找到对应的Time_trigger
            time_trigger = time_schedule.time_trigger
            target = time_trigger.target_type
            target_id = time_trigger.target_id
            if target && target_id
              time_schedule.update_attribute(:run_status,"RUNNING")

              #执行目标中的真正逻辑代码
              target_obj = target.constantize.find(target_id)
              target_obj.perform if target_obj.present? && target_obj.respond_to?(:perform)

              time_schedule.update_attribute(:run_status,"DONE")
            end
          end

        end
      end
    end
  end
end