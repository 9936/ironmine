class AddWorkloadTypeToIncidentJournal < ActiveRecord::Migration
  def change
    add_column :icm_incident_journals, :workload_type, :string, :limit => 30
  end
end
