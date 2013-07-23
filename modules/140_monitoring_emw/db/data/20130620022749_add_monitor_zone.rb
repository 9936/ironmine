# -*- coding: utf-8 -*-
class AddMonitorZone < ActiveRecord::Migration
  def up
    irm_function_group_zone_monitor = Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'EBS_MONITOR',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zone_monitor.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zone_monitor.id,:meaning=>'EBS 监控工作台',:description=>'EBS 监控工作台',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_monitor.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zone_monitor.id,:meaning=>'EBS Monitor Workbench',:description=>'EBS Monitor Workbench',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_monitor.save
  end
end
