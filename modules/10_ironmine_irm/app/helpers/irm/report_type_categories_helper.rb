module Irm::ReportTypeCategoriesHelper
  def available_report_type_category
    Irm::ReportTypeCategory.multilingual.collect{|i|[i[:name],i.id]}
  end
end
