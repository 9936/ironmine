class Som::CommunicateInfo < ActiveRecord::Base
  set_table_name 'som_communicate_infos'
  belongs_to :sales_opportunity
  has_one :participation_info
  attr_accessor :our_persons,:our_roles,:client_persons,:client_roles

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :desc, order("#{table_name}.created_at DESC")
end
