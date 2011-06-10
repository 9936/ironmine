class Irm::WfApprovalAction < ActiveRecord::Base
  set_table_name :irm_wf_approval_actions

# action_mode
# 初始操作 AP_SUBMIT
# 最终审批AP_FINAL_APPROVAL
# 最终拒绝AP_FINAL_REJECT
# 审批步骤通过AP_STEP_APPROVAL
# 审批步骤拒绝AP_STEP_REJECT

  def self.submitted_actions(process_id)
    self.where(:process_id=>process_id,:action_mode=>"AP_SUBMIT",:step_id=>nil)
  end

  def self.recall_actions(process_id)
    self.where(:process_id=>process_id,:action_mode=>"AP_RECALL",:step_id=>nil)
  end

  def self.approved_actions(process_id)
    self.where(:process_id=>process_id,:action_mode=>"AP_FINAL_APPROVAL",:step_id=>nil)
  end

  def self.reject_actions(process_id)
    self.where(:process_id=>process_id,:action_mode=>"AP_FINAL_REJECT",:step_id=>nil)
  end

  def self.step_approved_actions(process_id,step_id)
    self.where(:process_id=>process_id,:action_mode=>"AP_STEP_APPROVAL",:step_id=>step_id)
  end

  def self.step_reject_actions(process_id,step_id)
    self.where(:process_id=>process_id,:action_mode=>"AP_STEP_REJECT",:step_id=>step_id)
  end
end
