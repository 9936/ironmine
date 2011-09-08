class Irm::IdFlex < ActiveRecord::Base
  set_table_name :irm_id_flexes
  validates_presence_of :id_flex_name
  validates_presence_of :id_flex_code
  validates_uniqueness_of :id_flex_code,:scope=>[:opu_id]
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu
end
