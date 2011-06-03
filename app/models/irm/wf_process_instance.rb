class Irm::WfProcessInstance < ActiveRecord::Base
  set_table_name :irm_wf_process_instances
  query_extend

  scope :with_process,lambda{
    joins("JOIN #{Irm::WfApprovalProcess.table_name} process ON process.id = #{table_name}.process_id").
    select("process.name process_name")
  }

  scope :with_process_status_code,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} process_status ON process_status.lookup_type='WF_PROCESS_INSTANCE_STATUS' AND process_status.lookup_code = #{table_name}.process_status_code AND process_status.language= '#{language}'").
    select(" process_status.meaning process_status_code_name")
  }


  def self.list_all
    select("#{table_name}.*").with_process.with_process_status_code(I18n.locale)
  end


  def detect_process
    process = Irm::WfApprovalProcess.match(self)
    if process
      return process
    end
  end
  # next step of process
  def next_step(step_number)
    current_step_number = step_number
    process_step = Irm::WfApprovalStep.where(:process_id=>self.process_id,:step_number=>current_step_number).first
    while process_step.present?&&"NEXT_STEP".eql?(process_step.auto_approval_result(self.bo_id))
      current_step_number = process_step.step_number+1
      process_step = Irm::WfApprovalStep.where(:process_id=>self.process_id,:step_number=>current_step_number).first
    end
    if process_step.present?
      return process_step
    else
      return nil
    end
  end



  def submit
      if self.bo_instance.respond_to?(:urlable_title)
        self.bo_description  = self.bo_instance.send(:urlable_title)
      else
        self.bo_description = I18n.t(:label_irm_wf_process_instance_bo_instance)
      end
      self.save
      step = Irm::WfApprovalStep.where(:process_id=>self.process_id,:step_number=>1).first
      step.create_step_instance(self)
      self.update_attribute(:next_approver_id,nil)
  end


  def bo_instance
    @bo_instance ||= eval(self.business_object.generate_query(true)).where(:id=>self.bo_id).first
  end

  def business_object
    @business_object ||= Irm::BusinessObject.where(:bo_model_name=>self.bo_model_name).first
  end


  def approved
    self.update_attributes(:process_status_code=>"APPROVED",:end_at=>Time.now)
    execute_final_approved_actions
  end

  def reject
    self.update_attributes(:process_status_code=>"REJECT",:end_at=>Time.now)
    execute_final_reject_actions
  end

  def recall(person_id)
    if(self.process_status_code.eql?("SUBMITTED")&&person_id.eql?(self.submitter_id))
      self.update_attributes(:process_status_code=>"RECALL",:end_at=>Time.now)
      Irm::WfStepInstance.where("process_instance_id = ? AND approval_status_code = ?",self.id, "PENDING").update_all(:approval_status_code=>'RECALL',:end_at=>Time.now)
      execute_recall_actions
    end
  end

  def execute_final_approved_actions

  end

  def execute_final_reject_actions

  end


  def execute_recall_actions

  end

end
