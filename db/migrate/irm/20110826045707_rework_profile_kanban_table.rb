class ReworkProfileKanbanTable < ActiveRecord::Migration
  def self.up
    remove_column :irm_profile_kanbans, :position_code
    remove_column :irm_profile_kanbans, :limit
    remove_column :irm_profile_kanbans, :refresh_interval
  end

  def self.down
    add_column :irm_profile_kanbans, :position_code, :string, :limit => 22, :after => :kanban_id
    add_column :irm_profile_kanbans, :limit, :integer, :after => :kanban_id
    add_column :irm_profile_kanbans, :refresh_interval, :integer, :after => :kanban_id
  end
end
