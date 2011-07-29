class AddKanbanIdToRole < ActiveRecord::Migration
  def self.up
    add_column :irm_roles, :kanban_id, :integer, :after => :company_id
  end

  def self.down
    remove_column :irm_roles, :kanban_id
  end
end
