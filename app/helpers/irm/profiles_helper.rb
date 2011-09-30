module Irm::ProfilesHelper
  def grouped_functions(function_ids=nil)
    fs = Irm::Function.multilingual.enabled.with_function_group(I18n.locale).where(:public_flag=>Irm::Constant::SYS_NO,:login_flag=>Irm::Constant::SYS_NO)
    operation_unit_function_ids = Irm::OperationUnit.current.function_ids
    fs.delete_if{|i| !operation_unit_function_ids.include?(i.id) }
    if function_ids&&function_ids.is_a?(Array)
      fs.delete_if{|i| !function_ids.include?(i.id)}
    end
    fs.group_by{|i| i[:zone_code]}
  end

  def function_zones
    zone_lookup = {}
    Irm::LookupValue.query_by_lookup_type("IRM_FUNCTION_GROUP_ZONE").multilingual.order_id.each{|p|zone_lookup.merge!({p[:lookup_code]=>p[:meaning]})}

    zones = []
    Irm::FunctionGroup.all.collect{|i| i.zone_code}.uniq.each do |zone|
      if(zone_lookup[zone])
        zones<<{:code=>zone,:name=>zone_lookup[zone]}
      else
        zones<<{:code=>zone,:name=>zone}
      end
    end
    zones
  end

  def available_profile_user_license
    Irm::LookupValue.query_by_lookup_type("IRM_PROFILE_USER_LICENSE").multilingual.order_id.collect{|p| [p[:meaning],p[:lookup_code]]}
  end

  def available_profile
    Irm::Profile.multilingual.enabled.collect{|i|[i[:name],i.id]}
  end
end
