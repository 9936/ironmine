# -*- coding: utf-8 -*-
class InitReworkedFunctionData < ActiveRecord::Migration
  def self.up
    irm_home_page= Irm::FunctionGroup.new(:zone_code=>'HOME_PAGE',:code=>'HOME_PAGE',:controller=>'irm/home',:action=>'index',:not_auto_mult=>true)
    irm_home_page.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'系统主页',:description=>'系统主页')
    irm_home_page.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Home Page',:description=>'Home Page')
    irm_home_page.save
    icm_incident_request= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_REQUEST',:code=>'INCIDENT_REQUEST',:controller=>'icm/incident_requests',:action=>'index',:not_auto_mult=>true)
    icm_incident_request.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单',:description=>'事故单')
    icm_incident_request.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Incident Request',:description=>'Incident Request')
    icm_incident_request.save
    skm_knowledge_management= Irm::FunctionGroup.new(:zone_code=>'KNOWLEDGE_MANAGEMENT',:code=>'KNOWLEDGE_MANAGEMENT',:controller=>'skm/entry_headers',:action=>'index',:not_auto_mult=>true)
    skm_knowledge_management.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库',:description=>'知识库')
    skm_knowledge_management.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Knowledge Management',:description=>'Knowledge Management')
    skm_knowledge_management.save
    csi_csi_survey= Irm::FunctionGroup.new(:zone_code=>'CSI_SURVEY',:code=>'CSI_SURVEY',:controller=>'csi/surveys',:action=>'index',:not_auto_mult=>true)
    csi_csi_survey.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'调查问卷',:description=>'调查问卷')
    csi_csi_survey.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Survey',:description=>'Survey')
    csi_csi_survey.save
    irm_irm_report= Irm::FunctionGroup.new(:zone_code=>'IRM_REPORT',:code=>'IRM_REPORT',:controller=>'irm/reports',:action=>'index',:not_auto_mult=>true)
    irm_irm_report.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表',:description=>'报表')
    irm_irm_report.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report',:description=>'Report')
    irm_irm_report.save
    irm_my_info= Irm::FunctionGroup.new(:zone_code=>'PERSONAL_SETTING',:code=>'MY_INFO',:controller=>'irm/my_info',:action=>'index',:not_auto_mult=>true)
    irm_my_info.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'个人信息',:description=>'个人信息')
    irm_my_info.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Personal Info',:description=>'Personal Info')
    irm_my_info.save
    irm_my_password= Irm::FunctionGroup.new(:zone_code=>'PERSONAL_SETTING',:code=>'MY_PASSWORD',:controller=>'irm/my_password',:action=>'index',:not_auto_mult=>true)
    irm_my_password.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'修改我的密码',:description=>'修改我的密码')
    irm_my_password.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Password',:description=>'Change Password')
    irm_my_password.save
    irm_my_avatar= Irm::FunctionGroup.new(:zone_code=>'PERSONAL_SETTING',:code=>'MY_AVATAR',:controller=>'irm/my_avatar',:action=>'index',:not_auto_mult=>true)
    irm_my_avatar.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'修改我的头像',:description=>'修改我的头像')
    irm_my_avatar.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Avatar',:description=>'Change Avatar')
    irm_my_avatar.save
    irm_my_login_history= Irm::FunctionGroup.new(:zone_code=>'PERSONAL_SETTING',:code=>'MY_LOGIN_HISTORY',:controller=>'irm/my_login_history',:action=>'index',:not_auto_mult=>true)
    irm_my_login_history.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我的登录历史',:description=>'我的登录历史')
    irm_my_login_history.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Login Records',:description=>'Login Records')
    irm_my_login_history.save
    irm_global_setting= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CUSTOM',:code=>'GLOBAL_SETTING',:controller=>'irm/global_settings',:action=>'index',:not_auto_mult=>true)
    irm_global_setting.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'全局设置',:description=>'全局设置')
    irm_global_setting.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Global Setting',:description=>'Global Setting')
    irm_global_setting.save
    irm_language= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CUSTOM',:code=>'LANGUAGE',:controller=>'irm/languages',:action=>'index',:not_auto_mult=>true)
    irm_language.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'语言',:description=>'语言')
    irm_language.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Language',:description=>'Language')
    irm_language.save
    irm_lookup_code= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CUSTOM',:code=>'LOOKUP_CODE',:controller=>'irm/lookup_types',:action=>'index',:not_auto_mult=>true)
    irm_lookup_code.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'快速编码',:description=>'快速编码')
    irm_lookup_code.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Lookup Code',:description=>'Lookup Code')
    irm_lookup_code.save
    irm_general_category= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CUSTOM',:code=>'GENERAL_CATEGORY',:controller=>'irm/general_categories',:action=>'index',:not_auto_mult=>true)
    irm_general_category.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公共分类',:description=>'公共分类')
    irm_general_category.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'General Category',:description=>'General Category')
    irm_general_category.save
    irm_value_set= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CUSTOM',:code=>'VALUE_SET',:controller=>'irm/flex_value_sets',:action=>'index',:not_auto_mult=>true)
    irm_value_set.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'值集定义',:description=>'值集定义')
    irm_value_set.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Value Set',:description=>'Value Set')
    irm_value_set.save
    irm_id_flex= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CUSTOM',:code=>'ID_FLEX',:controller=>'irm/id_flexes',:action=>'index',:not_auto_mult=>true)
    irm_id_flex.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'弹性域',:description=>'弹性域')
    irm_id_flex.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Flex Field',:description=>'Flex Field')
    irm_id_flex.save
    irm_product_module= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'PRODUCT_MODULE',:controller=>'irm/product_modules',:action=>'index',:not_auto_mult=>true)
    irm_product_module.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'产品模块',:description=>'产品模块')
    irm_product_module.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Product Module',:description=>'Product Module')
    irm_product_module.save
    irm_business_object= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'BUSINESS_OBJECT',:controller=>'irm/business_objects',:action=>'index',:not_auto_mult=>true)
    irm_business_object.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'业务对像',:description=>'业务对像')
    irm_business_object.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Business Object',:description=>'Business Object')
    irm_business_object.save
    irm_list_of_value= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'LIST_OF_VALUE',:controller=>'irm/list_of_values',:action=>'index',:not_auto_mult=>true)
    irm_list_of_value.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'值列表',:description=>'值列表')
    irm_list_of_value.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'List of Value',:description=>'List of Value')
    irm_list_of_value.save
    irm_report_category= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'REPORT_CATEGORY',:controller=>'irm/report_categories',:action=>'index',:not_auto_mult=>true)
    irm_report_category.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类别',:description=>'报表类别')
    irm_report_category.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Category',:description=>'Report Category')
    irm_report_category.save
    irm_report_type= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'REPORT_TYPE',:controller=>'irm/report_types',:action=>'index',:not_auto_mult=>true)
    irm_report_type.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类型',:description=>'报表类型')
    irm_report_type.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Type',:description=>'Report Type')
    irm_report_type.save
    irm_menu= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'MENU',:controller=>'irm/menus',:action=>'index',:not_auto_mult=>true)
    irm_menu.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'菜单',:description=>'菜单')
    irm_menu.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Menu',:description=>'Menu')
    irm_menu.save
    irm_function_group= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'FUNCTION_GROUP',:controller=>'irm/function_groups',:action=>'index',:not_auto_mult=>true)
    irm_function_group.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'功能组',:description=>'功能组')
    irm_function_group.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Function Group',:description=>'Function Group')
    irm_function_group.save
    irm_function= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'FUNCTION',:controller=>'irm/functions',:action=>'index',:not_auto_mult=>true)
    irm_function.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'功能',:description=>'功能')
    irm_function.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Function',:description=>'Function')
    irm_function.save
    irm_permission= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'PERMISSION',:controller=>'irm/permissions',:action=>'index',:not_auto_mult=>true)
    irm_permission.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'权限',:description=>'权限')
    irm_permission.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Permission',:description=>'Permission')
    irm_permission.save
    irm_workflow_rule= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'WORKFLOW_RULE',:controller=>'irm/wf_rules',:action=>'index',:not_auto_mult=>true)
    irm_workflow_rule.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'工作流规则',:description=>'工作流规则')
    irm_workflow_rule.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Workflow Rule',:description=>'Workflow Rule')
    irm_workflow_rule.save
    irm_workflow_process= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'WORKFLOW_PROCESS',:controller=>'irm/wf_approval_processes',:action=>'index',:not_auto_mult=>true)
    irm_workflow_process.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批流程',:description=>'审批流程')
    irm_workflow_process.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Workflow Process',:description=>'Workflow Process')
    irm_workflow_process.save
    irm_workflow_mail_alert= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'WORKFLOW_MAIL_ALERT',:controller=>'irm/wf_mail_alerts',:action=>'index',:not_auto_mult=>true)
    irm_workflow_mail_alert.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'邮件警告',:description=>'邮件警告')
    irm_workflow_mail_alert.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Mail Alert',:description=>'Mail Alert')
    irm_workflow_mail_alert.save
    irm_workflow_field_update= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'WORKFLOW_FIELD_UPDATE',:controller=>'irm/wf_field_updates',:action=>'index',:not_auto_mult=>true)
    irm_workflow_field_update.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'字段更新',:description=>'字段更新')
    irm_workflow_field_update.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Field Update',:description=>'Field Update')
    irm_workflow_field_update.save
    irm_workflow_setting= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'WORKFLOW_SETTING',:controller=>'irm/wf_settings',:action=>'index',:not_auto_mult=>true)
    irm_workflow_setting.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'工作流设置',:description=>'工作流设置')
    irm_workflow_setting.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Workflow Setting',:description=>'Workflow Setting')
    irm_workflow_setting.save
    irm_person= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'PERSON',:controller=>'irm/people',:action=>'index',:not_auto_mult=>true)
    irm_person.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'用户',:description=>'用户')
    irm_person.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'User',:description=>'User')
    irm_person.save
    irm_role= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'ROLE',:controller=>'irm/roles',:action=>'index',:not_auto_mult=>true)
    irm_role.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'角色',:description=>'角色')
    irm_role.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Role',:description=>'Role')
    irm_role.save
    irm_company= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'COMPANY',:controller=>'irm/companies',:action=>'index',:not_auto_mult=>true)
    irm_company.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公司',:description=>'公司')
    irm_company.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Company',:description=>'Company')
    irm_company.save
    irm_organization= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'ORGANIZATION',:controller=>'irm/organizations',:action=>'index',:not_auto_mult=>true)
    irm_organization.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'组织',:description=>'组织')
    irm_organization.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Organization',:description=>'Organization')
    irm_organization.save
    irm_department= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'DEPARTMENT',:controller=>'irm/departments',:action=>'index',:not_auto_mult=>true)
    irm_department.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'部门',:description=>'部门')
    irm_department.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Department',:description=>'Department')
    irm_department.save
    irm_support_group= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'SUPPORT_GROUP',:controller=>'irm/support_groups',:action=>'index',:not_auto_mult=>true)
    irm_support_group.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'支持组',:description=>'支持组')
    irm_support_group.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Support Group',:description=>'Support Group')
    irm_support_group.save
    irm_region= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'REGION',:controller=>'irm/regions',:action=>'index',:not_auto_mult=>true)
    irm_region.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'区域',:description=>'区域')
    irm_region.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Region',:description=>'Region')
    irm_region.save
    irm_site_group= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'SITE_GROUP',:controller=>'irm/site_groups',:action=>'index',:not_auto_mult=>true)
    irm_site_group.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'地点组',:description=>'地点组')
    irm_site_group.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Site Group',:description=>'Site Group')
    irm_site_group.save
    irm_site= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'SITE',:controller=>'irm/sites',:action=>'index',:not_auto_mult=>true)
    irm_site.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'地点',:description=>'地点')
    irm_site.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Site',:description=>'Site')
    irm_site.save
    irm_system= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'SYSTEM',:controller=>'uid/external_systems',:action=>'index',:not_auto_mult=>true)
    irm_system.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部系统',:description=>'外部系统')
    irm_system.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'External System',:description=>'External System')
    irm_system.save
    irm_external_loingid= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'EXTERNAL_LOINGID',:controller=>'uid/external_logins',:action=>'index',:not_auto_mult=>true)
    irm_external_loingid.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部LoginID',:description=>'外部LoginID')
    irm_external_loingid.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'External LoginID',:description=>'External LoginID')
    irm_external_loingid.save
    irm_login_mapping= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'LOGIN_MAPPING',:controller=>'uid/login_mappings',:action=>'index',:not_auto_mult=>true)
    irm_login_mapping.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'用户&外部用户映射',:description=>'用户&外部用户映射')
    irm_login_mapping.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'LoginID Mapping',:description=>'LoginID Mapping')
    irm_login_mapping.save
    icm_icm_close_reason= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_CLOSE_REASON',:controller=>'icm/close_reasons',:action=>'index',:not_auto_mult=>true)
    icm_icm_close_reason.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单关闭原因',:description=>'事故单关闭原因')
    icm_icm_close_reason.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Incident Close Reason',:description=>'Incident Close Reason')
    icm_icm_close_reason.save
    icm_icm_group_assign= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_GROUP_ASSIGN',:controller=>'icm/group_assignments',:action=>'index',:not_auto_mult=>true)
    icm_icm_group_assign.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单组指派',:description=>'事故单组指派')
    icm_icm_group_assign.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Group Assign',:description=>'Group Assign')
    icm_icm_group_assign.save
    icm_icm_rule_setting= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_RULE_SETTING',:controller=>'icm/rule_settings',:action=>'index',:not_auto_mult=>true)
    icm_icm_rule_setting.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单规则设置',:description=>'事故单规则设置')
    icm_icm_rule_setting.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Rule Setting',:description=>'Rule Setting')
    icm_icm_rule_setting.save
    icm_icm_urgence_code= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_URGENCE_CODE',:controller=>'icm/urgence_codes',:action=>'index',:not_auto_mult=>true)
    icm_icm_urgence_code.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单紧急度',:description=>'事故单紧急度')
    icm_icm_urgence_code.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Urgency',:description=>'Urgency')
    icm_icm_urgence_code.save
    icm_icm_impact_range= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_IMPACT_RANGE',:controller=>'icm/impact_ranges',:action=>'index',:not_auto_mult=>true)
    icm_icm_impact_range.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单影响度',:description=>'事故单影响度')
    icm_icm_impact_range.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Impact Range',:description=>'Impact Range')
    icm_icm_impact_range.save
    icm_icm_priority_code= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_PRIORITY_CODE',:controller=>'icm/priority_codes',:action=>'index',:not_auto_mult=>true)
    icm_icm_priority_code.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单优先级',:description=>'事故单优先级')
    icm_icm_priority_code.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Priority',:description=>'Priority')
    icm_icm_priority_code.save
    icm_icm_phase= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_PHASE',:controller=>'icm/incident_phases',:action=>'index',:not_auto_mult=>true)
    icm_icm_phase.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单阶段',:description=>'事故单阶段')
    icm_icm_phase.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Phase',:description=>'Phase')
    icm_icm_phase.save
    icm_icm_status= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_STATUS',:controller=>'icm/incident_status',:action=>'index',:not_auto_mult=>true)
    icm_icm_status.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单状态',:description=>'事故单状态')
    icm_icm_status.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Status',:description=>'Status')
    icm_icm_status.save
    irm_service_category= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'SERVICE_CATEGORY',:controller=>'slm/service_categories',:action=>'index',:not_auto_mult=>true)
    irm_service_category.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'服务类别',:description=>'服务类别')
    irm_service_category.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Category',:description=>'Category')
    irm_service_category.save
    irm_service_catalog= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'SERVICE_CATALOG',:controller=>'slm/service_catalogs',:action=>'index',:not_auto_mult=>true)
    irm_service_catalog.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'服务目录',:description=>'服务目录')
    irm_service_catalog.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Catalog',:description=>'Catalog')
    irm_service_catalog.save
    irm_service_agreement= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'SERVICE_AGREEMENT',:controller=>'slm/service_agreements',:action=>'index',:not_auto_mult=>true)
    irm_service_agreement.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'服务协议',:description=>'服务协议')
    irm_service_agreement.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Argeement',:description=>'Argeement')
    irm_service_agreement.save
    skm_skm_status= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_STATUS',:controller=>'skm/entry_status',:action=>'index',:not_auto_mult=>true)
    skm_skm_status.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库状态',:description=>'知识库状态')
    skm_skm_status.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Status',:description=>'Status')
    skm_skm_status.save
    skm_skm_template= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_TEMPLATE',:controller=>'skm/entry_templates',:action=>'index',:not_auto_mult=>true)
    skm_skm_template.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库模板',:description=>'知识库模板')
    skm_skm_template.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Template',:description=>'Template')
    skm_skm_template.save
    skm_skm_template_elements= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_TEMPLATE_ELEMENTS',:controller=>'skm/entry_template_elements',:action=>'index',:not_auto_mult=>true)
    skm_skm_template_elements.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库模板元素',:description=>'知识库模板元素')
    skm_skm_template_elements.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Template Element',:description=>'Template Element')
    skm_skm_template_elements.save
    irm_ldap_source= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'LDAP_SOURCE',:controller=>'irm/ldap_sources',:action=>'index',:not_auto_mult=>true)
    irm_ldap_source.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'LDAP源',:description=>'LDAP源')
    irm_ldap_source.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'LDAP Source',:description=>'LDAP Source')
    irm_ldap_source.save
    irm_ldap_user= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'LDAP_USER',:controller=>'irm/ldap_auth_headers',:action=>'index',:not_auto_mult=>true)
    irm_ldap_user.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'LDAP用户',:description=>'LDAP用户')
    irm_ldap_user.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'LDAP User',:description=>'LDAP User')
    irm_ldap_user.save
    irm_ldap_organization= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'LDAP_ORGANIZATION',:controller=>'irm/ldap_syn_headers',:action=>'index',:not_auto_mult=>true)
    irm_ldap_organization.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'LDAP组织',:description=>'LDAP组织')
    irm_ldap_organization.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'LDAP Organization',:description=>'LDAP Organization')
    irm_ldap_organization.save
    irm_email_template= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'EMAIL_TEMPLATE',:controller=>'irm/mail_templates',:action=>'index',:not_auto_mult=>true)
    irm_email_template.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'邮件模板',:description=>'邮件模板')
    irm_email_template.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Email Template',:description=>'Email Template')
    irm_email_template.save
    irm_monitor_workflow_rule= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'MONITOR_WORKFLOW_RULE',:controller=>'irm/monitor_icm_group_assigns',:action=>'index',:not_auto_mult=>true)
    irm_monitor_workflow_rule.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单工作流规则作业',:description=>'事故单工作流规则作业')
    irm_monitor_workflow_rule.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor Workflow Rule',:description=>'Monitor Workflow Rule')
    irm_monitor_workflow_rule.save
    irm_monitor_group_assign= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'MONITOR_GROUP_ASSIGN',:controller=>'irm/monitor_ir_rule_processes',:action=>'index',:not_auto_mult=>true)
    irm_monitor_group_assign.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单组指派作业',:description=>'事故单组指派作业')
    irm_monitor_group_assign.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor Group Assign',:description=>'Monitor Group Assign')
    irm_monitor_group_assign.save
    irm_monitor_delayed_jobs= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'MONITOR_DELAYED_JOBS',:controller=>'irm/delayed_jobs',:action=>'index',:not_auto_mult=>true)
    irm_monitor_delayed_jobs.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Delayed Job运行记录',:description=>'Delayed Job运行记录')
    irm_monitor_delayed_jobs.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor Delayed Jobs',:description=>'Monitor Delayed Jobs')
    irm_monitor_delayed_jobs.save
    irm_monitor_approve_mail= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'MONITOR_APPROVE_MAIL',:controller=>'irm/monitor_approval_mails',:action=>'index',:not_auto_mult=>true)
    irm_monitor_approve_mail.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批邮件发送作业',:description=>'审批邮件发送作业')
    irm_monitor_approve_mail.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor Approve Mail',:description=>'Monitor Approve Mail')
    irm_monitor_approve_mail.save
    irm_kanban= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'KANBAN',:controller=>'irm/kanbans',:action=>'index',:not_auto_mult=>true)
    irm_kanban.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板',:description=>'看板')
    irm_kanban.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Signboard',:description=>'Signboard')
    irm_kanban.save
    irm_kanban_lane= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'KANBAN_LANE',:controller=>'irm/lanes',:action=>'index',:not_auto_mult=>true)
    irm_kanban_lane.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板泳道',:description=>'看板泳道')
    irm_kanban_lane.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Lane',:description=>'Lane')
    irm_kanban_lane.save
    irm_kanban_card= Irm::FunctionGroup.new(:zone_code=>'SYSTME_SETTING',:code=>'KANBAN_CARD',:controller=>'irm/cards',:action=>'index',:not_auto_mult=>true)
    irm_kanban_card.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板卡片',:description=>'看板卡片')
    irm_kanban_card.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Card',:description=>'Card')
    irm_kanban_card.save

    irm_public_function= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'PUBLIC_FUNCTION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'Y',:not_auto_mult=>true)
    irm_public_function.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公开功能',:description=>'公开功能')
    irm_public_function.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Public Function',:description=>'Public Function')
    irm_public_function.save
    irm_login_function= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'LOGIN_FUNCTION',:default_flag=>'N',:login_flag => 'Y', :public_flag=>'N',:not_auto_mult=>true)
    irm_login_function.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'登录可访问功能',:description=>'登录可访问功能')
    irm_login_function.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Login Accessage Function',:description=>'Login Accessage Function')
    irm_login_function.save
    irm_home_page= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'HOME_PAGE',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_home_page.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'首页',:description=>'首页')
    irm_home_page.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Home page',:description=>'Home page')
    irm_home_page.save
    icm_view_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'VIEW_INCIDENT_REQUEST',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_view_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看',:description=>'查看')
    icm_view_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View',:description=>'View')
    icm_view_incident_request.save
    icm_view_all_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'VIEW_ALL_INCIDENT_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_view_all_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看所有',:description=>'查看所有')
    icm_view_all_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View ALL',:description=>'View ALL')
    icm_view_all_incident_request.save
    icm_reply_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'REPLY_INCIDENT_REQUEST',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_reply_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'回复',:description=>'回复')
    icm_reply_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Reply',:description=>'Reply')
    icm_reply_incident_request.save
    icm_pass_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'PASS_INCIDENT_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_pass_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'转交',:description=>'转交')
    icm_pass_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Pass',:description=>'Pass')
    icm_pass_incident_request.save
    icm_edit_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'EDIT_INCIDENT_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_edit_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑',:description=>'编辑')
    icm_edit_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit',:description=>'Edit')
    icm_edit_incident_request.save
    icm_create_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'CREATE_INCIDENT_REQUEST',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_create_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建',:description=>'新建')
    icm_create_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New',:description=>'New')
    icm_create_incident_request.save
    icm_create_icdt_rqst_for_other= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'CREATE_ICDT_RQST_FOR_OTHER',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_create_icdt_rqst_for_other.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'为他人提单',:description=>'为他人提单')
    icm_create_icdt_rqst_for_other.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Summbit for other',:description=>'Summbit for other')
    icm_create_icdt_rqst_for_other.save
    icm_close_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'CLOSE_INCIDENT_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_close_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'关闭',:description=>'关闭')
    icm_close_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Close',:description=>'Close')
    icm_close_incident_request.save
    icm_assign_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'ASSIGN_INCIDENT_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_assign_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'分配',:description=>'分配')
    icm_assign_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Assign',:description=>'Assign')
    icm_assign_incident_request.save
    skm_view_skm_entries= Irm::Function.new(:function_group_code=>'KNOWLEDGE_MANAGEMENT',:code=>'VIEW_SKM_ENTRIES',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_view_skm_entries.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看知识库文章',:description=>'查看知识库文章')
    skm_view_skm_entries.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Skm Entries',:description=>'View Skm Entries')
    skm_view_skm_entries.save
    skm_edit_skm_entries= Irm::Function.new(:function_group_code=>'KNOWLEDGE_MANAGEMENT',:code=>'EDIT_SKM_ENTRIES',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_edit_skm_entries.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑知识库文章',:description=>'编辑知识库文章')
    skm_edit_skm_entries.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Skm Entries',:description=>'Edit Skm Entries')
    skm_edit_skm_entries.save
    skm_create_skm_entries= Irm::Function.new(:function_group_code=>'KNOWLEDGE_MANAGEMENT',:code=>'CREATE_SKM_ENTRIES',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_create_skm_entries.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建知识库文章',:description=>'新建知识库文章')
    skm_create_skm_entries.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Create Skm Entries',:description=>'Create Skm Entries')
    skm_create_skm_entries.save
    csi_view_survey= Irm::Function.new(:function_group_code=>'CSI_SURVEY',:code=>'VIEW_SURVEY',:default_flag=>'N ',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    csi_view_survey.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看调查问卷',:description=>'查看调查问卷')
    csi_view_survey.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Survey',:description=>'View Survey')
    csi_view_survey.save
    csi_new_survey= Irm::Function.new(:function_group_code=>'CSI_SURVEY',:code=>'NEW_SURVEY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    csi_new_survey.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'发起调查',:description=>'发起调查')
    csi_new_survey.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Initiate Survey',:description=>'Initiate Survey')
    csi_new_survey.save
    csi_edit_survey= Irm::Function.new(:function_group_code=>'CSI_SURVEY',:code=>'EDIT_SURVEY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    csi_edit_survey.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑调查问卷',:description=>'编辑调查问卷')
    csi_edit_survey.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Survey',:description=>'Edit Survey')
    csi_edit_survey.save
    csi_view_survey_result= Irm::Function.new(:function_group_code=>'CSI_SURVEY',:code=>'VIEW_SURVEY_RESULT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    csi_view_survey_result.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看调查结果',:description=>'查看调查结果')
    csi_view_survey_result.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Survey Result',:description=>'View Survey Result')
    csi_view_survey_result.save
    csi_reply_survey= Irm::Function.new(:function_group_code=>'CSI_SURVEY',:code=>'REPLY_SURVEY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    csi_reply_survey.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'参与调查',:description=>'参与调查')
    csi_reply_survey.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Reply Survey',:description=>'Reply Survey')
    csi_reply_survey.save
    irm_view_reports= Irm::Function.new(:function_group_code=>'IRM_REPORT',:code=>'VIEW_REPORTS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_reports.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看,运行报表',:description=>'查看,运行报表')
    irm_view_reports.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View and Run Report',:description=>'View and Run Report')
    irm_view_reports.save
    irm_create_reports= Irm::Function.new(:function_group_code=>'IRM_REPORT',:code=>'CREATE_REPORTS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_create_reports.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建报表',:description=>'新建报表')
    irm_create_reports.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New Report',:description=>'New Report')
    irm_create_reports.save
    irm_edit_reports= Irm::Function.new(:function_group_code=>'IRM_REPORT',:code=>'EDIT_REPORTS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_reports.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑报表',:description=>'编辑报表')
    irm_edit_reports.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Report',:description=>'Edit Report')
    irm_edit_reports.save
    irm_view_report_folders= Irm::Function.new(:function_group_code=>'IRM_REPORT',:code=>'VIEW_REPORT_FOLDERS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_report_folders.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表文件夹',:description=>'报表文件夹')
    irm_view_report_folders.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Folder',:description=>'Report Folder')
    irm_view_report_folders.save
    irm_create_report_folders= Irm::Function.new(:function_group_code=>'IRM_REPORT',:code=>'CREATE_REPORT_FOLDERS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_create_report_folders.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建报表文件夹',:description=>'新建报表文件夹')
    irm_create_report_folders.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New Report Folder',:description=>'New Report Folder')
    irm_create_report_folders.save
    irm_edit_report_folders= Irm::Function.new(:function_group_code=>'IRM_REPORT',:code=>'EDIT_REPORT_FOLDERS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_report_folders.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑报表文件夹',:description=>'编辑报表文件夹')
    irm_edit_report_folders.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Report Folder',:description=>'Edit Report Folder')
    irm_edit_report_folders.save
    irm_my_info= Irm::Function.new(:function_group_code=>'MY_INFO',:code=>'MY_INFO',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_my_info.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'个人信息',:description=>'个人信息')
    irm_my_info.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Personal Info',:description=>'Personal Info')
    irm_my_info.save
    irm_my_password= Irm::Function.new(:function_group_code=>'MY_PASSWORD',:code=>'MY_PASSWORD',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_my_password.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'修改我的密码',:description=>'修改我的密码')
    irm_my_password.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Password',:description=>'Change Password')
    irm_my_password.save
    irm_my_avatar= Irm::Function.new(:function_group_code=>'MY_AVATAR',:code=>'MY_AVATAR',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_my_avatar.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'修改我的头像',:description=>'修改我的头像')
    irm_my_avatar.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Avatar',:description=>'Change Avatar')
    irm_my_avatar.save
    irm_my_login_history= Irm::Function.new(:function_group_code=>'MY_LOGIN_HISTORY',:code=>'MY_LOGIN_HISTORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_my_login_history.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我的登录历史',:description=>'我的登录历史')
    irm_my_login_history.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Login Records',:description=>'Login Records')
    irm_my_login_history.save
    irm_global_setting= Irm::Function.new(:function_group_code=>'GLOBAL_SETTING',:code=>'GLOBAL_SETTING',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_global_setting.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理全局设置',:description=>'管理全局设置')
    irm_global_setting.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Global Setting',:description=>'Manage Global Setting')
    irm_global_setting.save
    irm_language= Irm::Function.new(:function_group_code=>'LANGUAGE',:code=>'LANGUAGE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_language.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理语言',:description=>'管理语言')
    irm_language.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Language',:description=>'Manage Language')
    irm_language.save
    irm_lookup_code= Irm::Function.new(:function_group_code=>'LOOKUP_CODE',:code=>'LOOKUP_CODE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_lookup_code.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理快速编码',:description=>'管理快速编码')
    irm_lookup_code.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Lookup code',:description=>'Manage Lookup code')
    irm_lookup_code.save
    irm_general_category= Irm::Function.new(:function_group_code=>'GENERAL_CATEGORY',:code=>'GENERAL_CATEGORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_general_category.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理公共分类',:description=>'管理公共分类')
    irm_general_category.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage General Category',:description=>'Manage General Category')
    irm_general_category.save
    irm_value_set= Irm::Function.new(:function_group_code=>'VALUE_SET',:code=>'VALUE_SET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_value_set.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理值集',:description=>'管理值集')
    irm_value_set.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Value Set',:description=>'Manage Value Set')
    irm_value_set.save
    irm_id_flex= Irm::Function.new(:function_group_code=>'ID_FLEX',:code=>'ID_FLEX',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_id_flex.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理弹性域',:description=>'管理弹性域')
    irm_id_flex.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Flex Field',:description=>'Manage Flex Field')
    irm_id_flex.save
    irm_id_flex_structure= Irm::Function.new(:function_group_code=>'ID_FLEX',:code=>'ID_FLEX_STRUCTURE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_id_flex_structure.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理弹性域结构',:description=>'管理弹性域结构')
    irm_id_flex_structure.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Flex Structure',:description=>'Manage Flex Structure')
    irm_id_flex_structure.save
    irm_product_module= Irm::Function.new(:function_group_code=>'PRODUCT_MODULE',:code=>'PRODUCT_MODULE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_product_module.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理产品模块',:description=>'管理产品模块')
    irm_product_module.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Product Module',:description=>'Manage Product Module')
    irm_product_module.save
    irm_business_object= Irm::Function.new(:function_group_code=>'BUSINESS_OBJECT',:code=>'BUSINESS_OBJECT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_business_object.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理业务对像',:description=>'管理业务对像')
    irm_business_object.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Business Object',:description=>'Manage Business Object')
    irm_business_object.save
    irm_list_of_value= Irm::Function.new(:function_group_code=>'LIST_OF_VALUE',:code=>'LIST_OF_VALUE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_list_of_value.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理值列表',:description=>'管理值列表')
    irm_list_of_value.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage List of Value',:description=>'Manage List of Value')
    irm_list_of_value.save
    irm_report_category= Irm::Function.new(:function_group_code=>'REPORT_CATEGORY',:code=>'REPORT_CATEGORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_report_category.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理报表类别',:description=>'管理报表类别')
    irm_report_category.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Report Category',:description=>'Manage Report Category')
    irm_report_category.save
    irm_report_type= Irm::Function.new(:function_group_code=>'REPORT_TYPE',:code=>'REPORT_TYPE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_report_type.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理报表类型',:description=>'管理报表类型')
    irm_report_type.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Report Type',:description=>'Manage Report Type')
    irm_report_type.save
    irm_menu= Irm::Function.new(:function_group_code=>'MENU',:code=>'MENU',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_menu.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理菜单',:description=>'管理菜单')
    irm_menu.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Menu',:description=>'Manage Menu')
    irm_menu.save
    irm_function_group= Irm::Function.new(:function_group_code=>'FUNCTION_GROUP',:code=>'FUNCTION_GROUP',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_function_group.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理功能组',:description=>'管理功能组')
    irm_function_group.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Function Group',:description=>'Manage Function Group')
    irm_function_group.save
    irm_function= Irm::Function.new(:function_group_code=>'FUNCTION',:code=>'FUNCTION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_function.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理功能',:description=>'管理功能')
    irm_function.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Function',:description=>'Manage Function')
    irm_function.save
    irm_permission= Irm::Function.new(:function_group_code=>'PERMISSION',:code=>'PERMISSION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_permission.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理权限',:description=>'管理权限')
    irm_permission.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Permission',:description=>'Manage Permission')
    irm_permission.save
    irm_workflow_rule= Irm::Function.new(:function_group_code=>'WORKFLOW_RULE',:code=>'WORKFLOW_RULE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_workflow_rule.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理工作流规则',:description=>'管理工作流规则')
    irm_workflow_rule.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Workflow Rule',:description=>'Manage Workflow Rule')
    irm_workflow_rule.save
    irm_workflow_process= Irm::Function.new(:function_group_code=>'WORKFLOW_PROCESS',:code=>'WORKFLOW_PROCESS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_workflow_process.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理审批流程',:description=>'管理审批流程')
    irm_workflow_process.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Workflow Process',:description=>'Manage Workflow Process')
    irm_workflow_process.save
    irm_workflow_mail_alert= Irm::Function.new(:function_group_code=>'WORKFLOW_MAIL_ALERT',:code=>'WORKFLOW_MAIL_ALERT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_workflow_mail_alert.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理邮件警告',:description=>'管理邮件警告')
    irm_workflow_mail_alert.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Mail Alert',:description=>'Manage Mail Alert')
    irm_workflow_mail_alert.save
    irm_workflow_field_update= Irm::Function.new(:function_group_code=>'WORKFLOW_FIELD_UPDATE',:code=>'WORKFLOW_FIELD_UPDATE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_workflow_field_update.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理字段更新',:description=>'管理字段更新')
    irm_workflow_field_update.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Field Update',:description=>'Manage Field Update')
    irm_workflow_field_update.save
    irm_workflow_setting= Irm::Function.new(:function_group_code=>'WORKFLOW_SETTING',:code=>'WORKFLOW_SETTING',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_workflow_setting.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理工作流设置',:description=>'管理工作流设置')
    irm_workflow_setting.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Workflow Setting',:description=>'Manage Workflow Setting')
    irm_workflow_setting.save
    irm_person= Irm::Function.new(:function_group_code=>'PERSON',:code=>'PERSON',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_person.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理用户',:description=>'管理用户')
    irm_person.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage User',:description=>'Manage User')
    irm_person.save
    irm_role= Irm::Function.new(:function_group_code=>'ROLE',:code=>'ROLE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_role.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理角色',:description=>'管理角色')
    irm_role.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Role',:description=>'Manage Role')
    irm_role.save
    irm_company= Irm::Function.new(:function_group_code=>'COMPANY',:code=>'COMPANY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_company.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理公司',:description=>'管理公司')
    irm_company.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Company',:description=>'Manage Company')
    irm_company.save
    irm_organization= Irm::Function.new(:function_group_code=>'ORGANIZATION',:code=>'ORGANIZATION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_organization.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理组织',:description=>'管理组织')
    irm_organization.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Organization',:description=>'Manage Organization')
    irm_organization.save
    irm_department= Irm::Function.new(:function_group_code=>'DEPARTMENT',:code=>'DEPARTMENT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_department.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理部门',:description=>'管理部门')
    irm_department.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Department',:description=>'Manage Department')
    irm_department.save
    irm_support_group= Irm::Function.new(:function_group_code=>'SUPPORT_GROUP',:code=>'SUPPORT_GROUP',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_support_group.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理支持组',:description=>'管理支持组')
    irm_support_group.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Support Group',:description=>'Manage Support Group')
    irm_support_group.save
    irm_region= Irm::Function.new(:function_group_code=>'REGION',:code=>'REGION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_region.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理区域',:description=>'管理区域')
    irm_region.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Region',:description=>'Manage Region')
    irm_region.save
    irm_site_group= Irm::Function.new(:function_group_code=>'SITE_GROUP',:code=>'SITE_GROUP',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_site_group.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理地点组',:description=>'管理地点组')
    irm_site_group.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Site Group',:description=>'Manage Site Group')
    irm_site_group.save
    irm_site= Irm::Function.new(:function_group_code=>'SITE',:code=>'SITE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_site.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理地点',:description=>'管理地点')
    irm_site.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Site',:description=>'Manage Site')
    irm_site.save
    irm_system= Irm::Function.new(:function_group_code=>'SYSTEM',:code=>'SYSTEM',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_system.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理外部系统',:description=>'管理外部系统')
    irm_system.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage External System',:description=>'Manage External System')
    irm_system.save
    irm_external_loingid= Irm::Function.new(:function_group_code=>'EXTERNAL_LOINGID',:code=>'EXTERNAL_LOINGID',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_external_loingid.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理外部LoginID',:description=>'管理外部LoginID')
    irm_external_loingid.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage External LoginID',:description=>'Manage External LoginID')
    irm_external_loingid.save
    irm_login_mapping= Irm::Function.new(:function_group_code=>'LOGIN_MAPPING',:code=>'LOGIN_MAPPING',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_login_mapping.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理用户&外部用户映射',:description=>'管理用户&外部用户映射')
    irm_login_mapping.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage LoginID Mapping',:description=>'Manage LoginID Mapping')
    irm_login_mapping.save
    icm_icm_close_reason= Irm::Function.new(:function_group_code=>'ICM_CLOSE_REASON',:code=>'ICM_CLOSE_REASON',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_close_reason.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单关闭原因',:description=>'管理事故单关闭原因')
    icm_icm_close_reason.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Incident Close Reason',:description=>'Manage Incident Close Reason')
    icm_icm_close_reason.save
    icm_icm_group_assign= Irm::Function.new(:function_group_code=>'ICM_GROUP_ASSIGN',:code=>'ICM_GROUP_ASSIGN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_group_assign.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单组指派',:description=>'管理事故单组指派')
    icm_icm_group_assign.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Group Assign',:description=>'Manage Group Assign')
    icm_icm_group_assign.save
    icm_icm_rule_setting= Irm::Function.new(:function_group_code=>'ICM_RULE_SETTING',:code=>'ICM_RULE_SETTING',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_rule_setting.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单规则设置',:description=>'管理事故单规则设置')
    icm_icm_rule_setting.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Rule Setting',:description=>'Manage Rule Setting')
    icm_icm_rule_setting.save
    icm_icm_urgence_code= Irm::Function.new(:function_group_code=>'ICM_URGENCE_CODE',:code=>'ICM_URGENCE_CODE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_urgence_code.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单紧急度',:description=>'管理事故单紧急度')
    icm_icm_urgence_code.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Urgency',:description=>'Manage Urgency')
    icm_icm_urgence_code.save
    icm_icm_impact_range= Irm::Function.new(:function_group_code=>'ICM_IMPACT_RANGE',:code=>'ICM_IMPACT_RANGE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_impact_range.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单影响度',:description=>'管理事故单影响度')
    icm_icm_impact_range.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Impact Range',:description=>'Manage Impact Range')
    icm_icm_impact_range.save
    icm_icm_priority_code= Irm::Function.new(:function_group_code=>'ICM_PRIORITY_CODE',:code=>'ICM_PRIORITY_CODE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_priority_code.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单优先级',:description=>'管理事故单优先级')
    icm_icm_priority_code.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Priority',:description=>'Manage Priority')
    icm_icm_priority_code.save
    icm_icm_phase= Irm::Function.new(:function_group_code=>'ICM_PHASE',:code=>'ICM_PHASE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_phase.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单阶段',:description=>'管理事故单阶段')
    icm_icm_phase.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Phase',:description=>'Manage Phase')
    icm_icm_phase.save
    icm_icm_status= Irm::Function.new(:function_group_code=>'ICM_STATUS',:code=>'ICM_STATUS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_status.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单状态',:description=>'管理事故单状态')
    icm_icm_status.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Status',:description=>'Manage Status')
    icm_icm_status.save
    slm_service_category= Irm::Function.new(:function_group_code=>'SERVICE_CATEGORY',:code=>'SERVICE_CATEGORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    slm_service_category.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理服务类别',:description=>'管理服务类别')
    slm_service_category.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Category',:description=>'Manage Category')
    slm_service_category.save
    slm_service_catalog= Irm::Function.new(:function_group_code=>'SERVICE_CATALOG',:code=>'SERVICE_CATALOG',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    slm_service_catalog.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理服务目录',:description=>'管理服务目录')
    slm_service_catalog.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Catalog',:description=>'Manage Catalog')
    slm_service_catalog.save
    slm_service_agreement= Irm::Function.new(:function_group_code=>'SERVICE_AGREEMENT',:code=>'SERVICE_AGREEMENT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    slm_service_agreement.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理服务协议',:description=>'管理服务协议')
    slm_service_agreement.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Argeement',:description=>'Manage Argeement')
    slm_service_agreement.save
    skm_skm_status= Irm::Function.new(:function_group_code=>'SKM_STATUS',:code=>'SKM_STATUS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_skm_status.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理知识库状态',:description=>'管理知识库状态')
    skm_skm_status.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Status',:description=>'Manage Status')
    skm_skm_status.save
    skm_skm_template= Irm::Function.new(:function_group_code=>'SKM_TEMPLATE',:code=>'SKM_TEMPLATE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_skm_template.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理知识库模板',:description=>'管理知识库模板')
    skm_skm_template.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Template',:description=>'Manage Template')
    skm_skm_template.save
    skm_skm_template_elements= Irm::Function.new(:function_group_code=>'SKM_TEMPLATE_ELEMENTS',:code=>'SKM_TEMPLATE_ELEMENTS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_skm_template_elements.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理知识库模板元素',:description=>'管理知识库模板元素')
    skm_skm_template_elements.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Template Element',:description=>'Manage Template Element')
    skm_skm_template_elements.save
    irm_ldap_source= Irm::Function.new(:function_group_code=>'LDAP_SOURCE',:code=>'LDAP_SOURCE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_ldap_source.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理LDAP源',:description=>'管理LDAP源')
    irm_ldap_source.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage LDAP Source',:description=>'Manage LDAP Source')
    irm_ldap_source.save
    irm_ldap_user= Irm::Function.new(:function_group_code=>'LDAP_USER',:code=>'LDAP_USER',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_ldap_user.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理LDAP用户',:description=>'管理LDAP用户')
    irm_ldap_user.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage LDAP User',:description=>'Manage LDAP User')
    irm_ldap_user.save
    irm_ldap_organization= Irm::Function.new(:function_group_code=>'LDAP_ORGANIZATION',:code=>'LDAP_ORGANIZATION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_ldap_organization.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理LDAP组织',:description=>'管理LDAP组织')
    irm_ldap_organization.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage LDAP Organization',:description=>'Manage LDAP Organization')
    irm_ldap_organization.save
    irm_email_template= Irm::Function.new(:function_group_code=>'EMAIL_TEMPLATE',:code=>'EMAIL_TEMPLATE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_email_template.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理邮件模板',:description=>'管理邮件模板')
    irm_email_template.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Email Template',:description=>'Manage Email Template')
    irm_email_template.save
    irm_monitor_workflow_rule= Irm::Function.new(:function_group_code=>'MONITOR_WORKFLOW_RULE',:code=>'MONITOR_WORKFLOW_RULE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_monitor_workflow_rule.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单工作流规则作业',:description=>'管理事故单工作流规则作业')
    irm_monitor_workflow_rule.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Monitor Workflow Rule',:description=>'Manage Monitor Workflow Rule')
    irm_monitor_workflow_rule.save
    irm_monitor_group_assign= Irm::Function.new(:function_group_code=>'MONITOR_GROUP_ASSIGN',:code=>'MONITOR_GROUP_ASSIGN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_monitor_group_assign.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单组指派作业',:description=>'管理事故单组指派作业')
    irm_monitor_group_assign.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Monitor Group Assign',:description=>'Manage Monitor Group Assign')
    irm_monitor_group_assign.save
    irm_monitor_delayed_jobs= Irm::Function.new(:function_group_code=>'MONITOR_DELAYED_JOBS',:code=>'MONITOR_DELAYED_JOBS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_monitor_delayed_jobs.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理Delayed Job运行记录',:description=>'管理Delayed Job运行记录')
    irm_monitor_delayed_jobs.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Monitor Delayed Jobs',:description=>'Manage Monitor Delayed Jobs')
    irm_monitor_delayed_jobs.save
    irm_monitor_approve_mail= Irm::Function.new(:function_group_code=>'MONITOR_APPROVE_MAIL',:code=>'MONITOR_APPROVE_MAIL',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_monitor_approve_mail.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理审批邮件发送作业',:description=>'管理审批邮件发送作业')
    irm_monitor_approve_mail.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Monitor Approve Mail',:description=>'Manage Monitor Approve Mail')
    irm_monitor_approve_mail.save
    irm_kanban= Irm::Function.new(:function_group_code=>'KANBAN',:code=>'KANBAN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_kanban.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理看板',:description=>'管理看板')
    irm_kanban.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Signboard',:description=>'Manage Signboard')
    irm_kanban.save
    irm_kanban_lane= Irm::Function.new(:function_group_code=>'KANBAN_LANE',:code=>'KANBAN_LANE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_kanban_lane.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理看板泳道',:description=>'管理看板泳道')
    irm_kanban_lane.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Lane',:description=>'Manage Lane')
    irm_kanban_lane.save
    irm_kanban_card= Irm::Function.new(:function_group_code=>'KANBAN_CARD',:code=>'KANBAN_CARD',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_kanban_card.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理看板卡片',:description=>'管理看板卡片')
    irm_kanban_card.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Card',:description=>'Manage Card')
    irm_kanban_card.save
  end

  def self.down
  end
end
