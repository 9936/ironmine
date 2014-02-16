class AddElapseFlagToIncidentStatuses < ActiveRecord::Migration
  def change
    add_column :icm_incident_statuses, :elapse_flag, :string ,:default=>'N', :limit => 1,:collate=>"utf8_bin",:after=> :permanent_close_flag
  end
end
