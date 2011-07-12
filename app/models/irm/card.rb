class Irm::Card < ActiveRecord::Base
  set_table_name :irm_cards
  has_many :lane_cards
  has_many :lanes, :through => :lane_cards
end