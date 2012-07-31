module Slm::ServiceCategoriesHelper
  def available_service_categories
     Slm::ServiceCategory.multilingual.collect{|i|[i[:name],i.id]}
  end
end
