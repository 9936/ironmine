class AddColumnsToImp < ActiveRecord::Migration
  def change
    add_column :imp_incident_requests, :import_status, :string, :limit => 30, :after => :status_code
    add_column :imp_incident_journals, :import_status, :string, :limit => 30, :after => :status_code
    add_column :imp_people, :import_status, :string, :limit => 30, :after => :status_code
    add_column :imp_external_systems, :import_status, :string, :limit => 30, :after => :status_code
    add_column :imp_external_system_people, :import_status, :string, :limit => 30, :after => :status_code
    add_column :imp_groups, :import_status, :string, :limit => 30, :after => :status_code
    add_column :imp_system_groups, :import_status, :string, :limit => 30, :after => :status_code
    add_column :imp_organizations, :import_status, :string, :limit => 30, :after => :status_code

    add_column :imp_incident_requests, :import_details, :text, :after => :status_code
    add_column :imp_incident_journals, :import_details, :text, :after => :status_code
    add_column :imp_people, :import_details, :text, :after => :status_code
    add_column :imp_external_systems, :import_details, :text, :after => :status_code
    add_column :imp_external_system_people, :import_details, :text, :after => :status_code
    add_column :imp_groups, :import_details, :text, :after => :status_code
    add_column :imp_system_groups, :import_details, :text, :after => :status_code
    add_column :imp_organizations, :import_details, :text, :after => :status_code

    add_column :imp_incident_requests, :import_date, :datetime, :after => :status_code
    add_column :imp_incident_journals, :import_date, :datetime, :after => :status_code
    add_column :imp_people, :import_date, :datetime, :after => :status_code
    add_column :imp_external_systems, :import_date, :datetime, :after => :status_code
    add_column :imp_external_system_people, :import_date, :datetime, :after => :status_code
    add_column :imp_groups, :import_date, :datetime, :after => :status_code
    add_column :imp_system_groups, :import_date, :datetime, :after => :status_code
    add_column :imp_organizations, :import_date, :datetime, :after => :status_code

  end
end
