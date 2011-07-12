class Irm::LaneCard < ActiveRecord::Base
  set_table_name :irm_lane_cards
  belongs_to :lane
  belongs_to :card
end