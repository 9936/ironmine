class Icm::IncidentCategorySystem < ActiveRecord::Base
  set_table_name :icm_incident_category_systems

  query_extend

  belongs_to :incident_category
  belongs_to :external_system
end
