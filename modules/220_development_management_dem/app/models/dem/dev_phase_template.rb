class Dem::DevPhaseTemplate< ActiveRecord::Base
  set_table_name 'dem_dev_phase_templates'
  #加入activerecord的通用方法和scope
  query_extend

  validates_presence_of :name

  # 对运维中心数据进行隔离
  default_scope { default_filter }
end
