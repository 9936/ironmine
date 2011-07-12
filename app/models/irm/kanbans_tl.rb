class Irm::KanbansTl < ActiveRecord::Base
  set_table_name :irm_kanbans_tl

  belongs_to :kanban
  validates_presence_of :name
end