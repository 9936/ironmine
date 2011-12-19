class Chm::ChangeTaskDepend < ActiveRecord::Base
  set_table_name :chm_change_task_depends

  belongs_to :change_task
  belongs_to :depend_task,:class_name => "Chm::ChangeTask"

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end
