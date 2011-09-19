module Slm::ServiceCategoriesHelper
  def available_service_categories
     Slm::ServiceCategory.multilingual.collect{|i|[i.id,i[:name]]}
  end
end
