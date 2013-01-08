class AddSequenceToDelayedJobItems < ActiveRecord::Migration
  def change
    add_column :irm_delayed_job_log_items, :sequence, :string, :after => :job_status
  end
end
