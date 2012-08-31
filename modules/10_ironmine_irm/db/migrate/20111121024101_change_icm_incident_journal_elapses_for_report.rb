class ChangeIcmIncidentJournalElapsesForReport < ActiveRecord::Migration
  def up
    add_column :icm_incident_journal_elapses, "incident_status_id", :string,:limit=>22,:after=>:elapse_type, :collate=>"utf8_bin"
    add_column :icm_incident_journal_elapses, "support_group_id", :string,:limit=>22,:after=>:elapse_type, :collate=>"utf8_bin"

  end

  def down
    remove_column :icm_incident_elapses, "incident_status_id"
    remove_column :icm_incident_elapses, "support_group_id"
  end
end
