class Icm::IncidentSubCategoriesTl < ActiveRecord::Base
  set_table_name :icm_incident_sub_categories_tl

  belongs_to :incident_sub_category

  validates_presence_of :name
end
