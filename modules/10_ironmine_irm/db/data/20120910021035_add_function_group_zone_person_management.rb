# -*- coding: utf-8 -*-
class AddFunctionGroupZonePersonManagement < ActiveRecord::Migration
  def up
    irm_function_group_zoneperson_management= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'PERSON_MANAGEMENT',:start_date_active=>'2012-09-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneperson_management.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneperson_management.id,:meaning=>'人员管理',:description=>'人员管理',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneperson_management.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneperson_management.id,:meaning=>'Person Management',:description=>'Person Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneperson_management.save
  end

  def down
  end
end
