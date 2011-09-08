class Irm::WfApprovalProcess < ActiveRecord::Base
  set_table_name :irm_wf_approval_processes

  attr_accessor :step ,:submitter_str


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu

  has_many :wf_approval_submitters,:foreign_key => :process_id

  has_many :wf_approval_step,:foreign_key => :process_id

  scope :query_by_step,lambda{|step_id|
    joins("JOIN #{Irm::WfApprovalStep.table_name} ON #{Irm::WfApprovalStep.table_name}.process_id = #{table_name}.id").
    where("#{Irm::WfApprovalStep.table_name}.id = ?",step_id)
  }

  scope :with_bo,lambda{|language|
    joins("JOIN #{Irm::BusinessObject.view_name} ON #{Irm::BusinessObject.view_name}.business_object_code = #{table_name}.bo_code AND #{Irm::BusinessObject.view_name}.language ='#{language}'").
    select("#{Irm::BusinessObject.view_name}.name bo_name")
  }

  scope :with_mail_template,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::MailTemplate.view_name} mt ON mt.id = #{table_name}.mail_template_id and mt.language='#{language}'").
    select("mt.name mail_template_name")
  }

  scope :with_record_editability,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} editabitity ON editabitity.lookup_type='WF_PROCESS_RECORD_EDITABILITY' AND editabitity.lookup_code = #{table_name}.record_editability AND editabitity.language= '#{language}'").
    select(" editabitity.meaning record_editability_name")
  }

  scope :with_next_approver_mode,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::ObjectAttribute.view_name} next_approver_mode ON next_approver_mode.attribute_name = #{table_name}.next_approver_mode AND next_approver_mode.business_object_code = 'IRM_PEOPLE' AND next_approver_mode.language= '#{language}'").
    select(" next_approver_mode.name next_approver_mode_name")
  }

  scope :query_by_action,lambda{|action_type,action_id|
    joins("JOIN #{Irm::WfApprovalAction.table_name} action ON action.process_id = #{table_name}.id ").
    where("action.action_type = ? AND action.action_id = ?",action_type,action_id)
  }

  scope :submittable,lambda{|person_id|
    joins("JOIN #{Irm::WfApprovalSubmitter.table_name} ON #{Irm::WfApprovalSubmitter.table_name}.process_id = #{table_name}.id").
        where("EXISTS(SELECT 1 FROM #{Irm::Person.relation_view_name} WHERE #{Irm::Person.relation_view_name}.source_id = #{Irm::WfApprovalSubmitter.table_name}.submitter_id AND #{Irm::Person.relation_view_name}.source_type = #{Irm::WfApprovalSubmitter.table_name}.submitter_type AND  #{Irm::Person.relation_view_name}.person_id = ?)",person_id)
  }

  validates_presence_of :bo_code,:name,:process_code,:mail_template_id,:if=>Proc.new{|i| i.check_step(1)}
  validates_format_of :process_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.process_code.present?}

  def self.select_all
    select("#{table_name}.*")
  end

  def self.list_all
    select("#{table_name}.*").with_mail_template(I18n.locale).with_record_editability(I18n.locale).with_next_approver_mode(I18n.locale)
  end

  def business_object
    @business_object ||= Irm::BusinessObject.where(:business_object_code=>self.bo_code).first
  end

  def check_step(stp)
    self.step.nil?||self.step.to_i>=stp
  end

  # create submitter from str
  def create_submitter_from_str
    return unless self.submitter_str
    str_values = self.submitter_str.split(",").delete_if{|i| !i.present?}
    exists_values = Irm::WfApprovalSubmitter.where(:process_id=>self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.submitter_type}##{value.submitter_id}")
        str_values.delete("#{value.submitter_type}##{value.submitter_id}")
      else
        value.destroy
      end

    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      self.wf_approval_submitters.build(:submitter_type=>value[0],:submitter_id=>value[1])
    end
  end


  def get_submitter_str
    return @get_submitter_str if @get_submitter_str
    @get_submitter_str||= submitter_str
    @get_submitter_str||= Irm::WfApprovalSubmitter.where(:process_id=>self.id).collect{|value| "#{value.submitter_type}##{value.submitter_id}"}.join(",")
  end

  def delete_self
    Irm::WfApprovalSubmitter.where(:process_id=>self.id).delete_all
    Irm::WfApprovalAction.where(:process_id=>self.id).delete_all
    rule_filter = Irm::RuleFilter.query_by_source(self.class.name,self.id).first
    rule_filter.destroy if rule_filter
    self.destroy
  end


  def change_active(active=true)
    if active
      self.status_code = "ENABLED"
      self.process_order = self.class.enabled.where(:bo_code=>self.bo_code).count+1
    else
      self.status_code = "OFFLINE"
      need_order_processes = self.class.enabled.where("bo_code=? AND id != ? AND process_order >= ?",self.bo_code,self.id,self.process_order).order("process_order")
      start_number = self.process_order
      need_order_processes.each do |process|
        process.update_attributes(:process_order=>start_number) unless start_number.eql?(process.process_order)
        start_number = start_number+1
      end
    end
    self.save

  end

  def rule_filter
    @rule_filter ||= Irm::RuleFilter.query_by_source(Irm::WfApprovalProcess.name,self.id).first
  end

  def submitter_include?(submitter_id,bo_instance = nil)
    return true if self.class.query(self.id).submittable(submitter_id)
    Irm::WfApprovalSubmitter.bo_attribute(self.id).each do |submitter|
      return true if submitter.include_person?(submitter_id,bo_instance)
    end
    false
  end





  def self.match(wf_process_instance)
    business_object = Irm::BusinessObject.where(:bo_model_name=>wf_process_instance.bo_model_name).first
    self.enabled.where(:bo_code=>business_object.business_object_code).each do |process|
      bo_instance = process.rule_filter.generate_scope.where(:id=>wf_process_instance.bo_id).first
      next unless bo_instance
      return process if process.submitter_include?(wf_process_instance.submitter_id,bo_instance)
    end
    nil
  end
end
