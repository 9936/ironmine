class Irm::KanbanRange < ActiveRecord::Base
  set_table_name :irm_kanban_ranges
  belongs_to :kanban

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu
end