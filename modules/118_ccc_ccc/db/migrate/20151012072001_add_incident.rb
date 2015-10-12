class AddIncident < ActiveRecord::Migration
  def up
    add_column :icm_incident_requests, :project_name, :string, :limit=>200, :after => :change_requested_at
    add_column :icm_incident_requests, :component_code, :string, :limit=>200, :after => :change_requested_at
    add_column :icm_incident_requests, :submit_person, :string, :limit=>200, :after => :change_requested_at
    add_column :icm_incident_requests, :submit_department, :string, :limit=>200, :after => :change_requested_at
    add_column :icm_incident_requests, :submit_email, :string, :limit=>200, :after => :change_requested_at
    add_column :icm_incident_requests, :down_flag, :string, :limit=>200, :after => :change_requested_at
    add_column :icm_incident_requests, :update_flag, :string, :limit=>200, :after => :change_requested_at
    add_column :icm_incident_requests, :update_at, :datetime, :after => :change_requested_at
  end

  def down
  end
end
