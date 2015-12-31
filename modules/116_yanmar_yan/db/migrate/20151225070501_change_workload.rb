class ChangeWorkload < ActiveRecord::Migration
  def up
    rename_column :icm_incident_workloads,:workload_type,:person_type
    remove_column :icm_incident_workloads, :real_processing_time_t,:people_count_c,:people_count_t

  end

  def down
  end
end
