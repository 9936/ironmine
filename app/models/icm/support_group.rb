class Icm::SupportGroup < ActiveRecord::Base
  set_table_name :icm_support_groups

  attr_accessor :assignment_str

  #多语言关系
  has_many :group_assignments, :dependent => :destroy, :class_name => "Icm::GroupAssignment"

  validates_presence_of :group_id,:assignment_process_code

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu


  scope :with_assignment_process, lambda{|language|
    select("assignment_process.meaning assignment_process").
      joins("LEFT OUTER JOIN irm_lookup_values_vl assignment_process ON assignment_process.lookup_type='ICM_ASSIGN_PROCESS_TYPE' AND assignment_process.lookup_code = #{table_name}.assignment_process_code AND assignment_process.language='#{language}'")
  }

  scope :with_group,lambda{|language|
    joins("JOIN #{Irm::Group.view_name} ON #{Irm::Group.view_name}.id = #{table_name}.group_id AND #{Irm::Group.view_name}.language ='#{language}'").
        select("#{Irm::Group.view_name}.name")
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

  scope :support_for_person,lambda{|person_id|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
        where("#{Icm::GroupAssignment.table_name}.source_id = ?  AND #{Icm::GroupAssignment.table_name}.source_type = ?",person_id,Irm::BusinessObject.class_name_to_code(Irm::Person.name))
  }

  scope :support_for_service,lambda{|service_code|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
    joins("JOIN #{Slm::ServiceCatalog.table_name} ON #{Slm::ServiceCatalog.table_name}.id  = #{Icm::GroupAssignment.table_name}.source_id").
        where("#{Slm::ServiceCatalog.table_name}.service_category_code = ?  AND #{Icm::GroupAssignment.table_name}.source_type = ?",service_code,Irm::BusinessObject.class_name_to_code(Slm::ServiceCatalog.name))
  }

  scope :support_for_system,lambda{|system_id|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
        where("#{Icm::GroupAssignment.table_name}.source_id = ?  AND #{Icm::GroupAssignment.table_name}.source_type = ?",system_id,Irm::BusinessObject.class_name_to_code(Irm::ExternalSystem.name))
  }

  scope :support_for_group,lambda{|person_id|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
        joins("JOIN #{Irm::Person.relation_view_name} ON #{Irm::Person.relation_view_name}.source_id  = #{Icm::GroupAssignment.table_name}.source_id AND #{Irm::Person.relation_view_name}.source_type  = #{Icm::GroupAssignment.table_name}.source_type").
            where("#{Irm::Person.relation_view_name}.person_id = ?  AND #{Irm::Person.relation_view_name}.source_type = ?",person_id,Irm::BusinessObject.class_name_to_code(Irm::Group.name))
  }

  scope :support_for_group_explosion,lambda{|person_id|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
        joins("JOIN #{Irm::Person.relation_view_name} ON #{Irm::Person.relation_view_name}.source_id  = #{Icm::GroupAssignment.table_name}.source_id AND #{Irm::Person.relation_view_name}.source_type  = #{Icm::GroupAssignment.table_name}.source_type").
            where("#{Irm::Person.relation_view_name}.person_id = ?  AND #{Irm::Person.relation_view_name}.source_type = ?",person_id,Irm::BusinessObject.class_name_to_code(Irm::GroupExplosion.name))
  }

  scope :support_for_role,lambda{|person_id|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
        joins("JOIN #{Irm::Person.relation_view_name} ON #{Irm::Person.relation_view_name}.source_id  = #{Icm::GroupAssignment.table_name}.source_id AND #{Irm::Person.relation_view_name}.source_type  = #{Icm::GroupAssignment.table_name}.source_type").
            where("#{Irm::Person.relation_view_name}.person_id = ?  AND #{Irm::Person.relation_view_name}.source_type = ?",person_id,Irm::BusinessObject.class_name_to_code(Irm::Role.name))
  }

  scope :support_for_role_explosion,lambda{|person_id|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
        joins("JOIN #{Irm::Person.relation_view_name} ON #{Irm::Person.relation_view_name}.source_id  = #{Icm::GroupAssignment.table_name}.source_id AND #{Irm::Person.relation_view_name}.source_type  = #{Icm::GroupAssignment.table_name}.source_type").
            where("#{Irm::Person.relation_view_name}.person_id = ?  AND #{Irm::Person.relation_view_name}.source_type = ?",person_id,Irm::BusinessObject.class_name_to_code(Irm::RoleExplosion.name))
  }

  scope :support_for_organization,lambda{|person_id|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
        joins("JOIN #{Irm::Person.relation_view_name} ON #{Irm::Person.relation_view_name}.source_id  = #{Icm::GroupAssignment.table_name}.source_id AND #{Irm::Person.relation_view_name}.source_type  = #{Icm::GroupAssignment.table_name}.source_type").
            where("#{Irm::Person.relation_view_name}.person_id = ?  AND #{Irm::Person.relation_view_name}.source_type = ?",person_id,Irm::BusinessObject.class_name_to_code(Irm::Organization.name))
  }

  scope :support_for_organization_explosion,lambda{|person_id|
    joins("JOIN #{Icm::GroupAssignment.table_name} ON #{Icm::GroupAssignment.table_name}.support_group_id = #{table_name}.id").
        joins("JOIN #{Irm::Person.relation_view_name} ON #{Irm::Person.relation_view_name}.source_id  = #{Icm::GroupAssignment.table_name}.source_id AND #{Irm::Person.relation_view_name}.source_type  = #{Icm::GroupAssignment.table_name}.source_type").
            where("#{Irm::Person.relation_view_name}.person_id = ?  AND #{Irm::Person.relation_view_name}.source_type = ?",person_id,Irm::BusinessObject.class_name_to_code(Irm::OrganizationExplosion.name))
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
    if "LONGEST_TIME_NOT_ASSIGN".eql?(self.assignment_process_code)
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


  # create assignment from str
  def create_assignment_from_str
    return unless self.assignment_str
    str_values = self.assignment_str.split(",").delete_if{|i| !i.present?}
    exists_values = Icm::GroupAssignment.where(:support_group_id=>self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.source_type}##{value.source_id}")
        str_values.delete("#{value.source_type}##{value.source_id}")
      else
        value.destroy
      end

    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      self.group_assignments.create(:source_type=>value[0],:source_id=>value[1])
    end
  end

  def get_assignment_str
    return @get_assignment_str if @get_assignment_str
    @get_assignment_str = Icm::GroupAssignment.where(:support_group_id=>self.id).collect{|value| "#{value.source_type}##{value.source_id}"}.join(",")
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
