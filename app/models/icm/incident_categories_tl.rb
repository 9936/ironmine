class Icm::IncidentCategoriesTl < ActiveRecord::Base
  set_table_name :icm_incident_categories_tl

  belongs_to :incident_category

  validates_presence_of :name
end
