module Fwk::ExtendsLogDelayedWorker
  def self.included(base)
    base.class_eval do
       def run(job)
        runtime =  Benchmark.realtime do
          Timeout.timeout(self.class.max_run_time.to_i) {

            log_item = Irm::DelayedJobLogItem.new()
            log_item.delayed_job_id = job.id
            log_item.content = "RUN"
            log_item.job_status = "RUN"
            log_item.save

            job.invoke_job
          }
          log_item = Irm::DelayedJobLogItem.new()
          log_item.delayed_job_id = job.id
          log_item.content = "COMPLETE"
          log_item.job_status = "COMPLETE"
          log_item.save


          delayed_job_log = Irm::DelayedJobLog.find_by_delayed_job_id(job.id)
          delayed_job_log.update_attribute(:end_at, Time.now) if delayed_job_log.present?

          job.destroy

          log_item = Irm::DelayedJobLogItem.new()
          log_item.delayed_job_id = job.id
          log_item.content = "DESTROY"
          log_item.job_status = "DESTROY"
          log_item.save
        end
      say "#{job.name} completed after %.4f" % runtime
      return true  # did work
      rescue ::Delayed::DeserializationError => error
        job.last_error = "{#{error.message}\n#{error.backtrace.join('\n')}"

        #更新delayed_job_log
        delayed_job_log = Irm::DelayedJobLog.find_by_delayed_job_id(job.id)
        if delayed_job_log.present?
          delayed_job_log.attempts = job.attempts.to_i + 1 if job.attempts
          delayed_job_log.last_error = job.last_error
          delayed_job_log.failed_at = job.failed_at if job.failed_at
          delayed_job_log.locked_by = job.locked_by if job.locked_by
          delayed_job_log.save
        end

        log_item = Irm::DelayedJobLogItem.new()
        log_item.delayed_job_id = job.id
        log_item.content = job.last_error
        log_item.job_status = "ERROR"
        log_item.save

        failed(job)
       rescue Exception => error

        #更新delayed_job_log
        delayed_job_log = Irm::DelayedJobLog.find_by_delayed_job_id(job.id)
        if delayed_job_log.present?
          delayed_job_log.attempts = job.attempts.to_i + 1 if job.attempts
          delayed_job_log.last_error = error
          delayed_job_log.failed_at = job.failed_at if job.failed_at
          delayed_job_log.locked_by = job.locked_by if job.locked_by
          delayed_job_log.save
        end

        log_item = Irm::DelayedJobLogItem.new()
        log_item.delayed_job_id = job.id
        log_item.content = job.last_error
        log_item.job_status = "ERROR"
        log_item.save

        handle_failed_job(job, error)
        return false  # work failed
    end
    end
  end
end