class AddKbFlagToIncidentRequest < ActiveRecord::Migration
  def up
    add_column :icm_incident_requests, :kb_flag, :string, :limit => 1, :default => 'N', :null => false, :after => :submitted_date
  end

  def down
    remove_column :icm_incident_requests, :kb_flag
  end
end
