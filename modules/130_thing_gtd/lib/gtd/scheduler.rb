module Gtd
  class Scheduler<Struct.new(:scheduler, :logger)
    def perform
      scheduler.every '1m' do
        logger.debug "schedule task alert at #{Time.now}"
        puts 'check blood pressure'
      end

      #在任务实例前一天的23:00取检查下一天要执行的任务，并建立相应的警告
      #scheduler.cron '15 13 * * *' do
      #  Gtd::Task.tomorrow_tasks.each do |task|
      #    logger.debug "schedule task alert at #{Time.now}"
      #    task.generate_notify
      #  end
      #end

    end

  end
end