class Gtd::TaskAssignMember < ActiveRecord::Base
  set_table_name :gtd_task_assign_members

  validates_presence_of :person_id,:member_type

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end
