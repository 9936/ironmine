class AddIncidentCategoryIdToRequests < ActiveRecord::Migration
  def up
    add_column :icm_incident_requests,:incident_sub_category_id,:string,:limit => 22, :collate=>"utf8_bin",:after=>:service_code
    add_column :icm_incident_requests,:incident_category_id,:string,:limit => 22, :collate=>"utf8_bin",:after=>:service_code
  end

  def down
    add_column :icm_incident_requests,:incident_sub_category_id,:string,:limit => 22, :collate=>"utf8_bin",:after=>:service_code
    add_column :icm_incident_requests,:incident_category_id,:string,:limit => 22, :collate=>"utf8_bin",:after=>:service_code
  end
end
