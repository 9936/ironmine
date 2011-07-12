class Irm::KanbanLane < ActiveRecord::Base
  set_table_name :irm_kanban_lanes
  belongs_to :kanban
  belongs_to :lane
end