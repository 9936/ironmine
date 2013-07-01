class Irm::TimeSchedule < ActiveRecord::Base
  set_table_name :irm_time_schedules

  belongs_to :time_trigger, :foreign_key => :time_trigger_id

  validates_presence_of :time_trigger_id,:run_at

  before_save :setup_run_at_str
  after_create :enqueue_delayed_job

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  private
    def setup_run_at_str
      self.run_at_str = self.run_at.to_i.to_s
    end

    def enqueue_delayed_job
      Delayed::Job.enqueue(Irm::Jobs::TimeScheduleJob.new(self.id), 0, self.run_at)
    end

end
