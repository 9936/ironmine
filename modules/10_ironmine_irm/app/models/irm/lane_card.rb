class Irm::LaneCard < ActiveRecord::Base
  set_table_name :irm_lane_cards
  belongs_to :lane
  belongs_to :card

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end