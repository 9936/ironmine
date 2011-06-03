class CreateWfProcessInstances < ActiveRecord::Migration
  def self.up
    create_table :irm_wf_process_instances do |t|
      t.integer :process_id
      t.integer :bo_id
      t.string  :bo_model_name
      t.string  :bo_description
      t.integer :submitter_id
      t.string  :process_status_code , :limit => 30, :default=>"SUBMITTED"
      t.string   "status_code",     :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "irm_wf_process_instances", ["process_id","bo_id"], :name => "IRM_WF_PROCESS_INSTANCES_N1"

  end

  def self.down
    drop_table :irm_wf_process_instances
  end
end
