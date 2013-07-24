class Emw::Database < ActiveRecord::Base
  validates :name, :presence => true
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }
end
