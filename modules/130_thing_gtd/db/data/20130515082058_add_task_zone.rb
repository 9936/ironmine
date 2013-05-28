# -*- coding: utf-8 -*-
class AddTaskZone < ActiveRecord::Migration
  def up
    irm_function_group_zone_task = Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'TASK',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zone_task.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zone_task.id,:meaning=>'任务',:description=>'任务',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_task.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zone_task.id,:meaning=>'Task',:description=>'Task',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone_task.save
  end

  def down
  end
end
