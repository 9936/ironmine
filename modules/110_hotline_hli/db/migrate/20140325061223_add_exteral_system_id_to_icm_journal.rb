class AddExteralSystemIdToIcmJournal < ActiveRecord::Migration
  def change
    add_column :icm_incident_journals, :external_system_id, :string, :limit => 22
  end
end
