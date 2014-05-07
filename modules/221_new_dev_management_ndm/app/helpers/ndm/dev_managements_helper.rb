module Ndm::DevManagementsHelper
  def ndm_get_priority_list
    #Irm::LookupValue.
    #    get_lookup_value("DEM_PHASE_STATUS").
    #    enabled.
    #    collect{|lv| [lv[:meaning], lv[:lookup_code]]}
    [['H','NDM_PRIORITY_H'],['N','NDM_PRIORITY_N']]
  end

  def ndm_get_dev_type_list
    [['NEW','NDM_TYPE_NEW'],['UPDATE','NDM_TYPE_UPDATE']]
  end
end
