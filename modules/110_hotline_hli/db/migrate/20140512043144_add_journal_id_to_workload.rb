class AddJournalIdToWorkload < ActiveRecord::Migration
  def change
    add_column :icm_incident_journals, :workload,  :string, :limit => 5, :after => :opu_id, :default => '0'
  end
end
