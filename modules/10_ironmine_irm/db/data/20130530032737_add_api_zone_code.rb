class AddApiZoneCode < ActiveRecord::Migration
  def change
    irm_function_group_zone_api = Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'API',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zone_api.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zone_api.id,:meaning=>'API',:description=>'API',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_api.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zone_api.id,:meaning=>'API',:description=>'API',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_api.save
  end
end
