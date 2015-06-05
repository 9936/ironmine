class ChangeGroupIdInWorkload < ActiveRecord::Migration
  def up
    rename_column :icm_incident_workloads, :support_group_id, :group_id
  end

  def down
  end
end
