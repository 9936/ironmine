module Chm::ChangePrioritiesHelper
  def change_priority_weight_value_hash
    weight_value_hash = {}
    Chm::ChangePriority.enabled.multilingual.each{|i| weight_value_hash.merge!({i.weight_values=>i})}
    weight_value_hash
  end
end
