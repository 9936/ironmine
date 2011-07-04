module Irm::ExtendsLogDelayedJob
  def self.included(base)
    base.class_eval do
      after_save  :after_deal
       def after_deal
        if @recordBool == true
           @recordBool = false

        end
      end
      def payload_object=(value)
        @recordBool = true
        super value
      end
      def lock_exclusively!(max_run_time, worker)
        now = self.class.db_time_now
        affected_rows = if locked_by != worker
          # We don't own this job so we will update the locked_by name and the locked_at
          self.class.update_all(["locked_at = ?, locked_by = ?", now, worker], ["id = ? and (locked_at is null or locked_at < ?) and (run_at <= ?)", id, (now - max_run_time.to_i), now])
        else
          # We already own this job, this may happen if the job queue crashes.
          # Simply resume and update the locked_at
          self.class.update_all(["locked_at = ?", now], ["id = ? and locked_by = ?", id, worker])
        end
        if affected_rows == 1
          self.locked_at = now
          self.locked_by = worker
          self.locked_at_will_change!
          self.locked_by_will_change!
          return true
        else
          return false
        end
      end
    end
  end
end