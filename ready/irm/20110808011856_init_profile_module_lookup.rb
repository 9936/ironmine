# -*- coding: utf-8 -*-
class InitProfileModuleLookup < ActiveRecord::Migration
  def self.up
    irm_function_group_zone=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zone.lookup_types_tls.build(:lookup_type_id=>irm_function_group_zone.id,:meaning=>'功能组分区类型',:description=>'功能组分区类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone.lookup_types_tls.build(:lookup_type_id=>irm_function_group_zone.id,:meaning=>'Function Group Zone',:description=>'Function Group Zone',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone.save
    irm_profile_user_license=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PROFILE_USER_LICENSE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_profile_user_license.lookup_types_tls.build(:lookup_type_id=>irm_profile_user_license.id,:meaning=>'简档用户类型',:description=>'简档用户类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_license.lookup_types_tls.build(:lookup_type_id=>irm_profile_user_license.id,:meaning=>'Profile User License',:description=>'Profile User License',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_license.save

    irm_function_group_zonehome_page= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'HOME_PAGE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonehome_page.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonehome_page.id,:meaning=>'主页',:description=>'主页',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonehome_page.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonehome_page.id,:meaning=>'Home Page',:description=>'Home Page',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonehome_page.save
    irm_function_group_zoneincident_request= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'INCIDENT_REQUEST',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneincident_request.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneincident_request.id,:meaning=>'事故单',:description=>'事故单',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneincident_request.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneincident_request.id,:meaning=>'Incident Request',:description=>'Incident Request',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneincident_request.save
    irm_function_group_zoneknowledge_management= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'KNOWLEDGE_MANAGEMENT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneknowledge_management.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneknowledge_management.id,:meaning=>'知识库',:description=>'知识库',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneknowledge_management.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneknowledge_management.id,:meaning=>'Knowledge Management',:description=>'Knowledge Management',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneknowledge_management.save
    irm_function_group_zonecsi_survey= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'CSI_SURVEY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonecsi_survey.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonecsi_survey.id,:meaning=>'调查问卷',:description=>'调查问卷',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonecsi_survey.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonecsi_survey.id,:meaning=>'Survey',:description=>'Survey',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonecsi_survey.save
    irm_function_group_zoneirm_report= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'IRM_REPORT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneirm_report.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneirm_report.id,:meaning=>'报表',:description=>'报表',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneirm_report.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneirm_report.id,:meaning=>'Report',:description=>'Report',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneirm_report.save
    irm_function_group_zonepersonal_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'PERSONAL_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonepersonal_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonepersonal_setting.id,:meaning=>'个人设置',:description=>'个人设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonepersonal_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonepersonal_setting.id,:meaning=>'Personal Setting',:description=>'Personal Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonepersonal_setting.save
    irm_function_group_zonesystem_custom= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'SYSTEM_CUSTOM',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonesystem_custom.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonesystem_custom.id,:meaning=>'系统设置',:description=>'系统设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonesystem_custom.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonesystem_custom.id,:meaning=>'System Setting',:description=>'System Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonesystem_custom.save
    irm_function_group_zonesystem_create= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'SYSTEM_CREATE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonesystem_create.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonesystem_create.id,:meaning=>'应用创建',:description=>'应用创建',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonesystem_create.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonesystem_create.id,:meaning=>'Create Application',:description=>'Create Application',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonesystem_create.save
    irm_function_group_zonesystme_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'SYSTME_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonesystme_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonesystme_setting.id,:meaning=>'应用设置',:description=>'应用设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonesystme_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonesystme_setting.id,:meaning=>'Setup Application',:description=>'Setup Application',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonesystme_setting.save
    irm_function_group_zoneincident_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'INCIDENT_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneincident_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneincident_setting.id,:meaning=>'事故单设置',:description=>'事故单设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneincident_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneincident_setting.id,:meaning=>'Incident Request Setting',:description=>'Incident Request Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneincident_setting.save
    irm_function_group_zoneskm_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'SKM_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneskm_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneskm_setting.id,:meaning=>'知识库设置',:description=>'知识库设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneskm_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneskm_setting.id,:meaning=>'Knowledge Management Setting',:description=>'Knowledge Management Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneskm_setting.save
    irm_profile_user_licensesupporter= Irm::LookupValue.new(:lookup_type=>'IRM_PROFILE_USER_LICENSE',:lookup_code=>'SUPPORTER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_profile_user_licensesupporter.lookup_values_tls.build(:lookup_value_id=>irm_profile_user_licensesupporter.id,:meaning=>'服务台',:description=>'服务台',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_licensesupporter.lookup_values_tls.build(:lookup_value_id=>irm_profile_user_licensesupporter.id,:meaning=>'Supporter',:description=>'Supporter',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_licensesupporter.save
    irm_profile_user_licenserequester= Irm::LookupValue.new(:lookup_type=>'IRM_PROFILE_USER_LICENSE',:lookup_code=>'REQUESTER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_profile_user_licenserequester.lookup_values_tls.build(:lookup_value_id=>irm_profile_user_licenserequester.id,:meaning=>'客户',:description=>'客户',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_licenserequester.lookup_values_tls.build(:lookup_value_id=>irm_profile_user_licenserequester.id,:meaning=>'Customer',:description=>'Customer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_licenserequester.save
    
  end

  def self.down
  end
end
