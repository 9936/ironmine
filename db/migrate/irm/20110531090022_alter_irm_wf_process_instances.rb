class AlterIrmWfProcessInstances < ActiveRecord::Migration
  def self.up
    add_column(:irm_wf_process_instances,:next_approver_id,:integer,:after=>:process_id)
  end

  def self.down
    remove_column(:irm_wf_process_instances,:next_approver_id)
  end
end
