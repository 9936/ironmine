class Irm::GroupMember < ActiveRecord::Base
  set_table_name :irm_group_members
  belongs_to :group
  belongs_to :person
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}



  scope :with_person,lambda{|language|
    joins("JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.id = #{table_name}.person_id AND #{Irm::Person.table_name}.delete_flag = 'N' AND(#{Irm::Person.table_name}.customer_status_id = '1' OR #{Irm::Person.table_name}.consultant_status_id = '1')").
    joins("JOIN #{Irm::Organization.view_name} ON #{Irm::Organization.view_name}.id = #{Irm::Person.table_name}.organization_id AND #{Irm::Organization.view_name}.language = '#{language}'").
    select("#{Irm::Person.table_name}.full_name person_name,#{Irm::Person.table_name}.email_address,#{Irm::Organization.view_name}.name organization_name").
    select("#{Irm::Person.table_name}.login_name login_name")
  }

  scope :with_group,lambda{|language|
    joins("JOIN #{Irm::Group.view_name} ON #{Irm::Group.view_name}.id = #{table_name}.group_id AND #{Irm::Group.view_name}.language = '#{language}'").
    select("#{Irm::Group.view_name}.name name,#{Irm::Group.view_name}.description description")
  }

  scope :with_groups_count, lambda{|person_ids|
    select("#{table_name}.person_id, COUNT(1) as group_count").
        where("#{table_name}.person_id IN(?)", person_ids).
        group("#{table_name}.person_id")
  }

  scope :query_by_support_group,lambda{|support_group_id|
    joins("JOIN #{Icm::SupportGroup.table_name} ON #{Icm::SupportGroup.table_name}.group_id = #{table_name}.group_id").
        where("#{Icm::SupportGroup.table_name}.id = ?",support_group_id)
  }

  scope :with_open_tasks,lambda{
    joins(" LEFT OUTER JOIN (SELECT irq.support_person_id,count(*) count
                             FROM  icm_incident_requests irq,icm_incident_statuses ist
                             WHERE irq.support_person_id IS NOT NULL
                               AND irq.incident_status_id = ist.id
                               AND ist.close_flag != '#{Irm::Constant::SYS_YES}'
                               GROUP BY  irq.support_person_id) task_counts ON #{table_name}.person_id = task_counts.support_person_id").
        select("task_counts.count opened_task_count")
  }

  scope :with_system, lambda{|system_id|
      joins(",#{Irm::ExternalSystemPerson.table_name} esp").
          where("esp.external_system_id = ?", system_id).
          where("#{Irm::GroupMember.table_name}.person_id = esp.person_id")
  }

  scope :assignable,lambda{
    where("#{Irm::Person.table_name}.assignment_availability_flag = ?",Irm::Constant::SYS_YES)
  }



end