class AlterProcessDefTables < ActiveRecord::Migration
  def self.up
    add_column(:irm_wf_approval_processes,:approve_fields,:string,:after=>:mail_template_id)
    add_column(:irm_wf_process_instances,:comment,:string,:limit=>150,:after=>:process_status_code)
  end

  def self.down
    remove_column(:irm_wf_approval_processes,:approve_fields)
    remove_column(:irm_wf_process_instances,:comment)
  end
end
