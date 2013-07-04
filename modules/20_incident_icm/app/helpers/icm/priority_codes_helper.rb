module Icm::PriorityCodesHelper
  def available_priority_codes
    Irm::LookupValue.query_by_lookup_type("ICM_PRIORITY_TYPE").multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def priority_weight_value_hash
    weight_value_hash = {}
    Icm::PriorityCode.enabled.multilingual.each{|i| weight_value_hash.merge!({i.weight_values=>i})}
    weight_value_hash
  end

  def available_priorities
    Icm::PriorityCode.enabled.multilingual.order("weight_values desc").collect{|i|[i[:name], i.id]}
  end

  def priorities_name_hash
    name_hash = {}
    Icm::PriorityCode.enabled.multilingual.each{|i| name_hash.merge!({i.id => i[:name]})}
    name_hash
  end

  def available_priority_transform(sid = '')
    transform_scope = []
    if sid.present?
      transform_scope = Icm::PriorityTransform.enabled.with_sid(sid)
    end
    if transform_scope.empty? || sid.blank?
      transform_scope = Icm::PriorityTransform.enabled.with_global
    end
    pritory_transforms = {}
    transform_scope.each do |st|
      pritory_transforms[st.impact_range_id]||= {}
      pritory_transforms[st.impact_range_id].merge!({st.urgence_id => st.priority_id})
    end
    pritory_transforms
  end
end
