class AddEndAtToApprovalInstance < ActiveRecord::Migration
  def self.up
    add_column(:irm_wf_process_instances,:end_at,:datetime,:before=>:status_code)
    add_column(:irm_wf_step_instances,:end_at,:datetime,:before=>:status_code)
  end

  def self.down
    remove_column(:irm_wf_process_instances,:end_at)
    remove_column(:irm_wf_step_instances,:end_at)
  end
end
