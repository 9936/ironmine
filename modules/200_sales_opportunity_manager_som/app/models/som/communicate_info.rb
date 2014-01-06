class Som::CommunicateInfo < ActiveRecord::Base
  set_table_name 'som_communicate_infos'
  belongs_to :sales_opportunity
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }
end
