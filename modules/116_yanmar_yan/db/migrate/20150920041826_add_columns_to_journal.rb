class AddColumnsToJournal < ActiveRecord::Migration
  def change
    add_column :icm_incident_journals, :people_count_c, :integer, :after => :message_body
    add_column :icm_incident_journals, :workload_c, :integer, :limit => 11, :after => :message_body
    add_column :icm_incident_journals, :people_count_t, :integer, :after => :message_body
    add_column :icm_incident_journals, :workload_t, :integer, :limit => 11, :after => :message_body
  end
end
