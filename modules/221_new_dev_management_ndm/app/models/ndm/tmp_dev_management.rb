class Ndm::TmpDevManagement < ActiveRecord::Base
  set_table_name 'ndm_tmp_dev_managements'
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

end
