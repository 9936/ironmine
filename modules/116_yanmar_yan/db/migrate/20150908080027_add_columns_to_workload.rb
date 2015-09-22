class AddColumnsToWorkload < ActiveRecord::Migration
  def change
    change_column :icm_incident_workloads, :real_processing_time, :integer, :limit => 11, :after => :workload_type
    add_column :icm_incident_workloads, :incident_journal_id, :string, :limit => 22, :after => :incident_request_id
    add_column :icm_incident_workloads, :incident_status_id, :string, :limit => 22, :after => :incident_journal_id
    add_column :icm_incident_workloads, :people_count_c, :integer, :null => false, :limit => 11, :after => :workload_type
    add_column :icm_incident_workloads, :people_count_t, :integer, :null => false, :limit => 11, :after => :workload_type
    add_column :icm_incident_workloads, :real_processing_time_t, :integer, :limit => 11, :after => :workload_type
    add_column :icm_incident_workloads, :start_time, :datetime
    add_column :icm_incident_workloads, :end_time, :datetime, :after => :start_time
    add_column :icm_incident_workloads, :subtotal_processing_time, :integer, :limit => 11, :after => :workload_type
  end
end
