class Dem::DevManagement< ActiveRecord::Base
  set_table_name 'dem_dev_managements'
  #加入activerecord的通用方法和scope
  query_extend

  validates_presence_of :project, :gap_no

  # 对运维中心数据进行隔离
  default_scope { default_filter }
end
