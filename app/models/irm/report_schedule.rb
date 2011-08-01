class Irm::ReportSchedule < ActiveRecord::Base
  set_table_name :irm_report_schedules

  belongs_to :report_trigger

  before_save :setup_run_at_str
  after_create :enqueue_delayed_job

  validates_presence_of :report_trigger_id,:run_at

  private
  def setup_run_at_str
    self.run_at_str = self.run_at.to_i.to_s
  end

  def enqueue_delayed_job
    Delayed::Job.enqueue(Irm::Jobs::ReportScheduleJob.new(self.id), 0,self.run_at)
  end
end
