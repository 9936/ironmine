# -*- coding: utf-8 -*-
class InitReworkMenuData < ActiveRecord::Migration
  def self.up
    personal_profile= Irm::Menu.new(:code=>'PERSONAL_PROFILE',:not_auto_mult=>true)
    personal_profile.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'个人简档',:description=>'个人简档')
    personal_profile.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Personal Profile',:description=>'Personal Profile')
    personal_profile.save
    personal_setting= Irm::Menu.new(:code=>'PERSONAL_SETTING',:not_auto_mult=>true)
    personal_setting.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'个人设置',:description=>'个人设置')
    personal_setting.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Personal Setting',:description=>'Personal Setting')
    personal_setting.save
    person_info= Irm::Menu.new(:code=>'PERSON_INFO',:not_auto_mult=>true)
    person_info.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我的个人信息',:description=>'我的个人信息')
    person_info.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'My Personal Information',:description=>'My Personal Information')
    person_info.save
    global_system_setting= Irm::Menu.new(:code=>'GLOBAL_SYSTEM_SETTING',:not_auto_mult=>true)
    global_system_setting.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'设置',:description=>'设置')
    global_system_setting.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Setting',:description=>'Setting')
    global_system_setting.save
    application_setting= Irm::Menu.new(:code=>'APPLICATION_SETTING',:not_auto_mult=>true)
    application_setting.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'应用设置',:description=>'应用设置')
    application_setting.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Application Setting',:description=>'Application Setting')
    application_setting.save
    global_custom= Irm::Menu.new(:code=>'GLOBAL_CUSTOM',:not_auto_mult=>true)
    global_custom.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'自定义',:description=>'自定义')
    global_custom.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Custom',:description=>'Custom')
    global_custom.save
    global_create= Irm::Menu.new(:code=>'GLOBAL_CREATE',:not_auto_mult=>true)
    global_create.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'创建',:description=>'创建')
    global_create.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Create',:description=>'Create')
    global_create.save
    report= Irm::Menu.new(:code=>'REPORT',:not_auto_mult=>true)
    report.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表',:description=>'报表')
    report.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report',:description=>'Report')
    report.save
    security_component= Irm::Menu.new(:code=>'SECURITY_COMPONENT',:not_auto_mult=>true)
    security_component.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'安全控件',:description=>'安全控件')
    security_component.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Security Component',:description=>'Security Component')
    security_component.save
    workflow= Irm::Menu.new(:code=>'WORKFLOW',:not_auto_mult=>true)
    workflow.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'工作流',:description=>'工作流')
    workflow.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Workflow',:description=>'Workflow')
    workflow.save
    management_setting= Irm::Menu.new(:code=>'MANAGEMENT_SETTING',:not_auto_mult=>true)
    management_setting.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理设置',:description=>'管理设置')
    management_setting.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Setting Management ',:description=>'Setting Management ')
    management_setting.save
    user_management= Irm::Menu.new(:code=>'USER_MANAGEMENT',:not_auto_mult=>true)
    user_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理用户',:description=>'管理用户')
    user_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'User Management',:description=>'User Management')
    user_management.save
    organization_management= Irm::Menu.new(:code=>'ORGANIZATION_MANAGEMENT',:not_auto_mult=>true)
    organization_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'组织结构',:description=>'组织结构')
    organization_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Organization Structure',:description=>'Organization Structure')
    organization_management.save
    site_management= Irm::Menu.new(:code=>'SITE_MANAGEMENT',:not_auto_mult=>true)
    site_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'地点信息',:description=>'地点信息')
    site_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Site Information',:description=>'Site Information')
    site_management.save
    external_system_management= Irm::Menu.new(:code=>'EXTERNAL_SYSTEM_MANAGEMENT',:not_auto_mult=>true)
    external_system_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部系统',:description=>'外部系统')
    external_system_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'External System',:description=>'External System')
    external_system_management.save
    incident_management= Irm::Menu.new(:code=>'INCIDENT_MANAGEMENT',:not_auto_mult=>true)
    incident_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故管理',:description=>'事故管理')
    incident_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Incident Setting',:description=>'Incident Setting')
    incident_management.save
    service_management= Irm::Menu.new(:code=>'SERVICE_MANAGEMENT',:not_auto_mult=>true)
    service_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'服务管理',:description=>'服务管理')
    service_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Service Management',:description=>'Service Management')
    service_management.save
    knowledge_management= Irm::Menu.new(:code=>'KNOWLEDGE_MANAGEMENT',:not_auto_mult=>true)
    knowledge_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库管理',:description=>'知识库管理')
    knowledge_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Knowledge Base Setting',:description=>'Knowledge Base Setting')
    knowledge_management.save
    ldap_management= Irm::Menu.new(:code=>'LDAP_MANAGEMENT',:not_auto_mult=>true)
    ldap_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'LDAP集成',:description=>'LDAP集成')
    ldap_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Ldap Setting',:description=>'Ldap Setting')
    ldap_management.save
    mail_management= Irm::Menu.new(:code=>'MAIL_MANAGEMENT',:not_auto_mult=>true)
    mail_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'通信模板',:description=>'通信模板')
    mail_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Email Template',:description=>'Email Template')
    mail_management.save
    monitor_management= Irm::Menu.new(:code=>'MONITOR_MANAGEMENT',:not_auto_mult=>true)
    monitor_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'监控',:description=>'监控')
    monitor_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Moitor',:description=>'Moitor')
    monitor_management.save
    kanban_management= Irm::Menu.new(:code=>'KANBAN_MANAGEMENT',:not_auto_mult=>true)
    kanban_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板管理',:description=>'看板管理')
    kanban_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Signboard',:description=>'Signboard')
    kanban_management.save

    menu_entiry_3= Irm::MenuEntry.new(:menu_code=>'PERSONAL_PROFILE',:sub_menu_code=>'PERSONAL_SETTING',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_3.save
    menu_entiry_4= Irm::MenuEntry.new(:menu_code=>'PERSONAL_SETTING',:sub_menu_code=>'PERSON_INFO',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_4.save
    menu_entiry_5= Irm::MenuEntry.new(:menu_code=>'PERSON_INFO',:sub_menu_code=>nil,:sub_function_group_code=>'MY_INFO',:display_sequence=>10)
    menu_entiry_5.save
    menu_entiry_6= Irm::MenuEntry.new(:menu_code=>'PERSON_INFO',:sub_menu_code=>nil,:sub_function_group_code=>'MY_PASSWORD',:display_sequence=>20)
    menu_entiry_6.save
    menu_entiry_7= Irm::MenuEntry.new(:menu_code=>'PERSON_INFO',:sub_menu_code=>nil,:sub_function_group_code=>'MY_AVATAR',:display_sequence=>30)
    menu_entiry_7.save
    menu_entiry_8= Irm::MenuEntry.new(:menu_code=>'PERSON_INFO',:sub_menu_code=>nil,:sub_function_group_code=>'MY_LOGIN_HISTORY',:display_sequence=>40)
    menu_entiry_8.save
    menu_entiry_9= Irm::MenuEntry.new(:menu_code=>'GLOBAL_SYSTEM_SETTING',:sub_menu_code=>'APPLICATION_SETTING',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_9.save
    menu_entiry_10= Irm::MenuEntry.new(:menu_code=>'APPLICATION_SETTING',:sub_menu_code=>'GLOBAL_CUSTOM',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_10.save
    menu_entiry_11= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CUSTOM',:sub_menu_code=>nil,:sub_function_group_code=>'GLOBAL_SETTING',:display_sequence=>10)
    menu_entiry_11.save
    menu_entiry_12= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CUSTOM',:sub_menu_code=>nil,:sub_function_group_code=>'LANGUAGE',:display_sequence=>20)
    menu_entiry_12.save
    menu_entiry_13= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CUSTOM',:sub_menu_code=>nil,:sub_function_group_code=>'LOOKUP_CODE',:display_sequence=>30)
    menu_entiry_13.save
    menu_entiry_14= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CUSTOM',:sub_menu_code=>nil,:sub_function_group_code=>'GENERAL_CATEGORY',:display_sequence=>40)
    menu_entiry_14.save
    menu_entiry_15= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CUSTOM',:sub_menu_code=>nil,:sub_function_group_code=>'VALUE_SET',:display_sequence=>50)
    menu_entiry_15.save
    menu_entiry_16= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CUSTOM',:sub_menu_code=>nil,:sub_function_group_code=>'ID_FLEX',:display_sequence=>60)
    menu_entiry_16.save
    menu_entiry_17= Irm::MenuEntry.new(:menu_code=>'APPLICATION_SETTING',:sub_menu_code=>'GLOBAL_CREATE',:sub_function_group_code=>nil,:display_sequence=>20)
    menu_entiry_17.save
    menu_entiry_18= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'PRODUCT_MODULE',:display_sequence=>10)
    menu_entiry_18.save
    menu_entiry_19= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'BUSINESS_OBJECT',:display_sequence=>20)
    menu_entiry_19.save
    menu_entiry_20= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'LIST_OF_VALUE',:display_sequence=>30)
    menu_entiry_20.save
    menu_entiry_21= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>'REPORT',:sub_function_group_code=>nil,:display_sequence=>40)
    menu_entiry_21.save
    menu_entiry_22= Irm::MenuEntry.new(:menu_code=>'REPORT',:sub_menu_code=>nil,:sub_function_group_code=>'REPORT_CATEGORY',:display_sequence=>10)
    menu_entiry_22.save
    menu_entiry_23= Irm::MenuEntry.new(:menu_code=>'REPORT',:sub_menu_code=>nil,:sub_function_group_code=>'REPORT_TYPE',:display_sequence=>20)
    menu_entiry_23.save
    menu_entiry_24= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>'SECURITY_COMPONENT',:sub_function_group_code=>nil,:display_sequence=>50)
    menu_entiry_24.save
    menu_entiry_25= Irm::MenuEntry.new(:menu_code=>'SECURITY_COMPONENT',:sub_menu_code=>nil,:sub_function_group_code=>'MENU',:display_sequence=>10)
    menu_entiry_25.save
    menu_entiry_26= Irm::MenuEntry.new(:menu_code=>'SECURITY_COMPONENT',:sub_menu_code=>nil,:sub_function_group_code=>'FUNCTION_GROUP',:display_sequence=>20)
    menu_entiry_26.save
    menu_entiry_27= Irm::MenuEntry.new(:menu_code=>'SECURITY_COMPONENT',:sub_menu_code=>nil,:sub_function_group_code=>'FUNCTION',:display_sequence=>30)
    menu_entiry_27.save
    menu_entiry_28= Irm::MenuEntry.new(:menu_code=>'SECURITY_COMPONENT',:sub_menu_code=>nil,:sub_function_group_code=>'PERMISSION',:display_sequence=>40)
    menu_entiry_28.save
    menu_entiry_29= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>'WORKFLOW',:sub_function_group_code=>nil,:display_sequence=>60)
    menu_entiry_29.save
    menu_entiry_30= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_RULE',:display_sequence=>10)
    menu_entiry_30.save
    menu_entiry_31= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_PROCESS',:display_sequence=>20)
    menu_entiry_31.save
    menu_entiry_32= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_MAIL_ALERT',:display_sequence=>30)
    menu_entiry_32.save
    menu_entiry_33= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_FIELD_UPDATE',:display_sequence=>40)
    menu_entiry_33.save
    menu_entiry_34= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_SETTING',:display_sequence=>50)
    menu_entiry_34.save
    menu_entiry_35= Irm::MenuEntry.new(:menu_code=>'GLOBAL_SYSTEM_SETTING',:sub_menu_code=>'MANAGEMENT_SETTING',:sub_function_group_code=>nil,:display_sequence=>20)
    menu_entiry_35.save
    menu_entiry_36= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'USER_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_36.save
    menu_entiry_37= Irm::MenuEntry.new(:menu_code=>'USER_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'PERSON',:display_sequence=>10)
    menu_entiry_37.save
    menu_entiry_38= Irm::MenuEntry.new(:menu_code=>'USER_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ROLE',:display_sequence=>20)
    menu_entiry_38.save
    menu_entiry_39= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'ORGANIZATION_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>20)
    menu_entiry_39.save
    menu_entiry_40= Irm::MenuEntry.new(:menu_code=>'ORGANIZATION_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'COMPANY',:display_sequence=>10)
    menu_entiry_40.save
    menu_entiry_41= Irm::MenuEntry.new(:menu_code=>'ORGANIZATION_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ORGANIZATION',:display_sequence=>20)
    menu_entiry_41.save
    menu_entiry_42= Irm::MenuEntry.new(:menu_code=>'ORGANIZATION_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'DEPARTMENT',:display_sequence=>30)
    menu_entiry_42.save
    menu_entiry_43= Irm::MenuEntry.new(:menu_code=>'ORGANIZATION_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SUPPORT_GROUP',:display_sequence=>40)
    menu_entiry_43.save
    menu_entiry_44= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'SITE_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>30)
    menu_entiry_44.save
    menu_entiry_45= Irm::MenuEntry.new(:menu_code=>'SITE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'REGION',:display_sequence=>10)
    menu_entiry_45.save
    menu_entiry_46= Irm::MenuEntry.new(:menu_code=>'SITE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SITE_GROUP',:display_sequence=>20)
    menu_entiry_46.save
    menu_entiry_47= Irm::MenuEntry.new(:menu_code=>'SITE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SITE',:display_sequence=>30)
    menu_entiry_47.save
    menu_entiry_48= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>40)
    menu_entiry_48.save
    menu_entiry_49= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SYSTEM',:display_sequence=>10)
    menu_entiry_49.save
    menu_entiry_50= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'EXTERNAL_LOINGID',:display_sequence=>20)
    menu_entiry_50.save
    menu_entiry_51= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'LOGIN_MAPPING',:display_sequence=>30)
    menu_entiry_51.save
    menu_entiry_52= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'INCIDENT_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>50)
    menu_entiry_52.save
    menu_entiry_53= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_CLOSE_REASON',:display_sequence=>10)
    menu_entiry_53.save
    menu_entiry_54= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_GROUP_ASSIGN',:display_sequence=>20)
    menu_entiry_54.save
    menu_entiry_55= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_RULE_SETTING',:display_sequence=>30)
    menu_entiry_55.save
    menu_entiry_56= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_URGENCE_CODE',:display_sequence=>40)
    menu_entiry_56.save
    menu_entiry_57= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_IMPACT_RANGE',:display_sequence=>50)
    menu_entiry_57.save
    menu_entiry_58= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_PRIORITY_CODE',:display_sequence=>60)
    menu_entiry_58.save
    menu_entiry_59= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_PHASE',:display_sequence=>70)
    menu_entiry_59.save
    menu_entiry_60= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_STATUS',:display_sequence=>80)
    menu_entiry_60.save
    menu_entiry_61= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'SERVICE_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>60)
    menu_entiry_61.save
    menu_entiry_62= Irm::MenuEntry.new(:menu_code=>'SERVICE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SERVICE_CATEGORY',:display_sequence=>10)
    menu_entiry_62.save
    menu_entiry_63= Irm::MenuEntry.new(:menu_code=>'SERVICE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SERVICE_CATALOG',:display_sequence=>20)
    menu_entiry_63.save
    menu_entiry_64= Irm::MenuEntry.new(:menu_code=>'SERVICE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SERVICE_AGREEMENT',:display_sequence=>30)
    menu_entiry_64.save
    menu_entiry_65= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>70)
    menu_entiry_65.save
    menu_entiry_66= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_STATUS',:display_sequence=>10)
    menu_entiry_66.save
    menu_entiry_67= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_TEMPLATE',:display_sequence=>20)
    menu_entiry_67.save
    menu_entiry_68= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_TEMPLATE_ELEMENTS',:display_sequence=>30)
    menu_entiry_68.save
    menu_entiry_69= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'LDAP_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>80)
    menu_entiry_69.save
    menu_entiry_70= Irm::MenuEntry.new(:menu_code=>'LDAP_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'LDAP_SOURCE',:display_sequence=>10)
    menu_entiry_70.save
    menu_entiry_71= Irm::MenuEntry.new(:menu_code=>'LDAP_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'LDAP_USER',:display_sequence=>20)
    menu_entiry_71.save
    menu_entiry_72= Irm::MenuEntry.new(:menu_code=>'LDAP_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'LDAP_ORGANIZATION',:display_sequence=>30)
    menu_entiry_72.save
    menu_entiry_73= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'MAIL_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>90)
    menu_entiry_73.save
    menu_entiry_74= Irm::MenuEntry.new(:menu_code=>'MAIL_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'EMAIL_TEMPLATE',:display_sequence=>10)
    menu_entiry_74.save
    menu_entiry_75= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'MONITOR_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>100)
    menu_entiry_75.save
    menu_entiry_76= Irm::MenuEntry.new(:menu_code=>'MONITOR_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MONITOR_WORKFLOW_RULE',:display_sequence=>10)
    menu_entiry_76.save
    menu_entiry_77= Irm::MenuEntry.new(:menu_code=>'MONITOR_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MONITOR_GROUP_ASSIGN',:display_sequence=>20)
    menu_entiry_77.save
    menu_entiry_78= Irm::MenuEntry.new(:menu_code=>'MONITOR_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MONITOR_DELAYED_JOBS',:display_sequence=>30)
    menu_entiry_78.save
    menu_entiry_79= Irm::MenuEntry.new(:menu_code=>'MONITOR_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MONITOR_APPROVE_MAIL',:display_sequence=>40)
    menu_entiry_79.save
    menu_entiry_80= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'KANBAN_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>110)
    menu_entiry_80.save
    menu_entiry_81= Irm::MenuEntry.new(:menu_code=>'KANBAN_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'KANBAN',:display_sequence=>10)
    menu_entiry_81.save
    menu_entiry_82= Irm::MenuEntry.new(:menu_code=>'KANBAN_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'KANBAN_LANE',:display_sequence=>20)
    menu_entiry_82.save
    menu_entiry_83= Irm::MenuEntry.new(:menu_code=>'KANBAN_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'KANBAN_CARD',:display_sequence=>30)
    menu_entiry_83.save
  end

  def self.down
  end
end
