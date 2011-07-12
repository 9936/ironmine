class Irm::Lane < ActiveRecord::Base
  set_table_name :irm_lanes
  attr_accessor :name,:description
  has_many :lanes_tls, :dependent => :destroy
  acts_as_multilingual

  has_many :kanban_lanes
  has_many :kanbans, :through => :kanban_lanes
  has_many :lane_cards
  has_many :cards, :through => :lane_cards

  query_extend

  validates_presence_of :lane_code
  validates_uniqueness_of :lane_code
end