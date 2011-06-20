module Irm::DelayedJobBaseEx
  def self.included(base)
    base.class_eval do
      def enqueue(*args)
        options = {
          :priority => Delayed::Worker.default_priority
        }.merge!(args.extract_options!)

        options[:payload_object] ||= args.shift

        if args.size > 0
          warn "[DEPRECATION] Passing multiple arguments to `#enqueue` is deprecated. Pass a hash with :priority and :run_at."
          options[:priority] = args.first || options[:priority]
          options[:run_at]   = args[1]
        end

        unless options[:payload_object].respond_to?(:perform)
          raise ArgumentError, 'Cannot enqueue items which do not respond to perform'
        end

        if Delayed::Worker.delay_jobs
          self.create(options).tap do |job|
            job.hook(:enqueue)
            delayed_job_log = Irm::DelayedJobLog.new()
            delayed_job_log.delayed_job_id = job.id
            delayed_job_log.priority = job.priority
            delayed_job_log.attempts = job.attempts
            delayed_job_log.handler = job.handler
            delayed_job_log.run_at = job.run_at
            delayed_job_log.save

            log_item = Irm::DelayedJobLogItem.new()
            log_item.delayed_job_id = job.id
            log_item.content = "ENQUEUE"
            log_item.job_status = "ENQUEUE"
            log_item.save
          end
        else
          options[:payload_object].perform
        end
      end

      def invoke_job
        hook :before
        payload_object.perform
        hook :success
      rescue Exception => e
        hook :error, e
        raise e
      ensure
        hook :after
      end
    end
  end
end