module Gtd
  class Scheduler<Struct.new(:scheduler, :logger)
    def perform

      #在任务实例前一天的23:00取检查下一天要执行的任务，并建立相应的警告
      scheduler.cron '00 23 * * *' do
        Gtd::Task.tomorrow_tasks.each do |task|
          logger.debug "schedule task notify at: #{Time.now}"
          task.generate_notify
        end
      end

      #获取任务生成实例的最后日期为昨天的
      scheduler.cron '0 0 * * *' do
        Gtd::Task.today_need_instance_tasks.each do |task|
          logger.debug "schedule task generate instance at: #{Time.now}"
          task.generate_task_instances(Time.now + 1.month)
        end
      end

    end

  end
end