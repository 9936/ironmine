class AddDisplaySequenceToKanbanLane < ActiveRecord::Migration
  def self.up
    add_column :irm_kanban_lanes, :display_sequence, :integer, :after => :lane_id
  end

  def self.down
    remove_column :irm_kanban_lanes, :display_sequence
  end
end
