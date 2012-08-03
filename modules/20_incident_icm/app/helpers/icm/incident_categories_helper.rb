module Icm::IncidentCategoriesHelper
  def available_incident_category
    Icm::IncidentCategory.list_all.collect{|i| [i[:name],i.id]}
  end

  def incident_sub_categories(incident_category_id)
    Icm::IncidentSubCategory.list_all.where(:incident_category_id=>incident_category_id)
  end
end
