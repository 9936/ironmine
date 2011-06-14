class Irm::WfStepInstance < ActiveRecord::Base
  set_table_name :irm_wf_step_instances

  attr_accessor :process_step,:next_approver_id

  belongs_to :wf_process_instance,:foreign_key => :process_instance_id

  scope :with_assign_approver,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} assign_approver ON assign_approver.id = #{table_name}.assign_approver_id").
    select("assign_approver.full_name assign_approver_name,assign_approver.delegate_approver")

  }

  scope :with_actual_approver,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} actual_approver ON actual_approver.id = #{table_name}.actual_approver_id").
    select("actual_approver.full_name actual_approver_name")
  }

  scope :with_approval_status_code,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} approval_status ON approval_status.lookup_type='WF_STEP_INSTANCE_STATUS' AND approval_status.lookup_code = #{table_name}.approval_status_code AND approval_status.language= '#{language}'").
    select(" approval_status.meaning approval_status_code_name")
  }

  scope :with_process_instance,lambda{|language|
    joins("JOIN #{Irm::WfProcessInstance.table_name} process_instance ON process_instance.id = #{table_name}.process_instance_id").
    joins("LEFT OUTER JOIN #{Irm::BusinessObject.view_name} bo ON bo.bo_model_name = process_instance.bo_model_name AND bo.language = '#{language}'").
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} submitter ON submitter.id = process_instance.submitter_id").
    select("process_instance.submitter_id,submitter.full_name submitter_name,process_instance.created_at submitted_at,process_instance.bo_id,process_instance.bo_description,process_instance.bo_model_name,bo.name bo_model_meaning")
  }

  scope :by_person,lambda{|person_id|
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} delegate_approver ON delegate_approver.id = #{table_name}.assign_approver_id").
    where("#{table_name}.assign_approver_id = ? OR delegate_approver.delegate_approver = ?",person_id,person_id)
  }

  def self.list_all
    select("#{table_name}.*").with_assign_approver.with_actual_approver.with_approval_status_code(I18n.locale)
  end

  def self.select_all
    select("#{table_name}.*")
  end


  def self.last_approve(process_instance_id)
    self.where("#{table_name}.approval_status_code IN (?) AND #{table_name}.actual_approver_id = ? AND #{table_name}.process_instance_id = ?",[],Irm::Person.current.id,process_instance_id).order("end_at desc").first
  end

  def approved(person_id=nil)
    # rollback
    unless check_approvable(person_id)
      raise Wf::RollbackApproveError,self.id
    end
    current_step = Irm::WfApprovalStep.find(self.step_id)
    if "AUTO_APPROVER".eql?(current_step.approver_mode)
      case current_step.multiple_approver_mode
        when "FIRST_APPROVED"
          self.update_attributes(:approval_status_code=>"APPROVED",:actual_approver_id=>person_id,:end_at=>Time.now)
          self.class.where(:process_instance_id=>self.process_instance_id,:batch_id=>self.batch_id,:approval_status_code=>"PENDING").each do |step_i|
            step_i.update_attributes(:approval_status_code=>"MULTIPLE_APPROVED",:end_at=>1.minutes.from_now)
          end

        when "ALL_APPROVED"
          self.update_attributes(:approval_status_code=>"APPROVED",:actual_approver_id=>person_id,:end_at=>Time.now)
          return if self.class.where(process_instance_id=>self.process_instance_id,:step_id=>self.step_id,:approval_status_code=>"PENDING").any?
      end
    else
      self.update_attributes(:approval_status_code=>"APPROVED",:actual_approver_id=>person_id,:end_at=>Time.now)
    end

    next_step = Irm::WfApprovalStep.where(:process_id=>current_step.process_id,:step_number=>current_step.step_number+1).first
    if next_step
      next_step.create_step_instance(wf_process_instance)
      execute_approved_actions
    else
      execute_approved_actions
      wf_process_instance.approved
    end
  end

  def reject(person_id=nil)
    unless check_approvable(person_id)
      raise Wf::RollbackApproveError,self.id
    end
    current_step = Irm::WfApprovalStep.find(self.step_id)
    if "AUTO_APPROVER".eql?(current_step.approver_mode)&&current_step.multiple_approver_mode
      self.update_attributes(:approval_status_code=>"REJECT",:actual_approver_id=>person_id,:end_at=>Time.now)
      self.class.where(:process_instance_id=>self.process_instance_id,:batch_id=>self.batch_id,:approval_status_code=>"PENDING").each do |step_i|
        step_i.update_attributes(:approval_status_code=>"MULTIPLE_REJECT",:end_at=>1.minutes.from_now)
      end
    else
      self.update_attributes(:approval_status_code=>"REJECT",:actual_approver_id=>person_id,:end_at=>Time.now)
    end

    case current_step.reject_behavior
      when "REJECT_STEP"
        next_step = Irm::WfApprovalStep.where(:process_id=>current_step.process_id,:step_number=>1).first
        next_step.create_step_instance(wf_process_instance)
        execute_reject_actions
      when "REJECT_PROCESS"
        execute_reject_actions
        wf_process_instance.reject
    end

  end

  def go_next_step(code,person_id=nil,comment="")
    current_step = Irm::WfApprovalStep.find(self.step_id)
    next_step = Irm::WfApprovalStep.where(:process_id=>current_step.process_id,:step_number=>current_step.step_number+1).first
    if next_step
      next_step.create_step_instance(wf_process_instance)
    else
      wf_process_instance.approved
    end
    self.update_attributes(:approval_status_code=>code,:actual_approver_id=>person_id,:end_at=>Time.now)
  end


  def approved_process(code,person_id=nil,comment="")
    wf_process_instance.approved
    self.update_attributes(:approval_status_code=>code,:actual_approver_id=>person_id,:end_at=>Time.now)
  end

  def reject_process(code,person_id=nil,comment="")
    wf_process_instance.reject
    self.update_attributes(:approval_status_code=>code,:actual_approver_id=>person_id,:end_at=>Time.now)
  end


  def reassign(person_id)
    self.approval_status_code = "REASSIGN"
    self.actual_approver_id = person_id
    self.end_at = Time.now
    self.save
    Irm::WfStepInstance.create(:process_instance_id=>self.process_instance_id,:batch_id=>self.batch_id,:step_id=>self.step_id,:assign_approver_id=>self.next_approver_id)
  end



  def execute_approved_actions
    Irm::WfApprovalAction.step_approved_actions(self.wf_process_instance.process_id,self.step_id).each do |action|
      Delayed::Job.enqueue(Irm::Jobs::ActionProcessJob.new({:bo_id=>self.wf_process_instance.bo_id,:bo_code=>self.wf_process_instance.business_object.business_object_code,:action_id=>action.action_id,:action_type=>action.action_type}))
    end
  end

  def execute_reject_actions
    Irm::WfApprovalAction.step_reject_actions(self.wf_process_instance.process_id,self.step_id).each do |action|
      Delayed::Job.enqueue(Irm::Jobs::ActionProcessJob.new({:bo_id=>self.wf_process_instance.bo_id,:bo_code=>self.wf_process_instance.business_object.business_object_code,:action_id=>action.action_id,:action_type=>action.action_type}))
    end
  end

  private
  def check_approvable(person_id)
    approve_able = false
    if person_id&&self.approval_status_code.eql?("PENDING")
      if person_id.eql?(self.assign_approver_id)
        approve_able = true
      else
        delegate_person_id = Irm::Person.find(self.assign_approver_id).delegate_approver
        if delegate_person_id&&person_id.eql?(delegate_person_id.to_i)
          approve_able = true
        end
      end
    end
    return approve_able
  end

end
