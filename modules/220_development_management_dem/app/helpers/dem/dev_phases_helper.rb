module Dem::DevPhasesHelper
  def dem_get_phases_list
    Dem::DevPhaseTemplate.select_all.enabled.collect{|dpt| [dpt.name, dpt.id]}
  end
end
