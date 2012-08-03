# -*- coding: utf-8 -*-
class AddConfigRelationTypeFunction < ActiveRecord::Migration
  def up
    irm_function_group_zoneconfig_management= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'CONFIG_MANAGEMENT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneconfig_management.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneconfig_management.id,:meaning=>'配置管理',:description=>'配置管理',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneconfig_management.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneconfig_management.id,:meaning=>'Configuration Management',:description=>'Configuration Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneconfig_management.save
    com_config_relation_type= Irm::FunctionGroup.new(:zone_code=>'CONFIG_MANAGEMENT',:code=>'CONFIG_RELATION_TYPE',:controller=>'com/config_relation_types',:action=>'index',:not_auto_mult=>true)
    com_config_relation_type.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'配置项关系类型',:description=>'配置项关系类型')
    com_config_relation_type.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Relation Type',:description=>'Config Relation Type')
    com_config_relation_type.save
    com_config_relation_type= Irm::Function.new(:function_group_code=>'CONFIG_RELATION_TYPE',:code=>'CONFIG_RELATION_TYPE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    com_config_relation_type.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'配置项关系类型',:description=>'配置项关系类型')
    com_config_relation_type.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Relation Type',:description=>'Config Relation Type')
    com_config_relation_type.save
    menu_entiry_125= Irm::MenuEntry.new(:menu_code=>'CONFIG_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CONFIG_RELATION_TYPE',:display_sequence=>20)
    menu_entiry_125.save
      
  end

  def down
  end
end
