class AddJournalIdColumnToWorkload < ActiveRecord::Migration
  def change
      add_column :icm_incident_workloads, :incident_journal_id, :string, :limit => 22, :after => :opu_id
  end
end
