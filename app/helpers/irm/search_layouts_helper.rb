module Irm::SearchLayoutsHelper
  def available_business_object_search_layout_types
    Irm::LookupValue.get_lookup_value("IRM_BO_SEARCH_LAYOUT").collect{|i| [i[:meaning],i.lookup_code]}
  end

  def available_search_layouts(business_object_id)
    Irm::SearchLayout.select_all.with_code(I18n.locale).where(:business_object_id=>business_object_id)
  end
end
