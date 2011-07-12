class Irm::KanbanRange < ActiveRecord::Base
  set_table_name :irm_kanban_ranges
  belongs_to :kanban
end