# -*- coding: utf-8 -*-
class AddFunctionGroupZoneDevelopSetting < ActiveRecord::Migration
  def up
    irm_function_group_zonedevelopment_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'DEVELOPMENT_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonedevelopment_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonedevelopment_setting.id,:meaning=>'开发设置',:description=>'开发设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonedevelopment_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonedevelopment_setting.id,:meaning=>'Development Setting',:description=>'Development Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonedevelopment_setting.save

  end

  def down
  end
end
