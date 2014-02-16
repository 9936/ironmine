class AddSupportPersonIdToIncidentJournalElapse < ActiveRecord::Migration
  def change
    add_column :icm_incident_journal_elapses,:support_person_id,  :string, :limit => 22, :collate=>"utf8_bin",:after=>:support_group_id
  end
end
