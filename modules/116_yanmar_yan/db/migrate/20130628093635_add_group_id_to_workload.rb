class AddGroupIdToWorkload < ActiveRecord::Migration
  def change
    add_column :icm_incident_workloads, :support_group_id, :string, :limit => 22, :after => :incident_request_id
  end
end
