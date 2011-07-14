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

  scope :without_kanban, lambda{|kanban_id|
    joins(",#{Irm::LanesTl.table_name} lt ").
        where("lt.lane_id = #{table_name}.id").
        where("lt.language = ?", I18n.locale).
        where("NOT EXISTS(SELECT 1 FROM #{Irm::KanbanLane.table_name} kl WHERE kl.kanban_id = ? AND kl.lane_id = #{table_name}.id)", kanban_id).
        select("lt.name lane_name, lt.description lane_description")
  }

  scope :select_all, lambda{
    select("#{table_name}.*")
  }

end