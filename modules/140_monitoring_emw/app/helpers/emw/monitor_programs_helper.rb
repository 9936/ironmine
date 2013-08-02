module Emw::MonitorProgramsHelper
  def monitor_targets
    [[t(:label_emw_monitor_target_interface), "INTERFACE"],
     [t(:label_emw_monitor_target_database), "DATABASE"],
     [t(:label_emw_monitor_target_application), "COMPONENT"]]
  end
end
