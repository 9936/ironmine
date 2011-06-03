class CreateWfStepInstances < ActiveRecord::Migration
  def self.up
    create_table :irm_wf_step_instances do |t|
      t.integer :process_instance_id ,:null=>false
      t.integer :step_id   ,:null=>false
      t.integer :assign_approver_id
      t.integer :actual_approver_id
      t.string :approval_status_code,     :limit => 30, :default=>"PENDING"
      t.string :comment,:limit=>150
      t.string   "status_code",     :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "irm_wf_step_instances", ["process_instance_id","step_id"], :name => "IRM_WF_STEP_INSTANCES_N1"
    add_index "irm_wf_step_instances", ["actual_approver_id"], :name => "IRM_WF_STEP_INSTANCES_N2"


  end

  def self.down
    drop_table :irm_wf_step_instances
  end
end
