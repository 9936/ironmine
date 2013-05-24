class AddInstanceUpdatedAtToTasks < ActiveRecord::Migration
  def change
    add_column :gtd_tasks, :instance_updated_at, :datetime, :after => :updated_at
  end
end
