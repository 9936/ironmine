 module Irm::ExtendsLogDelayedWorker
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


          delayed_job_log = Irm::DelayedJobLog.where("delayed_job_id = ?", job.id)
          delayed_job_log.first.update_attribute(:end_at, Time.now) if delayed_job_log.any?

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

        log_item = Irm::DelayedJobLogItem.new()
        log_item.delayed_job_id = job.id
        log_item.content = job.last_error
        log_item.job_status = "ERROR"
        log_item.save

        failed(job)
      rescue Exception => error
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