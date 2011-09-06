class Irm::Group < ActiveRecord::Base
  set_table_name :irm_groups

  after_save :explore_group_hierarchy

  #多语言关系
  attr_accessor :name,:description
  has_many :groups_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :code
  validates_uniqueness_of :code, :if => Proc.new { |i| i.code.present?}
  validates_format_of :code,:scope=>[:opu_id], :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present?}

  attr_accessor :level

  #加入activerecord的通用方法和scope
  query_extend


  scope :parentable,lambda{|group_id|
    where("#{table_name}.id!=? AND NOT EXISTS(SELECT 1 FROM #{Irm::GroupExplosion.table_name} WHERE #{Irm::GroupExplosion.table_name}.parent_group_id = ? AND #{Irm::GroupExplosion.table_name}.group_id = #{table_name}.id)",group_id,group_id)
  }


  scope :with_parent,lambda {
    joins("LEFT OUTER JOIN #{Irm::Group.view_name} parent_group ON parent_group.id = #{table_name}.parent_group_id AND parent_group.language = '#{I18n.locale}'").
        select("parent_group.name parent_group_name")
  }


  scope :select_all, lambda{
    select("#{table_name}.*")
  }


  scope :group_memberable,lambda{|person_id|
    where("NOT EXISTS (SELECT 1 FROM #{Irm::GroupMember.table_name}  WHERE #{Irm::GroupMember.table_name}.group_id = #{table_name}.id AND #{Irm::GroupMember.table_name}.person_id = ?)",person_id)
  }

  def self.list_all
    self.multilingual.with_parent
  end

  def assign_member_id
    assigner = nil
    if "LONGEST_TIME_NOT_ASSIGN".eql?(self.assignment_process_code)
      assigner = Irm::GroupMember.query_by_support_group_code(self.group_code).
                                         with_person.
                                         where("#{Irm::Person.table_name}.assignment_availability_flag = ?",Irm::Constant::SYS_YES).
                                         order("#{Irm::Person.table_name}.last_assigned_date").first
      assigner = assigner[:person_id] if assigner
    elsif "MINI_OPEN_TASK".eql?(self.assignment_process_code)
      assigner = Irm::GroupMember.query_by_support_group_code(self.group_code).
                                         with_person.
                                         with_open_tasks.
                                         where("#{Irm::Person.table_name}.assignment_availability_flag = ?",Irm::Constant::SYS_YES).
                                         order("task_counts.count").first
      assigner = assigner[:person_id] if assigner
    end
    assigner
  end

  private
  def explore_group_hierarchy
    Irm::GroupExplosion.explore_hierarchy(self.id,self.parent_group_id)
  end
end
