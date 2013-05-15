class Gtd::TaskAssign < ActiveRecord::Base
  set_table_name :gtd_task_assigns

  validates_presence_of :name

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end
