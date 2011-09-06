class Irm::Kanban < ActiveRecord::Base
  set_table_name :irm_kanbans
  query_extend

  attr_accessor :name,:description
  has_many :kanbans_tls, :dependent => :destroy
  has_many :kanban_ranges, :dependent => :destroy
  has_many :kanban_lanes
  has_many :lanes, :through => :kanban_lanes

  validates_presence_of :kanban_code
  validates_uniqueness_of :kanban_code,:scope=>[:opu_id]
  acts_as_multilingual

  before_save :validate_fields

  scope :select_all, lambda{
    select("#{table_name}.*")
  }

  scope :with_lanes, lambda{
    joins(", #{Irm::Lane.view_name} la, #{Irm::KanbanLane.table_name} kl").
        where("la.id = kl.lane_id").
        where("la.language = ?", I18n.locale).
        where("#{table_name}.id = kl.kanban_id").
        where("la.status_code = ?", Irm::Constant::ENABLED).
        select("la.lane_code lane_code, la.name lane_name, la.description lane_description, la.id irm_lane_id, kl.display_sequence display_sequence")
  }

  scope :query_by_position_and_profile, lambda{|profile_id, position_code|
    joins(",#{Irm::KanbansTl.table_name} kbt,#{Irm::ProfileKanban.table_name} pk").
        where("kbt.kanban_id=#{table_name}.id").
        where("kbt.language=?", I18n.locale).
        where("pk.kanban_id=#{table_name}.id").
        where("#{table_name}.position_code=?", position_code).
        where("pk.profile_id=?", profile_id).
        select("kbt.name kanban_name, kbt.description kanban_description")
  }

  def validate_fields
    if self.limit.nil? || self.limit <= 0
      self.limit = 5
    end

    if self.refresh_interval.nil? || self.refresh_interval <5
      self.refresh_interval = 5
    end
  end
end