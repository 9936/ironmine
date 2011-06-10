class Irm::WfApprovalStep < ActiveRecord::Base
  set_table_name :irm_wf_approval_steps
  attr_accessor :step ,:approver_value_str,:need_order_step_number


  has_many :wf_approval_step_approvers,:foreign_key => :step_id
  belongs_to :wf_approval_process,:foreign_key => :process_id

  query_extend
  before_save :check_attribute
  after_save :setup_process_step_number,:check_attribute

  validates_presence_of :process_id,:name,:step_number,:step_code,:if=>Proc.new{|i| i.check_step(1)}
  validates_uniqueness_of :name,:scope=>[:process_id], :if => Proc.new { |i| i.name.present? }
  validates_uniqueness_of :step_code,:scope=>[:process_id], :if => Proc.new { |i| i.step_code.present? }

  validates_format_of :step_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.step_code.present?}
  validate :validate_step_number,:if=>Proc.new{|i| i.step_number.present?}




  scope :with_reject_behavior,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} reject_behavior ON reject_behavior.lookup_type='WF_STEP_REJECT_MODE' AND reject_behavior.lookup_code = #{table_name}.reject_behavior AND reject_behavior.language= '#{language}'").
    select(" reject_behavior.meaning reject_behavior_name")
  }

  scope :with_approver_mode,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} approver_mode ON approver_mode.lookup_type='WF_STEP_APPROVER_TYPE' AND approver_mode.lookup_code = #{table_name}.approver_mode AND approver_mode.language= '#{language}'").
    select(" approver_mode.meaning approver_mode_name")
  }

  scope :with_evaluate_result,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} evaluate_result ON evaluate_result.lookup_type='WF_STEP_EVALUATE_RESUTL' AND evaluate_result.lookup_code = #{table_name}.evaluate_result AND evaluate_result.language= '#{language}'").
    select(" evaluate_result.meaning evaluate_result_name")
  }



  scope :with_multiple_approver_mode,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} multiple_approver_mode ON multiple_approver_mode.lookup_type='WF_STEP_MULIT_APPROVER_MODE' AND multiple_approver_mode.lookup_code = #{table_name}.multiple_approver_mode AND multiple_approver_mode.language= '#{language}'").
    select(" multiple_approver_mode.meaning multiple_approver_mode_name")
  }


  def self.list_all
    select("#{table_name}.*").
        with_reject_behavior(I18n.locale).
        with_approver_mode(I18n.locale).
        with_multiple_approver_mode(I18n.locale).
        with_evaluate_result(I18n.locale)
  end

  def check_step(stp)
    self.step.nil?||self.step.to_i>=stp
  end

  def init_step_number
    return self.step_number if self.step_number
    self.step_number = self.class.where(:process_id=>self.process_id).count+1
    return self.step_number
  end

  # create approver from str
  def create_approver_from_str
    return unless self.approver_value_str
    str_approvers = self.approver_value_str.split(",").delete_if{|i| !i.present?}
    exists_approvers = Irm::WfApprovalStepApprover.where(:step_id=>self.id)
    exists_approvers.each do |approver|
      if str_approvers.include?("#{approver.approver_type}##{approver.approver_id}")
        str_approvers.delete("#{approver.approver_type}##{approver.approver_id}")
      else
        approver.destroy
      end

    end

    str_approvers.each do |approver_str|
      next unless approver_str.strip.present?
      approver = approver_str.strip.split("#")
      self.wf_approval_step_approvers.build(:approver_type=>approver[0],:approver_id=>approver[1])
    end if str_approvers.any?
  end

  def delete_self
    Irm::WfApprovalStepApprover.where(:step_id=>self.id).delete_all
    Irm::WfApprovalAction.where(:step_id=>self.id).delete_all
    rule_filter = Irm::RuleFilter.query_by_source(self.class.name,self.id).first
    rule_filter.destroy if rule_filter
    # recalculate step number
    self.prepare_deleted_step_number
    self.destroy
  end


  def rule_filter
    @rule_filter ||= Irm::RuleFilter.query_by_source(self.class.name,self.id).first
  end

  def auto_approval_result(wf_process_instance)
    bo_instance = process_instance_bo_instance(wf_process_instance)
    if bo_instance
      return nil
    else
      if self.step_number.to_i.eql?(1)
        return self.evaluate_result
      else
        return "NEXT_STEP"
      end
    end
  end

  # step approvers
  def auto_approver_ids(wf_process_instance)
    unless "AUTO_APPROVER".eql?(self.approver_mode)
      return nil
    end
    bo_instance = process_instance_bo_instance(wf_process_instance)
    person_ids = []
    wf_approval_step_approvers.each do |approver|
      person_ids += approver.person_ids(bo_instance)
    end
    person_ids.uniq
  end


  def process_default_approver_ids(person_id)
    unless "PROCESS_DEFAULT".eql?(self.approver_mode)
      return nil
    end
    business_object = Irm::BusinessObject.where(:business_object_code=>"IRM_PEOPLE").first
    person = eval(business_object.generate_query(true)).where(:id=>person_id).first
    person_id = Irm::BusinessObject.attribute_of(person,Irm::WfApprovalProcess.query_by_step(self.id).first.next_approver_mode)
    return person_id
  end


  # create step instance for process instance
  def create_step_instance(wf_process_instance)
    bo_instance = process_instance_bo_instance(wf_process_instance)
    batch_id = Time.now.to_i
    if bo_instance
      case self.approver_mode
        when "SELECT_BY_SUMBITTER"
          unless wf_process_instance.next_approver_id.present?
            raise Wf::MissingSelectApproverError,self.id
          end
          step_instance = Irm::WfStepInstance.create(:process_instance_id=>wf_process_instance.id,:batch_id=>batch_id,:step_id=>self.id,:assign_approver_id=>wf_process_instance.next_approver_id)
          wf_process_instance.update_attribute(:next_approver_id,nil)
          Delayed::Job.enqueue(Irm::Jobs::ApprovalMailJob.new(step_instance.id))
        when "PROCESS_DEFAULT"
          default_approver_id = self.process_default_approver_ids(Irm::Person.current.id)
          unless default_approver_id.present?
            raise Wf::MissingDefaultApproverError,self.id
          end
          step_instance = Irm::WfStepInstance.create(:process_instance_id=>wf_process_instance.id,:batch_id=>batch_id,:step_id=>self.id,:assign_approver_id=>default_approver_id)
          Delayed::Job.enqueue(Irm::Jobs::ApprovalMailJob.new(step_instance.id))
        when "AUTO_APPROVER"
          auto_approvers =  auto_approver_ids(wf_process_instance)
          unless auto_approvers.any?
            raise Wf::MissingAutoApproverError,self.id
          end
          auto_approvers.each do  |approver_id|
            step_instance = Irm::WfStepInstance.create(:process_instance_id=>wf_process_instance.id,:batch_id=>batch_id,:step_id=>self.id,:assign_approver_id=>approver_id)
            Delayed::Job.enqueue(Irm::Jobs::ApprovalMailJob.new(step_instance.id))
          end
      end
    else
      if self.step_number.to_i.eql?(1)
        case self.evaluate_result
          when "APPROVAL"
            Irm::WfStepInstance.create(:process_instance_id=>wf_process_instance.id,:batch_id=>batch_id,:step_id=>self.id).approved_process("FILTER_AUTO_APPROVED")
          when "REJECT"
            Irm::WfStepInstance.create(:process_instance_id=>wf_process_instance.id,:batch_id=>batch_id,:step_id=>self.id).reject_process("FILTER_AUTO_REJECT")
          when "NEXT_STEP"
            Irm::WfStepInstance.create(:process_instance_id=>wf_process_instance.id,:batch_id=>batch_id,:step_id=>self.id).go_next_step("FILTER_AUTO_NEXT_STEP")
        end
      else
        Irm::WfStepInstance.create(:process_instance_id=>wf_process_instance.id,:batch_id=>batch_id,:step_id=>self.id).go_next_step("FILTER_AUTO_NEXT_STEP")
      end
    end
  end


  def validate_step_number
    max_number = self.class.where(:process_id=>self.process_id).count+1
    if self.step_number.to_i<1||self.step_number.to_i>max_number
      self.errors.add(:step_number,I18n.t(:label_irm_wf_approval_step_validate_step_number,:min=>0,:max=>max_number))
      return false
    end
  end
  private  :validate_step_number

  def setup_process_step_number
    need_order_step_number ||=true
    return unless need_order_step_number
    same_number_step = self.class.where("process_id=? AND id != ? AND step_number = ?",self.process_id,self.id,self.step_number).first
    return unless same_number_step
    need_order_steps = self.class.where("process_id=? AND id != ? AND step_number >= ?",self.process_id,self.id,self.step_number).order("step_number")
    start_number = self.step_number+1
    need_order_steps.each do |step|
      step.update_attributes(:step_number=>start_number,:need_order_step_number=>false) unless start_number.eql?(step.step_number)
      start_number = start_number+1
    end
  end
  private  :setup_process_step_number

  def prepare_deleted_step_number
    need_order_steps = self.class.where("process_id=? AND id != ? AND step_number >= ?",self.process_id,self.id,self.step_number).order("step_number")
    start_number = self.step_number
    need_order_steps.each do |step|
      step.update_attributes(:step_number=>start_number,:need_order_step_number=>false) unless start_number.eql?(step.step_number)
      start_number = start_number+1
    end
  end
  protected  :prepare_deleted_step_number

  def check_attribute
    if self.step_number.eql?(1)
      self.reject_behavior = "REJECT_PROCESS"
    else
      self.evaluate_result = "NEXT_STEP"
    end
  end
  private  :check_attribute


  def process_instance_bo_instance(wf_process_instance)
    bo_instance = wf_process_instance.bo_instance
    if "FILTER".eql?(self.evaluate_mode)
      bo_instance = self.rule_filter.generate_scope.where(:id=>wf_process_instance.bo_id).first
    end
    return bo_instance
  end
  private  :process_instance_bo_instance
end
