class AddLockbyToDelayedJobLog < ActiveRecord::Migration
  def self.up
    add_column :irm_delayed_job_logs, :locked_by, :text, :after => "locked_at"
  end

  def self.down
    remove_column :irm_delayed_job_logs, :locked_by
  end
end
