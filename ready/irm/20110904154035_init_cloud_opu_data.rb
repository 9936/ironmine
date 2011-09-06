# -*- coding: utf-8 -*-
class InitCloudOpuData < ActiveRecord::Migration
  def self.up
    irm_license= Irm::FunctionGroup.new(:zone_code=>'CLOUD_SETTING',:code=>'LICENSE',:controller=>'irm/licenses',:action=>'index',:not_auto_mult=>true)
    irm_license.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'运维中心License',:description=>'运维中心License')
    irm_license.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Operation License',:description=>'Operation License')
    irm_license.save
    irm_cloud_operation= Irm::FunctionGroup.new(:zone_code=>'CLOUD_SETTING',:code=>'CLOUD_OPERATION',:controller=>'irm/cloud_operations',:action=>'index',:not_auto_mult=>true)
    irm_cloud_operation.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'云运维中心',:description=>'云运维中心')
    irm_cloud_operation.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Cloud Operation Unit',:description=>'Cloud Operation Unit')
    irm_cloud_operation.save
    irm_license= Irm::Function.new(:function_group_code=>'LICENSE',:code=>'LICENSE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_license.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'运维中心License',:description=>'运维中心License')
    irm_license.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Operation License',:description=>'Operation License')
    irm_license.save
    irm_cloud_operation= Irm::Function.new(:function_group_code=>'CLOUD_OPERATION',:code=>'CLOUD_OPERATION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_cloud_operation.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'云运维中心',:description=>'云运维中心')
    irm_cloud_operation.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Cloud Operation Unit',:description=>'Cloud Operation Unit')
    irm_cloud_operation.save

    cloud_manage= Irm::Menu.new(:code=>'CLOUD_MANAGE',:not_auto_mult=>true)
    cloud_manage.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Cloud管理',:description=>'Cloud管理')
    cloud_manage.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Cloud Management',:description=>'Cloud Management')
    cloud_manage.save
    cloud_operation_setting= Irm::Menu.new(:code=>'CLOUD_OPERATION_SETTING',:not_auto_mult=>true)
    cloud_operation_setting.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'运维中心设置',:description=>'运维中心设置')
    cloud_operation_setting.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Operation Unit ',:description=>'Operation Unit ')
    cloud_operation_setting.save

    menu_entiry_96= Irm::MenuEntry.new(:menu_code=>'GLOBAL_SYSTEM_SETTING',:sub_menu_code=>'CLOUD_MANAGE',:sub_function_group_code=>nil,:display_sequence=>30)
    menu_entiry_96.save
    menu_entiry_97= Irm::MenuEntry.new(:menu_code=>'CLOUD_MANAGE',:sub_menu_code=>'CLOUD_OPERATION_SETTING',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_97.save
    menu_entiry_98= Irm::MenuEntry.new(:menu_code=>'CLOUD_OPERATION_SETTING',:sub_menu_code=>nil,:sub_function_group_code=>'LICENSE',:display_sequence=>10)
    menu_entiry_98.save
    menu_entiry_99= Irm::MenuEntry.new(:menu_code=>'CLOUD_OPERATION_SETTING',:sub_menu_code=>nil,:sub_function_group_code=>'CLOUD_OPERATION',:display_sequence=>20)
    menu_entiry_99.save

    irm_function_group_zonecloud_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'CLOUD_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonecloud_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonecloud_setting.id,:meaning=>'Cloud设置',:description=>'Cloud设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonecloud_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonecloud_setting.id,:meaning=>'Cloud Setting',:description=>'Cloud Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonecloud_setting.save
  end

  def self.down
  end
end
