# -*- coding: utf-8 -*-
class AddSomFunctionGroupZoneCode < ActiveRecord::Migration
  def up
    irm_function_group_zone_sales = Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'SALES',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zone_sales.lookup_values_tls.build(:meaning=>'销售信息管理',:description=>'销售信息管理',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_sales.lookup_values_tls.build(:meaning=>'Sales Opportunity',:description=>'Sales Opportunity',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_sales.save
  end

  def down
  end
end
