module Icm::IncidentWorkloadsHelper
  def available_icm_workload_type
    Irm::LookupValue.query_by_lookup_type("WORKLOAD_TYPE").order("sequence ASC").multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
  end
end
