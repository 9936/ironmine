class Irm::ProfileLane < ActiveRecord::Base
  set_table_name :irm_profile_lanes
  query_extend

  scope :with_lanes, lambda{
    joins(",#{Irm::Lane.view_name} l").
        where("l.id = #{table_name}.lane_id").
        where("l.language=?", I18n.locale).
        select("l.name lane_name, l.description lane_description, l.lane_code lane_code")
  }

  scope :select_all, lambda{
    select("#{table_name}.*")
  }

  def next_sequence
    self.display_sequence + 1
  rescue
    1
  end

  def self.max_sequence(pk_id)
    Irm::ProfileLane.where(:profile_kanban_id => pk_id).maximum("display_sequence")
  rescue
    0
  end

  def self.reorder(pk_id)
    icount = 1
    Irm::ProfileLane.where(:profile_kanban_id => pk_id).order("display_sequence ASC").each do |t|
      t.update_attribute(:display_sequence, icount)
      icount = icount + 1
    end
  rescue
    false
  end
end