module Dem::DevPhasesHelper
  def dem_get_phases_list
    Dem::DevPhaseTemplate.select_all.enabled.collect{|dpt| [dpt.name, dpt.id]}
  end

  def dem_get_difficulty_list
    Irm::LookupValue.
        get_lookup_value("DEM_DIFFICULTY").
        enabled.
        collect{|lv| [lv[:meaning], lv[:lookup_code]]}
  end

  def dem_get_module_list
    Irm::LookupValue.
        get_lookup_value("DEM_MODULE").
        enabled.
        collect{|lv| [lv[:meaning], lv[:lookup_code]]}
  end

  def dem_get_method_list
    Irm::LookupValue.
        get_lookup_value("DEM_DEVELOP_METHOD").
        enabled.
        collect{|lv| [lv[:meaning], lv[:lookup_code]]}
  end

  def dem_get_phase_status_list
    Irm::LookupValue.
        get_lookup_value("DEM_PHASE_STATUS").
        enabled.
        collect{|lv| [lv[:meaning], lv[:lookup_code]]}
  end
end
