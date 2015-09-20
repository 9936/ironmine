class AddColumnsToJournal < ActiveRecord::Migration
  def change
    add_column :icm_incident_journals, :people_count_c, :integer, :default => 0, :after => :message_body
    add_column :icm_incident_journals, :workload_c, :float, :default => 0, :limit => 11, :after => :message_body
    add_column :icm_incident_journals, :people_count_t, :integer, :default => 0, :after => :message_body
    add_column :icm_incident_journals, :workload_t, :float, :default => 0, :limit => 11, :after => :message_body
  end
end
