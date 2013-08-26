class Sug::CustomerContact < ActiveRecord::Base
  set_table_name :sug_customer_contacts

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_uniqueness_of :contact_id, :scope => :customer_id
  validates_presence_of :customer_id, :contact_id



end
