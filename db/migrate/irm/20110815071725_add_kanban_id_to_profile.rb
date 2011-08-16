class AddKanbanIdToProfile < ActiveRecord::Migration
  def self.up
    add_column :irm_profiles, :kanban_id, :string, :limit => 22
  end

  def self.down
    remove_column :irm_profiles, :kanban_id
  end
end
