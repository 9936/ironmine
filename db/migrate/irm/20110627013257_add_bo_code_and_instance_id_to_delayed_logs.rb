class AddBoCodeAndInstanceIdToDelayedLogs < ActiveRecord::Migration
  def self.up
    add_column :irm_delayed_job_logs, :bo_code, :string, :limit => 30, :after => :delayed_job_id
    add_column :irm_delayed_job_logs, :instance_id, :integer, :after => :delayed_job_id
  end

  def self.down
    remove_column :irm_delayed_job_logs, :bo_code
    remove_column :irm_delayed_job_logs, :instance_id
  end
end
