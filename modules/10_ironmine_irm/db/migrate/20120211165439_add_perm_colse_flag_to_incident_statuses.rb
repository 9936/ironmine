class AddPermColseFlagToIncidentStatuses < ActiveRecord::Migration
  def change
    add_column :icm_incident_statuses, :permanent_close_flag, :string ,:default=>'N', :limit => 1,:collate=>"utf8_bin",:after=> :close_flag
  end
end
