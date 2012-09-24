class Icm::SupportGroup < ActiveRecord::Base
  set_table_name :icm_support_groups

  class << self
    attr_accessor_with_default :multilingual_view_name,"icm_support_groups_vl"
  end

  #多语言关系
  has_many :assign_rule, :dependent => :destroy, :class_name => "Icm::AssignRule"

  validates_presence_of :group_id,:assignment_process_code
  validates_presence_of :assign_person_id ,:if=>Proc.new{|i| i.assignment_process_code.present?&&i.assignment_process_code.eql?("ASSIGN_PERSON")}
  attr_accessor :level

  before_validation do
    unless self.assignment_process_code.present?&&self.assignment_process_code.eql?("ASSIGN_PERSON")
      self.assign_person_id = nil
    end
  end

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  scope :with_assignment_process, lambda{|language|
    select("assignment_process.meaning assignment_process").
      joins("LEFT OUTER JOIN irm_lookup_values_vl assignment_process ON assignment_process.lookup_type='ICM_ASSIGN_PROCESS_TYPE' AND assignment_process.lookup_code = #{table_name}.assignment_process_code AND assignment_process.language='#{language}'")
  }

  scope :with_group,lambda{|language|
    joins("JOIN #{Irm::Group.view_name} ON #{Irm::Group.view_name}.id = #{table_name}.group_id AND #{Irm::Group.view_name}.language ='#{language}'").
        select("#{Irm::Group.view_name}.name, #{Irm::Group.view_name}.parent_group_id, #{Irm::Group.view_name}.id group_id")
  }

  scope :with_groups, lambda{|language|
    joins("JOIN #{Irm::Group.view_name} ON #{Irm::Group.view_name}.id = #{table_name}.group_id AND #{Irm::Group.view_name}.language ='#{language}'")
  }

  scope :access_system,lambda{
    joins("JOIN #{Irm::GroupMember.table_name} ON #{Irm::GroupMember.table_name}.group_id  = #{table_name}.group_id").
        joins("JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.id  = #{Irm::GroupMember.table_name}.person_id").
        joins("JOIN #{Irm::Person.relation_view_name} ON #{Irm::Person.relation_view_name}.person_id  = #{Irm::GroupMember.table_name}.person_id").
        where("#{Irm::Person.relation_view_name}.source_type = ? AND #{Irm::Person.table_name}.assignment_availability_flag=?",Irm::BusinessObject.class_name_to_code(Irm::ExternalSystem.name),Irm::Constant::SYS_YES).
        select("#{Irm::Person.relation_view_name}.source_id system_id")
  }

  # 能处理该系统事故单的支持组
  scope :query_by_system,lambda{|system_id|
    joins("JOIN #{Irm::GroupMember.table_name} ON #{Irm::GroupMember.table_name}.group_id  = #{table_name}.group_id").
        joins("JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.id  = #{Irm::GroupMember.table_name}.person_id").
        where("EXISTS(SELECT 1 FROM #{Irm::Person.relation_view_name} WHERE #{Irm::Person.relation_view_name}.source_type = ? AND #{Irm::Person.relation_view_name}.source_id = ? AND #{Irm::Person.relation_view_name}.person_id = #{Irm::GroupMember.table_name}.person_id)",Irm::BusinessObject.class_name_to_code(Irm::ExternalSystem.name),system_id).
        where("#{Irm::Person.table_name}.assignment_availability_flag=?",Irm::Constant::SYS_YES)
  }


  scope :support_for_service,lambda{|service_code|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
    joins("JOIN #{Slm::ServiceCatalog.table_name} ON #{Slm::ServiceCatalog.table_name}.id  = #{Icm::GroupAssignment.table_name}.source_id").
        where("#{Slm::ServiceCatalog.table_name}.catalog_code = ?  AND #{Icm::GroupAssignment.table_name}.source_type = ?",service_code,Irm::BusinessObject.class_name_to_code(Slm::ServiceCatalog.name))
  }

  # 待命组
  scope :oncall,lambda{
    where(:oncall_flag=>Irm::Constant::SYS_YES)
  }
  # 组内有可分单的人员
  scope :assignable,lambda{
    where("EXISTS(SELECT 1 FROM #{Irm::GroupMember.table_name} gm,#{Irm::Person.table_name} p WHERE gm.group_id = #{table_name}.group_id AND p.assignment_availability_flag = ?)",Irm::Constant::SYS_YES)
  }

  def self.list_all
    self.multilingual.with_assignment_process(I18n.locale)
  end

  def assign_member_id
    assigner = nil
    if "ASSIGN_PERSON".eql?(self.assignment_process_code)&&self.assign_person_id.present?
      assigner = self.assign_person_id
    elsif "LONGEST_TIME_NOT_ASSIGN".eql?(self.assignment_process_code)
      assigner = Irm::GroupMember.select_all.where(:group_id=>self.group_id).
                                         with_person(I18n.locale).
                                         where("#{Irm::Person.table_name}.assignment_availability_flag = ?",Irm::Constant::SYS_YES).
                                         order("#{Irm::Person.table_name}.last_assigned_date").first
      assigner = assigner[:person_id] if assigner
    elsif "MINI_OPEN_TASK".eql?(self.assignment_process_code)
      assigner = Irm::GroupMember.select_all.where(:group_id=>self.group_id).
                                         with_person(I18n.locale).
                                         with_open_tasks.
                                         where("#{Irm::Person.table_name}.assignment_availability_flag = ?",Irm::Constant::SYS_YES).
                                         order("task_counts.count").first
      assigner = assigner[:person_id] if assigner
    end
    assigner
  end


  # 第一个支持组对应的组id
  def self.first_group_id
    first_support_group = self.order(:id).first
    if first_support_group
      return first_support_group.group_id
    else
      first_group = Irm::Group.first
      return first_group.id if first_group
    end
    return nil
  end

  def self.first_not_support_group
    not_support_group = Irm::Group.find_by_sql("select g.id from irm_groups g where not exists (select group_id from icm_support_groups sg where g.id = sg.group_id)").first
    if not_support_group.present?
      not_support_group[:id]
    else
      nil
    end
  end


  def parent_group_id
    group = Irm::Group.find(self.group_id)
    relation_parent_group_id = group.parent_group_id
    if relation_parent_group_id
      parent_group = self.class.where(:group_id=>relation_parent_group_id).first
      return parent_group.id if parent_group
    end
    nil
  end

end
