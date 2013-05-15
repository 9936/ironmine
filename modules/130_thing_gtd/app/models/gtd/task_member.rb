class Gtd::TaskMember < ActiveRecord::Base
  set_table_name :gtd_task_members
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  belongs_to :task, :foreign_key => :task_id

  scope :query_person_ids,lambda{
    joins("JOIN #{Irm::Person.relation_view_name} ON  #{Irm::Person.relation_view_name}.source_type = #{table_name}.member_type AND #{Irm::Person.relation_view_name}.source_id = #{table_name}.member_id").
        select("#{Irm::Person.relation_view_name}.person_id")
  }
end
