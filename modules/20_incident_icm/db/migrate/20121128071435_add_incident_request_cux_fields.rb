class AddIncidentRequestCuxFields < ActiveRecord::Migration
  def up
    add_column :icm_incident_requests, :sattribute10, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :sattribute9, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :sattribute8, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :sattribute7, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :sattribute6, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :sattribute5, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :sattribute4, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :sattribute3, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :sattribute2, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :sattribute1, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute10, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute9, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute8, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute7, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute6, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute5, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute4, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute3, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute2, :string, :after => :opu_id, :limit => 240
    add_column :icm_incident_requests, :attribute1, :string, :after => :opu_id, :limit => 240

  end

  def down
  end
end
