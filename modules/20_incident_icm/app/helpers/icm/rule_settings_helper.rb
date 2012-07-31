module Icm::RuleSettingsHelper
  def available_processes
    Irm::LookupValue.query_by_lookup_type("ICM_ASSIGN_PROCESS_TYPE").multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
  end
end
