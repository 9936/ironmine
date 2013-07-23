module Emw::EbsModulesHelper
  def available_module_status
    [[t(:label_emw_ebs_module_status_enabled), "ENABLED"],
    [t(:label_emw_ebs_module_status_disabled), "DISABLED"]]
  end
end
