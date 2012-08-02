class Irm::ProfileApplication < ActiveRecord::Base
  set_table_name :irm_profile_applications

  belongs_to :applicaiton
  belongs_to :profile

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end
