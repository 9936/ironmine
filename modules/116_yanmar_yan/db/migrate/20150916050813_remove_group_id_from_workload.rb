class RemoveGroupIdFromWorkload < ActiveRecord::Migration
  def change
    remove_column :icm_incident_workloads, :group_id
  end
end
