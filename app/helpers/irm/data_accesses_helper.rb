# -*- coding: utf-8 -*-
module Irm::DataAccessesHelper
  def available_access_level
    lookup("IRM_DATA_ACCESS_LEVEL")
  end

  def available_accessible_bo
    [[t(:label_irm_data_access_all_business_object),nil]]+Irm::BusinessObject.multilingual.collect{|i| [i[:name],i.id]}
  end
end
