class Som::SendCommunicate < ActiveRecord::Base
  set_table_name 'som_send_communicates'
  acts_as_timetrigger
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }
end
