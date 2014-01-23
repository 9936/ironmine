class Som::PotentialCustomer < ActiveRecord::Base
  set_table_name 'som_potential_customers'
  validates_presence_of :short_name,:full_name
  validates_uniqueness_of :short_name,:full_name
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }
end
