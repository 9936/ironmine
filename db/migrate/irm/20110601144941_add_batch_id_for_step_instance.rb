class AddBatchIdForStepInstance < ActiveRecord::Migration
  def self.up
    add_column(:irm_wf_step_instances,:batch_id,:integer,:after=>:process_instance_id)
  end

  def self.down
    remove_column(:irm_wf_process_instances,:batch_id)

  end
end
