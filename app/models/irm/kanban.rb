class Irm::Kanban < ActiveRecord::Base
  set_table_name :irm_kanbans
  query_extend

  attr_accessor :name,:description
  has_many :kanbans_tls, :dependent => :destroy
  has_many :kanban_ranges, :dependent => :destroy
  has_many :kanban_lanes
  has_many :lanes, :through => :kanban_lanes
  has_many :roles
  validates_presence_of :kanban_code
  validates_uniqueness_of :kanban_code
  acts_as_multilingual

  scope :select_all, lambda{
    select("#{table_name}.*")
  }

  scope :with_lanes, lambda{
    joins(", #{Irm::Lane.table_name} la, #{Irm::LanesTl.table_name} lat, #{Irm::KanbanLane.table_name} kl").
        where("la.id = kl.lane_id").
        where("lat.language = ?", I18n.locale).
        where("lat.lane_id = la.id").
        where("#{table_name}.id = kl.kanban_id").
        where("la.status_code = ?", Irm::Constant::ENABLED).
        select("la.lane_code lane_code, lat.name lane_name, lat.description lane_description, la.limit lane_limit, la.id irm_lane_id, kl.display_sequence display_sequence")
  }
end