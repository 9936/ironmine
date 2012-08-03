class Irm::CardsTl < ActiveRecord::Base
  set_table_name :irm_cards_tl
  belongs_to :card

  validates_presence_of :name
end