class Icm::ExternalSystemGroup < ActiveRecord::Base
  set_table_name :icm_external_system_groups

  attr_accessor :temp_group_ids

  validates_uniqueness_of :support_group_id, :scope => [:external_system_id]
  validates_presence_of :support_group_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }


  scope :query_by_sp, lambda { |external_system_id, person_id|
    joins("JOIN #{Icm::SupportGroup.table_name} ON #{Icm::SupportGroup.table_name}.id = #{table_name}.support_group_id").
        joins("JOIN #{Irm::GroupMember.table_name} ON #{Icm::SupportGroup.table_name}.group_id = #{Irm::GroupMember.table_name}.group_id").
        where("#{table_name}.external_system_id = ? AND #{Irm::GroupMember.table_name}.person_id=?", external_system_id, person_id)
  }


  scope :with_system, lambda { |system_id|
    where("external_system_id = ?", system_id)
  }

  scope :systems_num, lambda { |support_group_id|
    select("COUNT(1) as system_count").
        where("#{table_name}.support_group_id=?", support_group_id)
  }

  scope :with_system_count, lambda { |support_group_ids|
    select("#{table_name}.support_group_id, COUNT(1) as system_count").
        where("#{table_name}.support_group_id IN(?)", support_group_ids).
        group("#{table_name}.support_group_id")
  }

  scope :with_groups, lambda { |language|
    joins("JOIN #{Icm::SupportGroup.table_name} ON #{Icm::SupportGroup.table_name}.id=#{table_name}.support_group_id").
        joins("JOIN #{Irm::Group.view_name} ON #{Irm::Group.view_name}.id = #{Icm::SupportGroup.table_name}.group_id AND #{Irm::Group.view_name}.language ='#{language}'").
        select("#{table_name}.*, #{Irm::Group.view_name}.name group_name, #{Icm::SupportGroup.table_name}.status_code group_status_code, #{Icm::SupportGroup.table_name}.assignment_process_code")
  }


end