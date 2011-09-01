class ReworkKanbaLaneTable < ActiveRecord::Migration
  def self.up
    change_column :irm_kanban_lanes, :kanban_id, :string, :limit => 22
    change_column :irm_kanban_lanes, :lane_id, :string, :limit => 22
  end

  def self.down
    change_column :irm_kanban_lanes, :kanban_id, :integer
    change_column :irm_kanban_lanes, :lane_id, :integer
  end
end
