module Icm::PriorityCodesHelper
  def available_priority_codes
    Irm::LookupValue.query_by_lookup_type("ICM_PRIORITY_TYPE").multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def priority_weight_value_hash
    weight_value_hash = {}
    Icm::PriorityCode.enabled.multilingual.each{|i| weight_value_hash.merge!({i.weight_values=>i})}
    weight_value_hash
  end
end
