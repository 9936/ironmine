class Irm::KanbanLane < ActiveRecord::Base
  set_table_name :irm_kanban_lanes
  belongs_to :kanban
  belongs_to :lane

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  def self.max_display_seq(kanban_id)
    Irm::KanbanLane.where(:kanban_id => kanban_id).order("display_sequence DESC").first().display_sequence
  rescue
    1
  end

  def self.min_display_seq(kanban_id)
    Irm::KanbanLane.where(:kanban_id => kanban_id).order("display_sequence ASC").first().display_sequence
  rescue
    1
  end

  def pre_lane
    pre_lane = Irm::KanbanLane.where(:kanban_id => self.kanban_id).where("display_sequence < ?", self.display_sequence).order("display_sequence DESC").first()
    if pre_lane then
      pre_lane
    else
      self
    end
  end

  def next_lane
    next_lane = Irm::KanbanLane.where(:kanban_id => self.kanban_id).where("display_sequence > ?", self.display_sequence).order("display_sequence ASC").first()
    if next_lane then
      next_lane
    else
      self
    end
  end
end