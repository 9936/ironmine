class Irm::LanesTl < ActiveRecord::Base
  set_table_name :irm_lanes_tl

  belongs_to :lane
  validates_presence_of :name
end