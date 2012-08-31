# -*- coding: utf-8 -*-
class Ironmine15Data < ActiveRecord::Migration
  def self.up
    Irm::OperationUnit.create(:name=>"汉得运维中心",
                              :short_name=>"Hand",
                              :description=>"汉得运维中心",
                              :default_language_code=>"zh",
                              :default_time_zone_code=>"GMT_P0800_6")

    irm_product = Irm::ProductModule.new({:product_short_name=>"IRM",:installed_flag=>"Y",:not_auto_mult=>true})
    irm_product.product_modules_tls.build({:name=>"Ironmine Framework",:description=>"Ironmine Framework",:language=>"en",:source_lang=>"en"})
    irm_product.product_modules_tls.build({:name=>"基础模块",:description=>"基础模块",:language=>"zh",:source_lang=>"en"})
    irm_product.save

    icm_product = Irm::ProductModule.new({:product_short_name=>"ICM",:installed_flag=>"Y",:not_auto_mult=>true})
    icm_product.product_modules_tls.build({:name=>"Incident Request",:description=>"Incident Request",:language=>"en",:source_lang=>"en"})
    icm_product.product_modules_tls.build({:name=>"事故单",:description=>"事故单",:language=>"zh",:source_lang=>"en"})
    icm_product.save

    skm_product = Irm::ProductModule.new({:product_short_name=>"SKM",:installed_flag=>"Y",:not_auto_mult=>true})
    skm_product.product_modules_tls.build({:name=>"Service Knowledge Management",:description=>"Service Knowledge Management",:language=>"en",:source_lang=>"en"})
    skm_product.product_modules_tls.build({:name=>"知识库",:description=>"知识库",:language=>"zh",:source_lang=>"en"})
    skm_product.save

    slm_product = Irm::ProductModule.new({:product_short_name=>"SLM",:installed_flag=>"Y",:not_auto_mult=>true})
    slm_product.product_modules_tls.build({:name=>"Service Level Management",:description=>"Service Level Management",:language=>"en",:source_lang=>"en"})
    slm_product.product_modules_tls.build({:name=>"服务目录管理",:description=>"服务目录管理",:language=>"zh",:source_lang=>"en"})
    slm_product.save

    csi_product = Irm::ProductModule.new({:product_short_name=>"CSI",:installed_flag=>"Y",:not_auto_mult=>true})
    csi_product.product_modules_tls.build({:name=>"Survey",:description=>"Survey",:language=>"en",:source_lang=>"en"})
    csi_product.product_modules_tls.build({:name=>"调查问卷",:description=>"调查问卷",:language=>"zh",:source_lang=>"en"})
    csi_product.save

    uid_product = Irm::ProductModule.new({:product_short_name=>"UID",:installed_flag=>"Y",:not_auto_mult=>true})
    uid_product.product_modules_tls.build({:name=>"Unified identity",:description=>"Unified identity",:language=>"en",:source_lang=>"en"})
    uid_product.product_modules_tls.build({:name=>"统一身份",:description=>"统一身份",:language=>"zh",:source_lang=>"en"})
    uid_product.save


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
    irm_currency= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CUSTOM',:code=>'CURRENCY',:controller=>'irm/currencies',:action=>'index',:not_auto_mult=>true)
    irm_currency.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'汇率',:description=>'汇率')
    irm_currency.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Currency',:description=>'Currency')
    irm_currency.save
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
    irm_application= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'APPLICATION',:controller=>'irm/applications',:action=>'index',:not_auto_mult=>true)
    irm_application.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'应用',:description=>'应用')
    irm_application.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Applications',:description=>'Applications')
    irm_application.save
    irm_business_object= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'BUSINESS_OBJECT',:controller=>'irm/business_objects',:action=>'index',:not_auto_mult=>true)
    irm_business_object.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'业务对像',:description=>'业务对像')
    irm_business_object.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Business Object',:description=>'Business Object')
    irm_business_object.save
    irm_list_of_value= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'LIST_OF_VALUE',:controller=>'irm/list_of_values',:action=>'index',:not_auto_mult=>true)
    irm_list_of_value.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'值列表',:description=>'值列表')
    irm_list_of_value.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'List of Value',:description=>'List of Value')
    irm_list_of_value.save
    irm_tab= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'TAB',:controller=>'irm/tabs',:action=>'index',:not_auto_mult=>true)
    irm_tab.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'标签页',:description=>'标签页')
    irm_tab.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Tabs',:description=>'Tabs')
    irm_tab.save
    irm_report_type_category= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'REPORT_TYPE_CATEGORY',:controller=>'irm/report_type_categories',:action=>'index',:not_auto_mult=>true)
    irm_report_type_category.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类别',:description=>'报表类别')
    irm_report_type_category.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Category',:description=>'Report Category')
    irm_report_type_category.save
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
    irm_person= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'PERSON',:controller=>'irm/people',:action=>'index',:not_auto_mult=>true)
    irm_person.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'用户',:description=>'用户')
    irm_person.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'User',:description=>'User')
    irm_person.save
    irm_profile= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'PROFILE',:controller=>'irm/profiles',:action=>'index',:not_auto_mult=>true)
    irm_profile.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'简档',:description=>'简档')
    irm_profile.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Profile',:description=>'Profile')
    irm_profile.save
    irm_role= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'ROLE',:controller=>'irm/roles',:action=>'index',:not_auto_mult=>true)
    irm_role.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'角色',:description=>'角色')
    irm_role.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Role',:description=>'Role')
    irm_role.save
    irm_group= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'GROUP',:controller=>'irm/groups',:action=>'index',:not_auto_mult=>true)
    irm_group.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'组',:description=>'组')
    irm_group.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Group',:description=>'Group')
    irm_group.save
    irm_operation_unit= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'OPERATION_UNIT',:controller=>'irm/operation_units',:action=>'show',:not_auto_mult=>true)
    irm_operation_unit.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'运维中心',:description=>'运维中心')
    irm_operation_unit.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Operation Unit',:description=>'Operation Unit')
    irm_operation_unit.save
    irm_organization= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'ORGANIZATION',:controller=>'irm/organizations',:action=>'index',:not_auto_mult=>true)
    irm_organization.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'组织',:description=>'组织')
    irm_organization.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Organization',:description=>'Organization')
    irm_organization.save
    irm_region= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'REGION',:controller=>'irm/regions',:action=>'index',:not_auto_mult=>true)
    irm_region.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'区域',:description=>'区域')
    irm_region.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Region',:description=>'Region')
    irm_region.save
    irm_site_group= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'SITE_GROUP',:controller=>'irm/site_groups',:action=>'index',:not_auto_mult=>true)
    irm_site_group.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'地点组',:description=>'地点组')
    irm_site_group.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Site Group',:description=>'Site Group')
    irm_site_group.save
    irm_site= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'SITE',:controller=>'irm/sites',:action=>'index',:not_auto_mult=>true)
    irm_site.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'地点',:description=>'地点')
    irm_site.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Site',:description=>'Site')
    irm_site.save
    irm_system= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'SYSTEM',:controller=>'irm/external_systems',:action=>'index',:not_auto_mult=>true)
    irm_system.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部系统',:description=>'外部系统')
    irm_system.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'External System',:description=>'External System')
    irm_system.save
    uid_external_loingid= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'EXTERNAL_LOINGID',:controller=>'uid/external_logins',:action=>'index',:not_auto_mult=>true)
    uid_external_loingid.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部LoginID',:description=>'外部LoginID')
    uid_external_loingid.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'External LoginID',:description=>'External LoginID')
    uid_external_loingid.save
    uid_login_mapping= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'LOGIN_MAPPING',:controller=>'uid/login_mappings',:action=>'index',:not_auto_mult=>true)
    uid_login_mapping.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'用户&外部用户映射',:description=>'用户&外部用户映射')
    uid_login_mapping.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'LoginID Mapping',:description=>'LoginID Mapping')
    uid_login_mapping.save
    irm_external_system_member= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'EXTERNAL_SYSTEM_MEMBER',:controller=>'irm/external_system_members',:action=>'index',:not_auto_mult=>true)
    irm_external_system_member.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部系统成员',:description=>'外部系统成员')
    irm_external_system_member.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'External System Members',:description=>'External System Members')
    irm_external_system_member.save
    icm_icm_close_reason= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_CLOSE_REASON',:controller=>'icm/close_reasons',:action=>'index',:not_auto_mult=>true)
    icm_icm_close_reason.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'关闭原因',:description=>'关闭原因')
    icm_icm_close_reason.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Close Reason',:description=>'Close Reason')
    icm_icm_close_reason.save
    icm_icm_rule_setting= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_RULE_SETTING',:controller=>'icm/rule_settings',:action=>'index',:not_auto_mult=>true)
    icm_icm_rule_setting.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'规则设置',:description=>'规则设置')
    icm_icm_rule_setting.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Rule Setting',:description=>'Rule Setting')
    icm_icm_rule_setting.save
    icm_icm_urgence_code= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_URGENCE_CODE',:controller=>'icm/urgence_codes',:action=>'index',:not_auto_mult=>true)
    icm_icm_urgence_code.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'紧急度',:description=>'紧急度')
    icm_icm_urgence_code.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Urgency',:description=>'Urgency')
    icm_icm_urgence_code.save
    icm_icm_impact_range= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_IMPACT_RANGE',:controller=>'icm/impact_ranges',:action=>'index',:not_auto_mult=>true)
    icm_icm_impact_range.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'影响度',:description=>'影响度')
    icm_icm_impact_range.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Impact Range',:description=>'Impact Range')
    icm_icm_impact_range.save
    icm_icm_priority_code= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_PRIORITY_CODE',:controller=>'icm/priority_codes',:action=>'index',:not_auto_mult=>true)
    icm_icm_priority_code.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'优先级',:description=>'优先级')
    icm_icm_priority_code.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Priority',:description=>'Priority')
    icm_icm_priority_code.save
    icm_icm_phase= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_PHASE',:controller=>'icm/incident_phases',:action=>'index',:not_auto_mult=>true)
    icm_icm_phase.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'阶段',:description=>'阶段')
    icm_icm_phase.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Phase',:description=>'Phase')
    icm_icm_phase.save
    icm_icm_status= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_STATUS',:controller=>'icm/incident_statuses',:action=>'index',:not_auto_mult=>true)
    icm_icm_status.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'状态',:description=>'状态')
    icm_icm_status.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Status',:description=>'Status')
    icm_icm_status.save
    icm_icm_support_group= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'ICM_SUPPORT_GROUP',:controller=>'icm/support_groups',:action=>'index',:not_auto_mult=>true)
    icm_icm_support_group.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'支持组',:description=>'支持组')
    icm_icm_support_group.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Support Group',:description=>'Support Group')
    icm_icm_support_group.save
    slm_service_category= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'SERVICE_CATEGORY',:controller=>'slm/service_categories',:action=>'index',:not_auto_mult=>true)
    slm_service_category.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'服务类别',:description=>'服务类别')
    slm_service_category.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Category',:description=>'Category')
    slm_service_category.save
    slm_service_catalog= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'SERVICE_CATALOG',:controller=>'slm/service_catalogs',:action=>'index',:not_auto_mult=>true)
    slm_service_catalog.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'服务目录',:description=>'服务目录')
    slm_service_catalog.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Catalog',:description=>'Catalog')
    slm_service_catalog.save
    slm_service_agreement= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'SERVICE_AGREEMENT',:controller=>'slm/service_agreements',:action=>'index',:not_auto_mult=>true)
    slm_service_agreement.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'服务协议',:description=>'服务协议')
    slm_service_agreement.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Argeement',:description=>'Argeement')
    slm_service_agreement.save
    skm_skm_status= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_STATUS',:controller=>'skm/entry_statuses',:action=>'index',:not_auto_mult=>true)
    skm_skm_status.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库状态',:description=>'知识库状态')
    skm_skm_status.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Status',:description=>'Status')
    skm_skm_status.save
    skm_skm_template= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_TEMPLATE',:controller=>'skm/entry_templates',:action=>'index',:not_auto_mult=>true)
    skm_skm_template.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库模板',:description=>'知识库模板')
    skm_skm_template.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Template',:description=>'Template')
    skm_skm_template.save
    skm_skm_template_element= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_TEMPLATE_ELEMENT',:controller=>'skm/entry_template_elements',:action=>'index',:not_auto_mult=>true)
    skm_skm_template_element.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库模板元素',:description=>'知识库模板元素')
    skm_skm_template_element.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Template Element',:description=>'Template Element')
    skm_skm_template_element.save
    skm_skm_setting= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_SETTING',:controller=>'skm/settings',:action=>'index',:not_auto_mult=>true)
    skm_skm_setting.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库设置',:description=>'知识库设置')
    skm_skm_setting.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Setting',:description=>'Setting')
    skm_skm_setting.save
    irm_ldap_source= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'LDAP_SOURCE',:controller=>'irm/ldap_sources',:action=>'index',:not_auto_mult=>true)
    irm_ldap_source.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'LDAP源',:description=>'LDAP源')
    irm_ldap_source.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'LDAP Source',:description=>'LDAP Source')
    irm_ldap_source.save
    irm_ldap_user= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'LDAP_USER',:controller=>'irm/ldap_auth_headers',:action=>'index',:not_auto_mult=>true)
    irm_ldap_user.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'LDAP用户',:description=>'LDAP用户')
    irm_ldap_user.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'LDAP User',:description=>'LDAP User')
    irm_ldap_user.save
    irm_ldap_organization= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'LDAP_ORGANIZATION',:controller=>'irm/ldap_syn_headers',:action=>'index',:not_auto_mult=>true)
    irm_ldap_organization.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'LDAP组织',:description=>'LDAP组织')
    irm_ldap_organization.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'LDAP Organization',:description=>'LDAP Organization')
    irm_ldap_organization.save
    irm_mail_template= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'MAIL_TEMPLATE',:controller=>'irm/mail_templates',:action=>'index',:not_auto_mult=>true)
    irm_mail_template.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'邮件模板',:description=>'邮件模板')
    irm_mail_template.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Email Template',:description=>'Email Template')
    irm_mail_template.save
    irm_monitor_workflow_rule= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'MONITOR_WORKFLOW_RULE',:controller=>'irm/monitor_ir_rule_processes',:action=>'index',:not_auto_mult=>true)
    irm_monitor_workflow_rule.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单工作流规则作业',:description=>'事故单工作流规则作业')
    irm_monitor_workflow_rule.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor Workflow Rule',:description=>'Monitor Workflow Rule')
    irm_monitor_workflow_rule.save
    irm_monitor_group_assign= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'MONITOR_GROUP_ASSIGN',:controller=>'irm/monitor_icm_group_assigns',:action=>'index',:not_auto_mult=>true)
    irm_monitor_group_assign.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单组指派作业',:description=>'事故单组指派作业')
    irm_monitor_group_assign.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor Group Assign',:description=>'Monitor Group Assign')
    irm_monitor_group_assign.save
    irm_monitor_delayed_jobs= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'MONITOR_DELAYED_JOBS',:controller=>'irm/delayed_jobs',:action=>'index',:not_auto_mult=>true)
    irm_monitor_delayed_jobs.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Delayed Job运行记录',:description=>'Delayed Job运行记录')
    irm_monitor_delayed_jobs.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor Delayed Jobs',:description=>'Monitor Delayed Jobs')
    irm_monitor_delayed_jobs.save
    irm_monitor_approve_mail= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'MONITOR_APPROVE_MAIL',:controller=>'irm/monitor_approval_mails',:action=>'index',:not_auto_mult=>true)
    irm_monitor_approve_mail.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批邮件发送作业',:description=>'审批邮件发送作业')
    irm_monitor_approve_mail.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor Approve Mail',:description=>'Monitor Approve Mail')
    irm_monitor_approve_mail.save
    irm_kanban= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'KANBAN',:controller=>'irm/kanbans',:action=>'index',:not_auto_mult=>true)
    irm_kanban.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板',:description=>'看板')
    irm_kanban.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Signboard',:description=>'Signboard')
    irm_kanban.save
    irm_kanban_lane= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'KANBAN_LANE',:controller=>'irm/lanes',:action=>'index',:not_auto_mult=>true)
    irm_kanban_lane.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板泳道',:description=>'看板泳道')
    irm_kanban_lane.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Lane',:description=>'Lane')
    irm_kanban_lane.save
    irm_kanban_card= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'KANBAN_CARD',:controller=>'irm/cards',:action=>'index',:not_auto_mult=>true)
    irm_kanban_card.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板卡片',:description=>'看板卡片')
    irm_kanban_card.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Card',:description=>'Card')
    irm_kanban_card.save
    irm_bulletin_setting= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'BULLETIN_SETTING',:controller=>'irm/bulletins',:action=>'index',:not_auto_mult=>true)
    irm_bulletin_setting.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公告设置',:description=>'公告设置')
    irm_bulletin_setting.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Bulletin Setting',:description=>'Bulletin Setting')
    irm_bulletin_setting.save
    irm_bulletin_column= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'BULLETIN_COLUMN',:controller=>'irm/bu_columns',:action=>'index',:not_auto_mult=>true)
    irm_bulletin_column.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公告栏目',:description=>'公告栏目')
    irm_bulletin_column.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Bulletin Setting',:description=>'Bulletin Setting')
    irm_bulletin_column.save
    irm_skm_column= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_COLUMN',:controller=>'skm/columns',:action=>'index',:not_auto_mult=>true)
    irm_skm_column.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库分类',:description=>'知识库分类')
    irm_skm_column.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Skm Category',:description=>'Skm Category')
    irm_skm_column.save
    irm_password_policy= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'PASSWORD_POLICY',:controller=>'irm/password_policies',:action=>'index',:not_auto_mult=>true)
    irm_password_policy.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'密码策略设置',:description=>'密码策略设置')
    irm_password_policy.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Password Policy',:description=>'Password Policy')
    irm_password_policy.save
    irm_license= Irm::FunctionGroup.new(:zone_code=>'CLOUD_SETTING',:code=>'LICENSE',:controller=>'irm/licenses',:action=>'index',:not_auto_mult=>true)
    irm_license.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'运维中心License',:description=>'运维中心License')
    irm_license.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Operation License',:description=>'Operation License')
    irm_license.save
    irm_cloud_operation= Irm::FunctionGroup.new(:zone_code=>'CLOUD_SETTING',:code=>'CLOUD_OPERATION',:controller=>'irm/cloud_operations',:action=>'index',:not_auto_mult=>true)
    irm_cloud_operation.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'云运维中心',:description=>'云运维中心')
    irm_cloud_operation.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Cloud Operation Unit',:description=>'Cloud Operation Unit')
    irm_cloud_operation.save

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
    irm_todo_event= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'TODO_EVENT',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_todo_event.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'待办事件',:description=>'待办事件')
    irm_todo_event.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Todo Event',:description=>'Todo Event')
    irm_todo_event.save
    irm_todo_task= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'TODO_TASK',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_todo_task.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'待办任务',:description=>'待办任务')
    irm_todo_task.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Todo Task',:description=>'Todo Task')
    irm_todo_task.save
    irm_bulletin= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'BULLETIN',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_bulletin.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公告查看',:description=>'公告查看')
    irm_bulletin.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Bulletin',:description=>'View Bulletin')
    irm_bulletin.save
    irm_edit_bulletin= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'EDIT_BULLETIN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_bulletin.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑公告',:description=>'编辑公告')
    irm_edit_bulletin.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Bulletin',:description=>'Edit Bulletin')
    irm_edit_bulletin.save
    irm_new_bulletin= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'NEW_BULLETIN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_new_bulletin.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建公告',:description=>'新建公告')
    irm_new_bulletin.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New Bulletin',:description=>'New Bulletin')
    irm_new_bulletin.save
    irm_delete_bulletin= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'DELETE_BULLETIN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_delete_bulletin.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'删除公告',:description=>'删除公告')
    irm_delete_bulletin.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Delete Bulletin',:description=>'Delete Bulletin')
    irm_delete_bulletin.save
    irm_workflow_approval= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'WORKFLOW_APPROVAL',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_workflow_approval.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'工作流审批',:description=>'工作流审批')
    irm_workflow_approval.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Workflow Approval',:description=>'Workflow Approval')
    irm_workflow_approval.save
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
    icm_view_icm_kanban= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'VIEW_ICM_KANBAN',:default_flag=>'N',:login_flag => 'Y', :public_flag=>'N',:not_auto_mult=>true)
    icm_view_icm_kanban.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看看板',:description=>'查看看板')
    icm_view_icm_kanban.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View ICM Kanban',:description=>'View ICM Kanban')
    icm_view_icm_kanban.save
    icm_view_watcher= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'VIEW_WATCHER',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_view_watcher.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看观察者',:description=>'查看观察者')
    icm_view_watcher.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Watcher',:description=>'View Watcher')
    icm_view_watcher.save
    icm_edit_watcher= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'EDIT_WATCHER',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_edit_watcher.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑观察者',:description=>'编辑观察者')
    icm_edit_watcher.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Watcher',:description=>'Edit Watcher')
    icm_edit_watcher.save
    icm_incident_request_assign_me= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'INCIDENT_REQUEST_ASSIGN_ME',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_incident_request_assign_me.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'领取',:description=>'领取')
    icm_incident_request_assign_me.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Request',:description=>'Request')
    icm_incident_request_assign_me.save
    icm_incident_request_edit_status= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'INCIDENT_REQUEST_EDIT_STATUS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_incident_request_edit_status.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'修改状态',:description=>'修改状态')
    icm_incident_request_edit_status.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Status',:description=>'Edit Status')
    icm_incident_request_edit_status.save
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
    irm_currency= Irm::Function.new(:function_group_code=>'CURRENCY',:code=>'CURRENCY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_currency.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理汇率',:description=>'管理汇率')
    irm_currency.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Currency',:description=>'Manage Currency')
    irm_currency.save
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
    irm_application= Irm::Function.new(:function_group_code=>'APPLICATION',:code=>'APPLICATION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_application.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理应用',:description=>'管理应用')
    irm_application.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Application',:description=>'Manage Application')
    irm_application.save
    irm_business_object= Irm::Function.new(:function_group_code=>'BUSINESS_OBJECT',:code=>'BUSINESS_OBJECT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_business_object.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理业务对像',:description=>'管理业务对像')
    irm_business_object.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Business Object',:description=>'Manage Business Object')
    irm_business_object.save
    irm_list_of_value= Irm::Function.new(:function_group_code=>'LIST_OF_VALUE',:code=>'LIST_OF_VALUE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_list_of_value.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理值列表',:description=>'管理值列表')
    irm_list_of_value.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage List of Value',:description=>'Manage List of Value')
    irm_list_of_value.save
    irm_tab= Irm::Function.new(:function_group_code=>'TAB',:code=>'TAB',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_tab.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理标签页',:description=>'管理标签页')
    irm_tab.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Tab',:description=>'Manage Tab')
    irm_tab.save
    irm_report_type_category= Irm::Function.new(:function_group_code=>'REPORT_TYPE_CATEGORY',:code=>'REPORT_TYPE_CATEGORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_report_type_category.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理报表类别',:description=>'管理报表类别')
    irm_report_type_category.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Report Category',:description=>'Manage Report Category')
    irm_report_type_category.save
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
    irm_profile= Irm::Function.new(:function_group_code=>'PROFILE',:code=>'PROFILE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_profile.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理简档',:description=>'管理简档')
    irm_profile.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Profile',:description=>'Manage Profile')
    irm_profile.save
    irm_role= Irm::Function.new(:function_group_code=>'ROLE',:code=>'ROLE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_role.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理角色',:description=>'管理角色')
    irm_role.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Role',:description=>'Manage Role')
    irm_role.save
    irm_group= Irm::Function.new(:function_group_code=>'GROUP',:code=>'GROUP',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_group.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理组',:description=>'管理组')
    irm_group.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Group',:description=>'Manage Group')
    irm_group.save
    irm_operation_unit= Irm::Function.new(:function_group_code=>'OPERATION_UNIT',:code=>'OPERATION_UNIT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_operation_unit.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理运维中心',:description=>'管理运维中心')
    irm_operation_unit.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Operation Unit',:description=>'Manage Operation Unit')
    irm_operation_unit.save
    irm_organization= Irm::Function.new(:function_group_code=>'ORGANIZATION',:code=>'ORGANIZATION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_organization.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理组织',:description=>'管理组织')
    irm_organization.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Organization',:description=>'Manage Organization')
    irm_organization.save
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
    uid_external_loingid= Irm::Function.new(:function_group_code=>'EXTERNAL_LOINGID',:code=>'EXTERNAL_LOINGID',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    uid_external_loingid.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理外部LoginID',:description=>'管理外部LoginID')
    uid_external_loingid.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage External LoginID',:description=>'Manage External LoginID')
    uid_external_loingid.save
    uid_login_mapping= Irm::Function.new(:function_group_code=>'LOGIN_MAPPING',:code=>'LOGIN_MAPPING',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    uid_login_mapping.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理用户&外部用户映射',:description=>'管理用户&外部用户映射')
    uid_login_mapping.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage LoginID Mapping',:description=>'Manage LoginID Mapping')
    uid_login_mapping.save
    irm_external_system_member= Irm::Function.new(:function_group_code=>'EXTERNAL_SYSTEM_MEMBER',:code=>'EXTERNAL_SYSTEM_MEMBER',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_external_system_member.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理外部系统成员',:description=>'管理外部系统成员')
    irm_external_system_member.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage External System Members',:description=>'Manage External System Members')
    irm_external_system_member.save
    icm_icm_close_reason= Irm::Function.new(:function_group_code=>'ICM_CLOSE_REASON',:code=>'ICM_CLOSE_REASON',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_close_reason.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单关闭原因',:description=>'管理事故单关闭原因')
    icm_icm_close_reason.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Incident Close Reason',:description=>'Manage Incident Close Reason')
    icm_icm_close_reason.save

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
    icm_icm_support_group= Irm::Function.new(:function_group_code=>'ICM_SUPPORT_GROUP',:code=>'ICM_SUPPORT_GROUP',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_icm_support_group.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理支持组',:description=>'管理支持组')
    icm_icm_support_group.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Support Group',:description=>'Manage Support Group')
    icm_icm_support_group.save
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
    skm_skm_template_element= Irm::Function.new(:function_group_code=>'SKM_TEMPLATE_ELEMENT',:code=>'SKM_TEMPLATE_ELEMENT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_skm_template_element.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理知识库模板元素',:description=>'管理知识库模板元素')
    skm_skm_template_element.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Template Element',:description=>'Manage Template Element')
    skm_skm_template_element.save
    skm_skm_setting= Irm::Function.new(:function_group_code=>'SKM_SETTING',:code=>'SKM_SETTING',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_skm_setting.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理知识库设置',:description=>'管理知识库设置')
    skm_skm_setting.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Knowledge Base Setting',:description=>'Manage Knowledge Base Setting')
    skm_skm_setting.save
    skm_skm_column= Irm::Function.new(:function_group_code=>'SKM_COLUMN',:code=>'SKM_COLUMN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_skm_column.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理知识库分类',:description=>'管理知识库分类')
    skm_skm_column.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Skm Categories',:description=>'Manage Skm Categories')
    skm_skm_column.save
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
    irm_mail_template= Irm::Function.new(:function_group_code=>'MAIL_TEMPLATE',:code=>'MAIL_TEMPLATE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_mail_template.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理邮件模板',:description=>'管理邮件模板')
    irm_mail_template.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Email Template',:description=>'Manage Email Template')
    irm_mail_template.save
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
    irm_bulletin_column= Irm::Function.new(:function_group_code=>'BULLETIN_COLUMN',:code=>'BULLETIN_COLUMN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_bulletin_column.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理公告栏目',:description=>'管理公告栏目')
    irm_bulletin_column.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Bulletin Columns',:description=>'Manage Bulletin Columns')
    irm_bulletin_column.save
    irm_password_policy= Irm::Function.new(:function_group_code=>'PASSWORD_POLICY',:code=>'PASSWORD_POLICY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_password_policy.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理密码策略',:description=>'管理密码策略')
    irm_password_policy.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Password Policy',:description=>'Manage Password Policy')
    irm_password_policy.save
    irm_view_kanban= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'VIEW_KANBAN',:default_flag=>'N',:login_flag => 'Y', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_kanban.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板访问功能',:description=>'看板访问功能')
    irm_view_kanban.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Kanban View',:description=>'Manage Kanban View')
    irm_view_kanban.save
    irm_license= Irm::Function.new(:function_group_code=>'LICENSE',:code=>'LICENSE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_license.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'运维中心License',:description=>'运维中心License')
    irm_license.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Operation License',:description=>'Operation License')
    irm_license.save
    irm_cloud_operation= Irm::Function.new(:function_group_code=>'CLOUD_OPERATION',:code=>'CLOUD_OPERATION',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_cloud_operation.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'云运维中心',:description=>'云运维中心')
    irm_cloud_operation.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Cloud Operation Unit',:description=>'Cloud Operation Unit')
    irm_cloud_operation.save

    top_menu= Irm::Menu.new(:code=>'TOP_MENU',:not_auto_mult=>true)
    top_menu.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'顶级菜单 ',:description=>'顶级菜单 ')
    top_menu.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Top Menu',:description=>'Top Menu')
    top_menu.save
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
    organization_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'组织信息',:description=>'组织信息')
    organization_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Organization Information',:description=>'Organization Information')
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
    mail_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'邮件通信',:description=>'邮件通信')
    mail_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Mail&Communicate',:description=>'Mail&Communicate')
    mail_management.save
    monitor_management= Irm::Menu.new(:code=>'MONITOR_MANAGEMENT',:not_auto_mult=>true)
    monitor_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'监控',:description=>'监控')
    monitor_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Moitor',:description=>'Moitor')
    monitor_management.save
    bulletin_management= Irm::Menu.new(:code=>'BULLETIN_MANAGEMENT',:not_auto_mult=>true)
    bulletin_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公告管理',:description=>'公告管理')
    bulletin_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Bulletn',:description=>'Bulletin')
    bulletin_management.save
    kanban_management= Irm::Menu.new(:code=>'KANBAN_MANAGEMENT',:not_auto_mult=>true)
    kanban_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板管理',:description=>'看板管理')
    kanban_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Signboard',:description=>'Signboard')
    kanban_management.save
    security_control= Irm::Menu.new(:code=>'SECURITY_CONTROL',:not_auto_mult=>true)
    security_control.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'安全控制',:description=>'安全控制')
    security_control.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Security Control',:description=>'Security Control')
    security_control.save
    cloud_manage= Irm::Menu.new(:code=>'CLOUD_MANAGE',:not_auto_mult=>true)
    cloud_manage.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Cloud管理',:description=>'Cloud管理')
    cloud_manage.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Cloud Management',:description=>'Cloud Management')
    cloud_manage.save
    cloud_base_setting= Irm::Menu.new(:code=>'CLOUD_BASE_SETTING',:not_auto_mult=>true)
    cloud_base_setting.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'基础设置',:description=>'基础设置')
    cloud_base_setting.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Base Setting',:description=>'Base Setting')
    cloud_base_setting.save
    cloud_operation_setting= Irm::Menu.new(:code=>'CLOUD_OPERATION_SETTING',:not_auto_mult=>true)
    cloud_operation_setting.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'运维中心设置',:description=>'运维中心设置')
    cloud_operation_setting.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Operation Unit ',:description=>'Operation Unit ')
    cloud_operation_setting.save

    menu_entiry_2= Irm::MenuEntry.new(:menu_code=>'TOP_MENU',:sub_menu_code=>'PERSONAL_PROFILE',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_2.save
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
    menu_entiry_9= Irm::MenuEntry.new(:menu_code=>'TOP_MENU',:sub_menu_code=>'GLOBAL_SYSTEM_SETTING',:sub_function_group_code=>nil,:display_sequence=>20)
    menu_entiry_9.save
    menu_entiry_10= Irm::MenuEntry.new(:menu_code=>'GLOBAL_SYSTEM_SETTING',:sub_menu_code=>'APPLICATION_SETTING',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_10.save
    menu_entiry_11= Irm::MenuEntry.new(:menu_code=>'APPLICATION_SETTING',:sub_menu_code=>'GLOBAL_CUSTOM',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_11.save
    menu_entiry_12= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CUSTOM',:sub_menu_code=>nil,:sub_function_group_code=>'GLOBAL_SETTING',:display_sequence=>10)
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
    menu_entiry_18= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'APPLICATION',:display_sequence=>15)
    menu_entiry_18.save
    menu_entiry_19= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'BUSINESS_OBJECT',:display_sequence=>20)
    menu_entiry_19.save
    menu_entiry_20= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'LIST_OF_VALUE',:display_sequence=>30)
    menu_entiry_20.save
    menu_entiry_21= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'TAB',:display_sequence=>35)
    menu_entiry_21.save
    menu_entiry_22= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>'REPORT',:sub_function_group_code=>nil,:display_sequence=>40)
    menu_entiry_22.save
    menu_entiry_23= Irm::MenuEntry.new(:menu_code=>'REPORT',:sub_menu_code=>nil,:sub_function_group_code=>'REPORT_TYPE_CATEGORY',:display_sequence=>10)
    menu_entiry_23.save
    menu_entiry_24= Irm::MenuEntry.new(:menu_code=>'REPORT',:sub_menu_code=>nil,:sub_function_group_code=>'REPORT_TYPE',:display_sequence=>20)
    menu_entiry_24.save
    menu_entiry_25= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>'SECURITY_COMPONENT',:sub_function_group_code=>nil,:display_sequence=>50)
    menu_entiry_25.save
    menu_entiry_26= Irm::MenuEntry.new(:menu_code=>'SECURITY_COMPONENT',:sub_menu_code=>nil,:sub_function_group_code=>'MENU',:display_sequence=>10)
    menu_entiry_26.save
    menu_entiry_27= Irm::MenuEntry.new(:menu_code=>'SECURITY_COMPONENT',:sub_menu_code=>nil,:sub_function_group_code=>'FUNCTION_GROUP',:display_sequence=>20)
    menu_entiry_27.save
    menu_entiry_28= Irm::MenuEntry.new(:menu_code=>'SECURITY_COMPONENT',:sub_menu_code=>nil,:sub_function_group_code=>'FUNCTION',:display_sequence=>30)
    menu_entiry_28.save
    menu_entiry_29= Irm::MenuEntry.new(:menu_code=>'SECURITY_COMPONENT',:sub_menu_code=>nil,:sub_function_group_code=>'PERMISSION',:display_sequence=>40)
    menu_entiry_29.save
    menu_entiry_30= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>'WORKFLOW',:sub_function_group_code=>nil,:display_sequence=>60)
    menu_entiry_30.save
    menu_entiry_31= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_RULE',:display_sequence=>10)
    menu_entiry_31.save
    menu_entiry_32= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_PROCESS',:display_sequence=>20)
    menu_entiry_32.save
    menu_entiry_33= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_MAIL_ALERT',:display_sequence=>30)
    menu_entiry_33.save
    menu_entiry_34= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_FIELD_UPDATE',:display_sequence=>40)
    menu_entiry_34.save
    menu_entiry_35= Irm::MenuEntry.new(:menu_code=>'WORKFLOW',:sub_menu_code=>nil,:sub_function_group_code=>'WORKFLOW_SETTING',:display_sequence=>50)
    menu_entiry_35.save
    menu_entiry_36= Irm::MenuEntry.new(:menu_code=>'GLOBAL_SYSTEM_SETTING',:sub_menu_code=>'MANAGEMENT_SETTING',:sub_function_group_code=>nil,:display_sequence=>20)
    menu_entiry_36.save
    menu_entiry_37= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'USER_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_37.save
    menu_entiry_38= Irm::MenuEntry.new(:menu_code=>'USER_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'PERSON',:display_sequence=>10)
    menu_entiry_38.save
    menu_entiry_39= Irm::MenuEntry.new(:menu_code=>'USER_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'PROFILE',:display_sequence=>15)
    menu_entiry_39.save
    menu_entiry_40= Irm::MenuEntry.new(:menu_code=>'USER_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ROLE',:display_sequence=>20)
    menu_entiry_40.save
    menu_entiry_41= Irm::MenuEntry.new(:menu_code=>'USER_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'GROUP',:display_sequence=>30)
    menu_entiry_41.save
    menu_entiry_42= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'ORGANIZATION_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>20)
    menu_entiry_42.save
    menu_entiry_43= Irm::MenuEntry.new(:menu_code=>'ORGANIZATION_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'OPERATION_UNIT',:display_sequence=>10)
    menu_entiry_43.save
    menu_entiry_44= Irm::MenuEntry.new(:menu_code=>'ORGANIZATION_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ORGANIZATION',:display_sequence=>20)
    menu_entiry_44.save
    menu_entiry_45= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'SITE_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>30)
    menu_entiry_45.save
    menu_entiry_46= Irm::MenuEntry.new(:menu_code=>'SITE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'REGION',:display_sequence=>10)
    menu_entiry_46.save
    menu_entiry_47= Irm::MenuEntry.new(:menu_code=>'SITE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SITE_GROUP',:display_sequence=>20)
    menu_entiry_47.save
    menu_entiry_48= Irm::MenuEntry.new(:menu_code=>'SITE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SITE',:display_sequence=>30)
    menu_entiry_48.save
    menu_entiry_49= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>40)
    menu_entiry_49.save
    menu_entiry_50= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SYSTEM',:display_sequence=>10)
    menu_entiry_50.save
    menu_entiry_51= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'EXTERNAL_LOINGID',:display_sequence=>20)
    menu_entiry_51.save
    menu_entiry_52= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'LOGIN_MAPPING',:display_sequence=>30)
    menu_entiry_52.save
    menu_entiry_53= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'EXTERNAL_SYSTEM_MEMBER',:display_sequence=>40)
    menu_entiry_53.save
    menu_entiry_54= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'INCIDENT_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>50)
    menu_entiry_54.save
    menu_entiry_55= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_CLOSE_REASON',:display_sequence=>10)
    menu_entiry_55.save
    menu_entiry_56= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_RULE_SETTING',:display_sequence=>30)
    menu_entiry_56.save
    menu_entiry_57= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_URGENCE_CODE',:display_sequence=>40)
    menu_entiry_57.save
    menu_entiry_58= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_IMPACT_RANGE',:display_sequence=>50)
    menu_entiry_58.save
    menu_entiry_59= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_PRIORITY_CODE',:display_sequence=>60)
    menu_entiry_59.save
    menu_entiry_60= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_PHASE',:display_sequence=>70)
    menu_entiry_60.save
    menu_entiry_61= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_STATUS',:display_sequence=>80)
    menu_entiry_61.save
    menu_entiry_62= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ICM_SUPPORT_GROUP',:display_sequence=>90)
    menu_entiry_62.save
    menu_entiry_63= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'SERVICE_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>60)
    menu_entiry_63.save
    menu_entiry_64= Irm::MenuEntry.new(:menu_code=>'SERVICE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SERVICE_CATEGORY',:display_sequence=>10)
    menu_entiry_64.save
    menu_entiry_65= Irm::MenuEntry.new(:menu_code=>'SERVICE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SERVICE_CATALOG',:display_sequence=>20)
    menu_entiry_65.save
    menu_entiry_66= Irm::MenuEntry.new(:menu_code=>'SERVICE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SERVICE_AGREEMENT',:display_sequence=>30)
    menu_entiry_66.save
    menu_entiry_67= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>70)
    menu_entiry_67.save
    menu_entiry_68= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_STATUS',:display_sequence=>10)
    menu_entiry_68.save
    menu_entiry_69= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_TEMPLATE',:display_sequence=>20)
    menu_entiry_69.save
    menu_entiry_70= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_TEMPLATE_ELEMENT',:display_sequence=>30)
    menu_entiry_70.save
    menu_entiry_71= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_SETTING',:display_sequence=>40)
    menu_entiry_71.save
    menu_entiry_72= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_COLUMN',:display_sequence=>50)
    menu_entiry_72.save
    menu_entiry_73= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'LDAP_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>80)
    menu_entiry_73.save
    menu_entiry_74= Irm::MenuEntry.new(:menu_code=>'LDAP_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'LDAP_SOURCE',:display_sequence=>10)
    menu_entiry_74.save
    menu_entiry_75= Irm::MenuEntry.new(:menu_code=>'LDAP_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'LDAP_USER',:display_sequence=>20)
    menu_entiry_75.save
    menu_entiry_76= Irm::MenuEntry.new(:menu_code=>'LDAP_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'LDAP_ORGANIZATION',:display_sequence=>30)
    menu_entiry_76.save
    menu_entiry_77= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'MAIL_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>90)
    menu_entiry_77.save
    menu_entiry_78= Irm::MenuEntry.new(:menu_code=>'MAIL_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MAIL_TEMPLATE',:display_sequence=>10)
    menu_entiry_78.save
    menu_entiry_79= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'MONITOR_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>100)
    menu_entiry_79.save
    menu_entiry_80= Irm::MenuEntry.new(:menu_code=>'MONITOR_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MONITOR_WORKFLOW_RULE',:display_sequence=>10)
    menu_entiry_80.save
    menu_entiry_81= Irm::MenuEntry.new(:menu_code=>'MONITOR_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MONITOR_GROUP_ASSIGN',:display_sequence=>20)
    menu_entiry_81.save
    menu_entiry_82= Irm::MenuEntry.new(:menu_code=>'MONITOR_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MONITOR_DELAYED_JOBS',:display_sequence=>30)
    menu_entiry_82.save
    menu_entiry_83= Irm::MenuEntry.new(:menu_code=>'MONITOR_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MONITOR_APPROVE_MAIL',:display_sequence=>40)
    menu_entiry_83.save
    menu_entiry_84= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'BULLETIN_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>120)
    menu_entiry_84.save
    menu_entiry_85= Irm::MenuEntry.new(:menu_code=>'BULLETIN_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'BULLETIN_COLUMN',:display_sequence=>10)
    menu_entiry_85.save
    menu_entiry_86= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'KANBAN_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>110)
    menu_entiry_86.save
    menu_entiry_87= Irm::MenuEntry.new(:menu_code=>'KANBAN_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'KANBAN',:display_sequence=>10)
    menu_entiry_87.save
    menu_entiry_88= Irm::MenuEntry.new(:menu_code=>'KANBAN_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'KANBAN_LANE',:display_sequence=>20)
    menu_entiry_88.save
    menu_entiry_89= Irm::MenuEntry.new(:menu_code=>'KANBAN_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'KANBAN_CARD',:display_sequence=>30)
    menu_entiry_89.save
    menu_entiry_90= Irm::MenuEntry.new(:menu_code=>'SECURITY_CONTROL',:sub_menu_code=>nil,:sub_function_group_code=>'PASSWORD_POLICY',:display_sequence=>10)
    menu_entiry_90.save
    menu_entiry_91= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'SECURITY_CONTROL',:sub_function_group_code=>nil,:display_sequence=>130)
    menu_entiry_91.save
    menu_entiry_92= Irm::MenuEntry.new(:menu_code=>'GLOBAL_SYSTEM_SETTING',:sub_menu_code=>'CLOUD_MANAGE',:sub_function_group_code=>nil,:display_sequence=>30)
    menu_entiry_92.save
    menu_entiry_93= Irm::MenuEntry.new(:menu_code=>'CLOUD_MANAGE',:sub_menu_code=>'CLOUD_BASE_SETTING',:sub_function_group_code=>nil,:display_sequence=>10)
    menu_entiry_93.save
    menu_entiry_94= Irm::MenuEntry.new(:menu_code=>'CLOUD_BASE_SETTING',:sub_menu_code=>nil,:sub_function_group_code=>'PRODUCT_MODULE',:display_sequence=>10)
    menu_entiry_94.save
    menu_entiry_95= Irm::MenuEntry.new(:menu_code=>'CLOUD_BASE_SETTING',:sub_menu_code=>nil,:sub_function_group_code=>'LANGUAGE',:display_sequence=>20)
    menu_entiry_95.save
    menu_entiry_96= Irm::MenuEntry.new(:menu_code=>'CLOUD_BASE_SETTING',:sub_menu_code=>nil,:sub_function_group_code=>'CURRENCY',:display_sequence=>30)
    menu_entiry_96.save
    menu_entiry_97= Irm::MenuEntry.new(:menu_code=>'CLOUD_MANAGE',:sub_menu_code=>'CLOUD_OPERATION_SETTING',:sub_function_group_code=>nil,:display_sequence=>20)
    menu_entiry_97.save
    menu_entiry_98= Irm::MenuEntry.new(:menu_code=>'CLOUD_OPERATION_SETTING',:sub_menu_code=>nil,:sub_function_group_code=>'LICENSE',:display_sequence=>10)
    menu_entiry_98.save
    menu_entiry_99= Irm::MenuEntry.new(:menu_code=>'CLOUD_OPERATION_SETTING',:sub_menu_code=>nil,:sub_function_group_code=>'CLOUD_OPERATION',:display_sequence=>20)
    menu_entiry_99.save


    irm_my_profile= Irm::FunctionGroup.new(:zone_code=>'PERSONAL_SETTING',:code=>'MY_PROFILE',:controller=>'irm/my_profiles',:action=>'index',:not_auto_mult=>true)
    irm_my_profile.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我的简档',:description=>'我的简档')
    irm_my_profile.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'My Profile',:description=>'My Profile')
    irm_my_profile.save

    irm_my_profile= Irm::Function.new(:function_group_code=>'MY_PROFILE',:code=>'MY_PROFILE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_my_profile.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我的简档',:description=>'我的简档')
    irm_my_profile.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'My Profile',:description=>'My Profile')
    irm_my_profile.save

    menu_entiry_6= Irm::MenuEntry.new(:menu_code=>'PERSON_INFO',:sub_menu_code=>nil,:sub_function_group_code=>'MY_PROFILE',:display_sequence=>15)
    menu_entiry_6.save

    system_status_code=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SYSTEM_STATUS_CODE',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_status_code.lookup_types_tls.build(:lookup_type_id=>system_status_code.id,:meaning=>'记录状态',:description=>'记录状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_code.lookup_types_tls.build(:lookup_type_id=>system_status_code.id,:meaning=>'Status Code',:description=>'Status Code',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_code.save
    timezone=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'TIMEZONE',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezone.lookup_types_tls.build(:lookup_type_id=>timezone.id,:meaning=>'时区',:description=>'时区',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezone.lookup_types_tls.build(:lookup_type_id=>timezone.id,:meaning=>'Timezone',:description=>'Timezone',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezone.save
    active_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'ACTIVE_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    active_status.lookup_types_tls.build(:lookup_type_id=>active_status.id,:meaning=>'可用',:description=>'可用',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    active_status.lookup_types_tls.build(:lookup_type_id=>active_status.id,:meaning=>'Active',:description=>'Active',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    active_status.save
    icm_assign_process_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'ICM_ASSIGN_PROCESS_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_assign_process_type.lookup_types_tls.build(:lookup_type_id=>icm_assign_process_type.id,:meaning=>'ICM分配流程',:description=>'ICM分配流程',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_type.lookup_types_tls.build(:lookup_type_id=>icm_assign_process_type.id,:meaning=>'ICM dispatch process',:description=>'ICM dispatch process',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_type.save
    icm_close_reason_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'ICM_CLOSE_REASON_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_close_reason_type.lookup_types_tls.build(:lookup_type_id=>icm_close_reason_type.id,:meaning=>'ICM关闭事件类型',:description=>'ICM关闭事件类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_close_reason_type.lookup_types_tls.build(:lookup_type_id=>icm_close_reason_type.id,:meaning=>'ICM close reason type',:description=>'ICM close reason type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_close_reason_type.save
    system_yes_no=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SYSTEM_YES_NO',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_yes_no.lookup_types_tls.build(:lookup_type_id=>system_yes_no.id,:meaning=>'系统初始化YES_NO',:description=>'系统初始化YES_NO',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_yes_no.lookup_types_tls.build(:lookup_type_id=>system_yes_no.id,:meaning=>'Init SYSTEM_YES_NO',:description=>'Init SYSTEM_YES_NO',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_yes_no.save
    icm_request_type_code=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'ICM_REQUEST_TYPE_CODE',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_request_type_code.lookup_types_tls.build(:lookup_type_id=>icm_request_type_code.id,:meaning=>'事故单请求类型',:description=>'事故单请求类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_type_code.lookup_types_tls.build(:lookup_type_id=>icm_request_type_code.id,:meaning=>'Incident request type',:description=>'Incident request type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_type_code.save
    icm_request_report_source=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'ICM_REQUEST_REPORT_SOURCE',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_request_report_source.lookup_types_tls.build(:lookup_type_id=>icm_request_report_source.id,:meaning=>'事故单来源类型',:description=>'事故单来源类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_report_source.lookup_types_tls.build(:lookup_type_id=>icm_request_report_source.id,:meaning=>'Incident report source',:description=>'Incident report source',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_report_source.save
    skm_file_categories=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SKM_FILE_CATEGORIES',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_file_categories.lookup_types_tls.build(:lookup_type_id=>skm_file_categories.id,:meaning=>'文件类型',:description=>'文件类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categories.lookup_types_tls.build(:lookup_type_id=>skm_file_categories.id,:meaning=>'File Categories',:description=>'File Categories',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categories.save
    irm_sys_para_content_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_SYS_PARA_CONTENT_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_content_type.lookup_types_tls.build(:lookup_type_id=>irm_sys_para_content_type.id,:meaning=>'参数类型',:description=>'参数类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_content_type.lookup_types_tls.build(:lookup_type_id=>irm_sys_para_content_type.id,:meaning=>'Parameter Content Type',:description=>'Parameter Content Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_content_type.save
    irm_sys_para_data_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_SYS_PARA_DATA_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_data_type.lookup_types_tls.build(:lookup_type_id=>irm_sys_para_data_type.id,:meaning=>'参数数据类型',:description=>'参数数据类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_type.lookup_types_tls.build(:lookup_type_id=>irm_sys_para_data_type.id,:meaning=>'Parameter Data Type',:description=>'Parameter Data Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_type.save
    irm_todo_event_priority=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_TODO_EVENT_PRIORITY',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_priority.lookup_types_tls.build(:lookup_type_id=>irm_todo_event_priority.id,:meaning=>'事件优先级',:description=>'事件优先级',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_priority.lookup_types_tls.build(:lookup_type_id=>irm_todo_event_priority.id,:meaning=>'Event Priorities',:description=>'Event Priorities',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_priority.save
    irm_todo_event_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_TODO_EVENT_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_status.lookup_types_tls.build(:lookup_type_id=>irm_todo_event_status.id,:meaning=>'事件状态',:description=>'事件状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_status.lookup_types_tls.build(:lookup_type_id=>irm_todo_event_status.id,:meaning=>'Event Statuses',:description=>'Event Statuses',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_status.save
    bo_attribute_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'BO_ATTRIBUTE_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_type.lookup_types_tls.build(:lookup_type_id=>bo_attribute_type.id,:meaning=>'业务对像属性类型',:description=>'业务对像属性类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_type.lookup_types_tls.build(:lookup_type_id=>bo_attribute_type.id,:meaning=>'Business Object Attribute Type',:description=>'Business Object Attribute Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_type.save
    bo_attribute_relation_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'BO_ATTRIBUTE_RELATION_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_relation_type.lookup_types_tls.build(:lookup_type_id=>bo_attribute_relation_type.id,:meaning=>'业务对像属性关联类型',:description=>'业务对像属性关联类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_relation_type.lookup_types_tls.build(:lookup_type_id=>bo_attribute_relation_type.id,:meaning=>'BO Attribute Relation Type',:description=>'BO Attribute Relation Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_relation_type.save
    workflow_rule_evaluate_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WORKFLOW_RULE_EVALUATE_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    workflow_rule_evaluate_type.lookup_types_tls.build(:lookup_type_id=>workflow_rule_evaluate_type.id,:meaning=>'工作流规则触发类型',:description=>'工作流规则触发类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_type.lookup_types_tls.build(:lookup_type_id=>workflow_rule_evaluate_type.id,:meaning=>'Workflow rule evaluate type',:description=>'Workflow rule evaluate type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_type.save
    workflow_rule_evaluate_mode=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WORKFLOW_RULE_EVALUATE_MODE',:status_code=>'ENABLED',:not_auto_mult=>true)
    workflow_rule_evaluate_mode.lookup_types_tls.build(:lookup_type_id=>workflow_rule_evaluate_mode.id,:meaning=>'工作流规则触发验证方式',:description=>'工作流规则触发验证方式',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_mode.lookup_types_tls.build(:lookup_type_id=>workflow_rule_evaluate_mode.id,:meaning=>'Workflow rule evaluate mode',:description=>'Workflow rule evaluate mode',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_mode.save
    rule_filter_operator=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'RULE_FILTER_OPERATOR',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operator.lookup_types_tls.build(:lookup_type_id=>rule_filter_operator.id,:meaning=>'规则过滤器操作符',:description=>'规则过滤器操作符',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operator.lookup_types_tls.build(:lookup_type_id=>rule_filter_operator.id,:meaning=>'Rule Filter Operator',:description=>'Rule Filter Operator',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operator.save
    wf_field_update_value_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_FIELD_UPDATE_VALUE_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_field_update_value_type.lookup_types_tls.build(:lookup_type_id=>wf_field_update_value_type.id,:meaning=>'工作流字段更新值类型',:description=>'工作流字段更新值类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_field_update_value_type.lookup_types_tls.build(:lookup_type_id=>wf_field_update_value_type.id,:meaning=>'Workflow field update value type',:description=>'Workflow field update value type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_field_update_value_type.save
    irm_formula_function_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_FORMULA_FUNCTION_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_formula_function_type.lookup_types_tls.build(:lookup_type_id=>irm_formula_function_type.id,:meaning=>'公式函数类型',:description=>'公式函数类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_type.lookup_types_tls.build(:lookup_type_id=>irm_formula_function_type.id,:meaning=>'Formula function type',:description=>'Formula function type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_type.save
    wf_mail_alert_recipient_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_MAIL_ALERT_RECIPIENT_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_mail_alert_recipient_type.lookup_types_tls.build(:lookup_type_id=>wf_mail_alert_recipient_type.id,:meaning=>'邮件警告收件人类型',:description=>'邮件警告收件人类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_mail_alert_recipient_type.lookup_types_tls.build(:lookup_type_id=>wf_mail_alert_recipient_type.id,:meaning=>'Mail alert recipient',:description=>'Mail alert recipient',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_mail_alert_recipient_type.save
    wf_rule_trigger_time_unit=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_RULE_TRIGGER_TIME_UNIT',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_rule_trigger_time_unit.lookup_types_tls.build(:lookup_type_id=>wf_rule_trigger_time_unit.id,:meaning=>'工作流规则触发器时间单位',:description=>'工作流规则触发器时间单位',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_unit.lookup_types_tls.build(:lookup_type_id=>wf_rule_trigger_time_unit.id,:meaning=>'Workflow rule trigger time unit',:description=>'Workflow rule trigger time unit',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_unit.save
    wf_rule_trigger_time_mode=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_RULE_TRIGGER_TIME_MODE',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_rule_trigger_time_mode.lookup_types_tls.build(:lookup_type_id=>wf_rule_trigger_time_mode.id,:meaning=>'工作流规则触发器时间触发方式',:description=>'工作流规则触发器时间触发方式',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_mode.lookup_types_tls.build(:lookup_type_id=>wf_rule_trigger_time_mode.id,:meaning=>'Workflow rule trigger time mode',:description=>'Workflow rule trigger time mode',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_mode.save
    wf_process_record_editability=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_PROCESS_RECORD_EDITABILITY',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_record_editability.lookup_types_tls.build(:lookup_type_id=>wf_process_record_editability.id,:meaning=>'审批流程记录编辑性',:description=>'审批流程记录编辑性',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_record_editability.lookup_types_tls.build(:lookup_type_id=>wf_process_record_editability.id,:meaning=>'Process record editability',:description=>'Process record editability',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_record_editability.save
    wf_step_evaluate_resutl=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_STEP_EVALUATE_RESUTL',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_evaluate_resutl.lookup_types_tls.build(:lookup_type_id=>wf_step_evaluate_resutl.id,:meaning=>'审批步骤条件审批模式',:description=>'审批步骤条件审批模式',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutl.lookup_types_tls.build(:lookup_type_id=>wf_step_evaluate_resutl.id,:meaning=>'Process step evaluate result',:description=>'Process step evaluate result',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutl.save
    wf_step_approver_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_STEP_APPROVER_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_approver_type.lookup_types_tls.build(:lookup_type_id=>wf_step_approver_type.id,:meaning=>'审批步骤审批人类型',:description=>'审批步骤审批人类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_approver_type.lookup_types_tls.build(:lookup_type_id=>wf_step_approver_type.id,:meaning=>'Process step approver type',:description=>'Process step approver type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_approver_type.save
    wf_step_mulit_approver_mode=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_STEP_MULIT_APPROVER_MODE',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_mulit_approver_mode.lookup_types_tls.build(:lookup_type_id=>wf_step_mulit_approver_mode.id,:meaning=>'审批步骤多审批人审批模式',:description=>'审批步骤多审批人审批模式',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_mulit_approver_mode.lookup_types_tls.build(:lookup_type_id=>wf_step_mulit_approver_mode.id,:meaning=>'Process step multiple approver mode',:description=>'Process step multiple approver mode',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_mulit_approver_mode.save
    wf_step_reject_mode=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_STEP_REJECT_MODE',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_reject_mode.lookup_types_tls.build(:lookup_type_id=>wf_step_reject_mode.id,:meaning=>'审批步骤拒绝操作',:description=>'审批步骤拒绝操作',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_reject_mode.lookup_types_tls.build(:lookup_type_id=>wf_step_reject_mode.id,:meaning=>'Process step reject operation',:description=>'Process step reject operation',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_reject_mode.save
    wf_process_instance_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_PROCESS_INSTANCE_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_instance_status.lookup_types_tls.build(:lookup_type_id=>wf_process_instance_status.id,:meaning=>'审批流程状态',:description=>'审批流程状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_status.lookup_types_tls.build(:lookup_type_id=>wf_process_instance_status.id,:meaning=>'Approval Process Status',:description=>'Approval Process Status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_status.save
    wf_step_instance_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WF_STEP_INSTANCE_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_status.lookup_types_tls.build(:lookup_type_id=>wf_step_instance_status.id,:meaning=>'审批步骤状态',:description=>'审批步骤状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_status.lookup_types_tls.build(:lookup_type_id=>wf_step_instance_status.id,:meaning=>'Approval Step Status',:description=>'Approval Step Status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_status.save
    irm_delayed_job_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_DELAYED_JOB_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_status.lookup_types_tls.build(:lookup_type_id=>irm_delayed_job_status.id,:meaning=>'Delayed Job状态',:description=>'Delayed Job状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_status.lookup_types_tls.build(:lookup_type_id=>irm_delayed_job_status.id,:meaning=>'Delayed Job Status',:description=>'Delayed Job Status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_status.save
    irm_report_folder_access_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_REPORT_FOLDER_ACCESS_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_access_type.lookup_types_tls.build(:lookup_type_id=>irm_report_folder_access_type.id,:meaning=>'报表文件夹非私有报表访问类型',:description=>'报表文件夹非私有报表访问类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_type.lookup_types_tls.build(:lookup_type_id=>irm_report_folder_access_type.id,:meaning=>'Report Folder Else report Access Type',:description=>'Report Folder Else report Access Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_type.save
    irm_report_date_group_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_REPORT_DATE_GROUP_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_date_group_type.lookup_types_tls.build(:lookup_type_id=>irm_report_date_group_type.id,:meaning=>'报表日期列分组方式',:description=>'报表日期列分组方式',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_type.lookup_types_tls.build(:lookup_type_id=>irm_report_date_group_type.id,:meaning=>'Report Column Date Group Type',:description=>'Report Column Date Group Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_type.save
    irm_report_group_column_sort=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_REPORT_GROUP_COLUMN_SORT',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_group_column_sort.lookup_types_tls.build(:lookup_type_id=>irm_report_group_column_sort.id,:meaning=>'报表分组列排序方式',:description=>'报表分组列排序方式',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sort.lookup_types_tls.build(:lookup_type_id=>irm_report_group_column_sort.id,:meaning=>'Report Group Column Sort Type',:description=>'Report Group Column Sort Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sort.save
    irm_report_folder_member_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_REPORT_FOLDER_MEMBER_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_member_type.lookup_types_tls.build(:lookup_type_id=>irm_report_folder_member_type.id,:meaning=>'报表文件夹可访问成员类型',:description=>'报表文件夹可访问成员类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_type.lookup_types_tls.build(:lookup_type_id=>irm_report_folder_member_type.id,:meaning=>'Report Folder Member Type',:description=>'Report Folder Member Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_type.save
    irm_function_group_zone=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zone.lookup_types_tls.build(:lookup_type_id=>irm_function_group_zone.id,:meaning=>'功能组分区类型',:description=>'功能组分区类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone.lookup_types_tls.build(:lookup_type_id=>irm_function_group_zone.id,:meaning=>'Function Group Zone',:description=>'Function Group Zone',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zone.save
    irm_profile_user_license=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PROFILE_USER_LICENSE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_profile_user_license.lookup_types_tls.build(:lookup_type_id=>irm_profile_user_license.id,:meaning=>'简档用户类型',:description=>'简档用户类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_license.lookup_types_tls.build(:lookup_type_id=>irm_profile_user_license.id,:meaning=>'Profile User License',:description=>'Profile User License',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_license.save
    icm_incident_request_event=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_event.lookup_types_tls.build(:lookup_type_id=>icm_incident_request_event.id,:meaning=>'事故单处理过程中的事件',:description=>'事故单处理过程中的事件',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_event.lookup_types_tls.build(:lookup_type_id=>icm_incident_request_event.id,:meaning=>'Incident request Event',:description=>'Incident request Event',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_event.save
    irm_psw_expire_in=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_EXPIRE_IN',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in.lookup_types_tls.build(:lookup_type_id=>irm_psw_expire_in.id,:meaning=>'用户密码有效期',:description=>'用户密码有效期',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in.lookup_types_tls.build(:lookup_type_id=>irm_psw_expire_in.id,:meaning=>'User Password Expire Days',:description=>'User Password Expire Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in.save
    irm_psw_enforce_history=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history.lookup_types_tls.build(:lookup_type_id=>irm_psw_enforce_history.id,:meaning=>'强制密码历史',:description=>'强制密码历史',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history.lookup_types_tls.build(:lookup_type_id=>irm_psw_enforce_history.id,:meaning=>'Enforce Password History',:description=>'Enforce Password History',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history.save
    irm_psw_minimum_length=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_MINIMUM_LENGTH',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_minimum_length.lookup_types_tls.build(:lookup_type_id=>irm_psw_minimum_length.id,:meaning=>'密码最小长度',:description=>'密码最小长度',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length.lookup_types_tls.build(:lookup_type_id=>irm_psw_minimum_length.id,:meaning=>'Minimum Password Length',:description=>'Minimum Password Length',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length.save
    irm_psw_complexity_req=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_COMPLEXITY_REQ',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_complexity_req.lookup_types_tls.build(:lookup_type_id=>irm_psw_complexity_req.id,:meaning=>'密码复杂性要求',:description=>'密码复杂性要求',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req.lookup_types_tls.build(:lookup_type_id=>irm_psw_complexity_req.id,:meaning=>'Password Complexity Requirement',:description=>'Password Complexity Requirement',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req.save
    irm_psw_question_req=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_QUESTION_REQ',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_question_req.lookup_types_tls.build(:lookup_type_id=>irm_psw_question_req.id,:meaning=>'密码提问要求',:description=>'密码提问要求',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req.lookup_types_tls.build(:lookup_type_id=>irm_psw_question_req.id,:meaning=>'Password Question Requirement',:description=>'Password Question Requirement',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req.save
    irm_psw_maximum_attempts=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts.lookup_types_tls.build(:lookup_type_id=>irm_psw_maximum_attempts.id,:meaning=>'最大无效登陆尝试次数',:description=>'最大无效登陆尝试次数',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts.lookup_types_tls.build(:lookup_type_id=>irm_psw_maximum_attempts.id,:meaning=>'Maximum Invalid Login Attempts',:description=>'Maximum Invalid Login Attempts',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts.save
    irm_psw_lockout_period=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period.lookup_types_tls.build(:lookup_type_id=>irm_psw_lockout_period.id,:meaning=>'锁定有效期间',:description=>'锁定有效期间',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period.lookup_types_tls.build(:lookup_type_id=>irm_psw_lockout_period.id,:meaning=>'Lockout Effective Period',:description=>'Lockout Effective Period',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period.save
    irm_kanban_position=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_KANBAN_POSITION',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_kanban_position.lookup_types_tls.build(:lookup_type_id=>irm_kanban_position.id,:meaning=>'看板位置',:description=>'看板位置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_position.lookup_types_tls.build(:lookup_type_id=>irm_kanban_position.id,:meaning=>'Kanban Position',:description=>'Kanban Position',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_position.save

    system_status_codeenabled= Irm::LookupValue.new(:lookup_type=>'SYSTEM_STATUS_CODE',:lookup_code=>'ENABLED',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_status_codeenabled.lookup_values_tls.build(:lookup_value_id=>system_status_codeenabled.id,:meaning=>'可用',:description=>'可用',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codeenabled.lookup_values_tls.build(:lookup_value_id=>system_status_codeenabled.id,:meaning=>'Enabled',:description=>'Enabled',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codeenabled.save
    system_status_codearchive= Irm::LookupValue.new(:lookup_type=>'SYSTEM_STATUS_CODE',:lookup_code=>'ARCHIVE',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_status_codearchive.lookup_values_tls.build(:lookup_value_id=>system_status_codearchive.id,:meaning=>'归档',:description=>'归档',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codearchive.lookup_values_tls.build(:lookup_value_id=>system_status_codearchive.id,:meaning=>'Archive',:description=>'Archive',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codearchive.save
    system_status_codedelete= Irm::LookupValue.new(:lookup_type=>'SYSTEM_STATUS_CODE',:lookup_code=>'DELETE',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_status_codedelete.lookup_values_tls.build(:lookup_value_id=>system_status_codedelete.id,:meaning=>'删除',:description=>'删除',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codedelete.lookup_values_tls.build(:lookup_value_id=>system_status_codedelete.id,:meaning=>'Delete',:description=>'Delete',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codedelete.save
    system_status_codeobsolete= Irm::LookupValue.new(:lookup_type=>'SYSTEM_STATUS_CODE',:lookup_code=>'OBSOLETE',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_status_codeobsolete.lookup_values_tls.build(:lookup_value_id=>system_status_codeobsolete.id,:meaning=>'已过时',:description=>'已过时',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codeobsolete.lookup_values_tls.build(:lookup_value_id=>system_status_codeobsolete.id,:meaning=>'Obsolete',:description=>'Obsolete',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codeobsolete.save
    system_status_codeoffline= Irm::LookupValue.new(:lookup_type=>'SYSTEM_STATUS_CODE',:lookup_code=>'OFFLINE',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_status_codeoffline.lookup_values_tls.build(:lookup_value_id=>system_status_codeoffline.id,:meaning=>'离线',:description=>'离线',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codeoffline.lookup_values_tls.build(:lookup_value_id=>system_status_codeoffline.id,:meaning=>'Offline',:description=>'Offline',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codeoffline.save
    system_status_codeproposed= Irm::LookupValue.new(:lookup_type=>'SYSTEM_STATUS_CODE',:lookup_code=>'PROPOSED',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_status_codeproposed.lookup_values_tls.build(:lookup_value_id=>system_status_codeproposed.id,:meaning=>'建议',:description=>'建议',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codeproposed.lookup_values_tls.build(:lookup_value_id=>system_status_codeproposed.id,:meaning=>'Proposed',:description=>'Proposed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_status_codeproposed.save
    active_statusenabled= Irm::LookupValue.new(:lookup_type=>'ACTIVE_STATUS',:lookup_code=>'ENABLED',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    active_statusenabled.lookup_values_tls.build(:lookup_value_id=>active_statusenabled.id,:meaning=>'启用',:description=>'启用',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    active_statusenabled.lookup_values_tls.build(:lookup_value_id=>active_statusenabled.id,:meaning=>'Enabled',:description=>'Enabled',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    active_statusenabled.save
    active_statusoffline= Irm::LookupValue.new(:lookup_type=>'ACTIVE_STATUS',:lookup_code=>'OFFLINE',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    active_statusoffline.lookup_values_tls.build(:lookup_value_id=>active_statusoffline.id,:meaning=>'失效',:description=>'失效',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    active_statusoffline.lookup_values_tls.build(:lookup_value_id=>active_statusoffline.id,:meaning=>'Offline',:description=>'Offline',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    active_statusoffline.save
    icm_process_typenormal_process= Irm::LookupValue.new(:lookup_type=>'ICM_PROCESS_TYPE',:lookup_code=>'NORMAL_PROCESS',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_process_typenormal_process.lookup_values_tls.build(:lookup_value_id=>icm_process_typenormal_process.id,:meaning=>'普通流程',:description=>'普通流程',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_process_typenormal_process.lookup_values_tls.build(:lookup_value_id=>icm_process_typenormal_process.id,:meaning=>'Normal process',:description=>'Normal process',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_process_typenormal_process.save
    icm_close_reason_typeproblem_report= Irm::LookupValue.new(:lookup_type=>'ICM_CLOSE_REASON_TYPE',:lookup_code=>'PROBLEM_REPORT',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_close_reason_typeproblem_report.lookup_values_tls.build(:lookup_value_id=>icm_close_reason_typeproblem_report.id,:meaning=>'错误报告',:description=>'错误报告',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_close_reason_typeproblem_report.lookup_values_tls.build(:lookup_value_id=>icm_close_reason_typeproblem_report.id,:meaning=>'Problem Report',:description=>'Problem Report',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_close_reason_typeproblem_report.save
    system_yes_noy= Irm::LookupValue.new(:lookup_type=>'SYSTEM_YES_NO',:lookup_code=>'Y',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_yes_noy.lookup_values_tls.build(:lookup_value_id=>system_yes_noy.id,:meaning=>'是',:description=>'是',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_yes_noy.lookup_values_tls.build(:lookup_value_id=>system_yes_noy.id,:meaning=>'Y',:description=>'Y',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_yes_noy.save
    system_yes_non= Irm::LookupValue.new(:lookup_type=>'SYSTEM_YES_NO',:lookup_code=>'N',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    system_yes_non.lookup_values_tls.build(:lookup_value_id=>system_yes_non.id,:meaning=>'否',:description=>'否',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    system_yes_non.lookup_values_tls.build(:lookup_value_id=>system_yes_non.id,:meaning=>'N',:description=>'N',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    system_yes_non.save
    icm_request_type_coderequested_to_perform= Irm::LookupValue.new(:lookup_type=>'ICM_REQUEST_TYPE_CODE',:lookup_code=>'REQUESTED_TO_PERFORM',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_request_type_coderequested_to_perform.lookup_values_tls.build(:lookup_value_id=>icm_request_type_coderequested_to_perform.id,:meaning=>'请求履行',:description=>'请求履行',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_type_coderequested_to_perform.lookup_values_tls.build(:lookup_value_id=>icm_request_type_coderequested_to_perform.id,:meaning=>'Request to perform',:description=>'Request to perform',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_type_coderequested_to_perform.save
    icm_request_type_coderequested_to_change= Irm::LookupValue.new(:lookup_type=>'ICM_REQUEST_TYPE_CODE',:lookup_code=>'REQUESTED_TO_CHANGE',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_request_type_coderequested_to_change.lookup_values_tls.build(:lookup_value_id=>icm_request_type_coderequested_to_change.id,:meaning=>'请求变更',:description=>'请求变更',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_type_coderequested_to_change.lookup_values_tls.build(:lookup_value_id=>icm_request_type_coderequested_to_change.id,:meaning=>'Request to change',:description=>'Request to change',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_type_coderequested_to_change.save
    icm_request_report_sourcecustomer_submit= Irm::LookupValue.new(:lookup_type=>'ICM_REQUEST_REPORT_SOURCE',:lookup_code=>'CUSTOMER_SUBMIT',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_request_report_sourcecustomer_submit.lookup_values_tls.build(:lookup_value_id=>icm_request_report_sourcecustomer_submit.id,:meaning=>'客户提交',:description=>'客户提交',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_report_sourcecustomer_submit.lookup_values_tls.build(:lookup_value_id=>icm_request_report_sourcecustomer_submit.id,:meaning=>'Customer submit',:description=>'Customer submit',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_report_sourcecustomer_submit.save
    icm_request_report_sourcecustomer_phone_call= Irm::LookupValue.new(:lookup_type=>'ICM_REQUEST_REPORT_SOURCE',:lookup_code=>'CUSTOMER_PHONE_CALL',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_request_report_sourcecustomer_phone_call.lookup_values_tls.build(:lookup_value_id=>icm_request_report_sourcecustomer_phone_call.id,:meaning=>'客户电话',:description=>'客户电话',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_report_sourcecustomer_phone_call.lookup_values_tls.build(:lookup_value_id=>icm_request_report_sourcecustomer_phone_call.id,:meaning=>'Customer phone call',:description=>'Customer phone call',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_report_sourcecustomer_phone_call.save
    timezonegmt_p1400= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1400',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1400.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1400.id,:meaning=>'(格林威治标准时间+14：00) Line 岛时间 (Pacific/Kiritimati)',:description=>'(格林威治标准时间+14：00) Line 岛时间 (Pacific/Kiritimati)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1400.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1400.id,:meaning=>'(GMT+14:00) Line Is. Time (Pacific/Kiritimati)',:description=>'(GMT+14:00) Line Is. Time (Pacific/Kiritimati)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1400.save
    timezonegmt_p1300= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1300',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1300.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1300.id,:meaning=>'(格林威治标准时间+13：00) 菲尼克斯群岛时间 (Pacific/Enderbury)',:description=>'(格林威治标准时间+13：00) 菲尼克斯群岛时间 (Pacific/Enderbury)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1300.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1300.id,:meaning=>'(GMT+13:00) Phoenix Is. Time (Pacific/Enderbury)',:description=>'(GMT+13:00) Phoenix Is. Time (Pacific/Enderbury)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1300.save
    timezonegmt_p1300_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1300_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1300_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1300_2.id,:meaning=>'(格林威治标准时间+13：00) 东加时间 (Pacific/Tongatapu)',:description=>'(格林威治标准时间+13：00) 东加时间 (Pacific/Tongatapu)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1300_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1300_2.id,:meaning=>'(GMT+13:00) Tonga Time (Pacific/Tongatapu)',:description=>'(GMT+13:00) Tonga Time (Pacific/Tongatapu)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1300_2.save
    timezonegmt_p1245= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1245',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1245.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1245.id,:meaning=>'(格林威治标准时间+12：45) 查萨姆夏令时 (Pacific/Chatham)',:description=>'(格林威治标准时间+12：45) 查萨姆夏令时 (Pacific/Chatham)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1245.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1245.id,:meaning=>'(GMT+12:45) Chatham Daylight Time (Pacific/Chatham)',:description=>'(GMT+12:45) Chatham Daylight Time (Pacific/Chatham)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1245.save
    timezonegmt_p1200= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1200',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1200.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1200.id,:meaning=>'(格林威治标准时间+12：00) 彼得罗巴甫洛夫斯克时间 (Asia/Kamchatka)',:description=>'(格林威治标准时间+12：00) 彼得罗巴甫洛夫斯克时间 (Asia/Kamchatka)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1200.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1200.id,:meaning=>'(GMT+12:00) Petropavlovsk-Kamchatski Time (Asia/Kamchatka)',:description=>'(GMT+12:00) Petropavlovsk-Kamchatski Time (Asia/Kamchatka)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1200.save
    timezonegmt_p1200_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1200_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1200_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1200_2.id,:meaning=>'(格林威治标准时间+12：00) 新西兰夏令时 (Pacific/Auckland)',:description=>'(格林威治标准时间+12：00) 新西兰夏令时 (Pacific/Auckland)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1200_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1200_2.id,:meaning=>'(GMT+12:00) New Zealand Daylight Time (Pacific/Auckland)',:description=>'(GMT+12:00) New Zealand Daylight Time (Pacific/Auckland)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1200_2.save
    timezonegmt_p1200_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1200_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1200_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1200_3.id,:meaning=>'(格林威治标准时间+12：00) 斐济时间 (Pacific/Fiji)',:description=>'(格林威治标准时间+12：00) 斐济时间 (Pacific/Fiji)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1200_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1200_3.id,:meaning=>'(GMT+12:00) Fiji Time (Pacific/Fiji)',:description=>'(GMT+12:00) Fiji Time (Pacific/Fiji)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1200_3.save
    timezonegmt_p1130= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1130',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1130.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1130.id,:meaning=>'(格林威治标准时间+11：30) 诺福克时间 (Pacific/Norfolk)',:description=>'(格林威治标准时间+11：30) 诺福克时间 (Pacific/Norfolk)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1130.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1130.id,:meaning=>'(GMT+11:30) Norfolk Time (Pacific/Norfolk)',:description=>'(GMT+11:30) Norfolk Time (Pacific/Norfolk)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1130.save
    timezonegmt_p1100= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1100',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1100.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1100.id,:meaning=>'(格林威治标准时间+11：00) 所罗门群岛时间 (Pacific/Guadalcanal)',:description=>'(格林威治标准时间+11：00) 所罗门群岛时间 (Pacific/Guadalcanal)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1100.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1100.id,:meaning=>'(GMT+11:00) Solomon Is. Time (Pacific/Guadalcanal)',:description=>'(GMT+11:00) Solomon Is. Time (Pacific/Guadalcanal)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1100.save
    timezonegmt_p1030= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1030',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1030.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1030.id,:meaning=>'(格林威治标准时间+10：30) 豪公夏令时 (Australia/Lord_Howe)',:description=>'(格林威治标准时间+10：30) 豪公夏令时 (Australia/Lord_Howe)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1030.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1030.id,:meaning=>'(GMT+10:30) Lord Howe Summer Time (Australia/Lord_Howe)',:description=>'(GMT+10:30) Lord Howe Summer Time (Australia/Lord_Howe)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1030.save
    timezonegmt_p1000= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1000',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1000.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1000.id,:meaning=>'(格林威治标准时间+10：00) 东部标准时间（昆士兰） (Australia/Brisbane)',:description=>'(格林威治标准时间+10：00) 东部标准时间（昆士兰） (Australia/Brisbane)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1000.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1000.id,:meaning=>'(GMT+10:00) Eastern Standard Time (Queensland)',:description=>'(GMT+10:00) Eastern Standard Time (Queensland)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1000.save
    timezonegmt_p1000_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P1000_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p1000_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1000_2.id,:meaning=>'(格林威治标准时间+10：00) 东部夏令时（新南威尔斯） (Australia/Sydney)',:description=>'(格林威治标准时间+10：00) 东部夏令时（新南威尔斯） (Australia/Sydney)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1000_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p1000_2.id,:meaning=>'(GMT+10:00) Eastern Summer Time (New South Wales)',:description=>'(GMT+10:00) Eastern Summer Time (New South Wales)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p1000_2.save
    timezonegmt_p0930= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0930',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0930.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0930.id,:meaning=>'(格林威治标准时间+09：30) 中央夏令时（南澳大利亚） (Australia/Adelaide)',:description=>'(格林威治标准时间+09：30) 中央夏令时（南澳大利亚） (Australia/Adelaide)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0930.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0930.id,:meaning=>'(GMT+09:30) Central Summer Time (South Australia)',:description=>'(GMT+09:30) Central Summer Time (South Australia)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0930.save
    timezonegmt_p0930_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0930_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0930_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0930_2.id,:meaning=>'(格林威治标准时间+09：30) 中央标准时间（北领地） (Australia/Darwin)',:description=>'(格林威治标准时间+09：30) 中央标准时间（北领地） (Australia/Darwin)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0930_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0930_2.id,:meaning=>'(GMT+09:30) Central Standard Time (Northern Territory)',:description=>'(GMT+09:30) Central Standard Time (Northern Territory)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0930_2.save
    timezonegmt_p0900= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0900',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0900.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0900.id,:meaning=>'(格林威治标准时间+09：00) 韩国标准时间 (Asia/Seoul)',:description=>'(格林威治标准时间+09：00) 韩国标准时间 (Asia/Seoul)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0900.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0900.id,:meaning=>'(GMT+09:00) Korea Standard Time (Asia/Seoul)',:description=>'(GMT+09:00) Korea Standard Time (Asia/Seoul)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0900.save
    timezonegmt_p0900_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0900_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0900_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0900_2.id,:meaning=>'(格林威治标准时间+09：00) 日本标准时间 (Asia/Tokyo)',:description=>'(格林威治标准时间+09：00) 日本标准时间 (Asia/Tokyo)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0900_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0900_2.id,:meaning=>'(GMT+09:00) Japan Standard Time (Asia/Tokyo)',:description=>'(GMT+09:00) Japan Standard Time (Asia/Tokyo)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0900_2.save
    timezonegmt_p0800= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0800',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0800.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800.id,:meaning=>'(格林威治标准时间+08：00) 香港时间 (Asia/Hong_Kong)',:description=>'(格林威治标准时间+08：00) 香港时间 (Asia/Hong_Kong)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800.id,:meaning=>'(GMT+08:00) Hong Kong Time (Asia/Hong_Kong)',:description=>'(GMT+08:00) Hong Kong Time (Asia/Hong_Kong)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800.save
    timezonegmt_p0800_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0800_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0800_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_2.id,:meaning=>'(格林威治标准时间+08：00) 马来西亚时间 (Asia/Kuala_Lumpur)',:description=>'(格林威治标准时间+08：00) 马来西亚时间 (Asia/Kuala_Lumpur)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_2.id,:meaning=>'(GMT+08:00) Malaysia Time (Asia/Kuala_Lumpur)',:description=>'(GMT+08:00) Malaysia Time (Asia/Kuala_Lumpur)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_2.save
    timezonegmt_p0800_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0800_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0800_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_3.id,:meaning=>'(格林威治标准时间+08：00) 菲律宾时间 (Asia/Manila)',:description=>'(格林威治标准时间+08：00) 菲律宾时间 (Asia/Manila)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_3.id,:meaning=>'(GMT+08:00) Philippines Time (Asia/Manila)',:description=>'(GMT+08:00) Philippines Time (Asia/Manila)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_3.save
    timezonegmt_p0800_4= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0800_4',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0800_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_4.id,:meaning=>'(格林威治标准时间+08：00) 中国标准时间 (Asia/Shanghai)',:description=>'(格林威治标准时间+08：00) 中国标准时间 (Asia/Shanghai)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_4.id,:meaning=>'(GMT+08:00) China Standard Time (Asia/Shanghai)',:description=>'(GMT+08:00) China Standard Time (Asia/Shanghai)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_4.save
    timezonegmt_p0800_5= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0800_5',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0800_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_5.id,:meaning=>'(格林威治标准时间+08：00) 新加坡时间 (Asia/Singapore)',:description=>'(格林威治标准时间+08：00) 新加坡时间 (Asia/Singapore)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_5.id,:meaning=>'(GMT+08:00) Singapore Time (Asia/Singapore)',:description=>'(GMT+08:00) Singapore Time (Asia/Singapore)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_5.save
    timezonegmt_p0800_6= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0800_6',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0800_6.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_6.id,:meaning=>'(格林威治标准时间+08：00) 中国标准时间 (Asia/Taipei)',:description=>'(格林威治标准时间+08：00) 中国标准时间 (Asia/Taipei)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_6.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_6.id,:meaning=>'(GMT+08:00) China Standard Time (Asia/Taipei)',:description=>'(GMT+08:00) China Standard Time (Asia/Taipei)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_6.save
    timezonegmt_p0800_7= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0800_7',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0800_7.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_7.id,:meaning=>'(格林威治标准时间+08：00) 西部标准时间（澳大利亚） (Australia/Perth)',:description=>'(格林威治标准时间+08：00) 西部标准时间（澳大利亚） (Australia/Perth)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_7.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0800_7.id,:meaning=>'(GMT+08:00) Western Standard Time (Australia)',:description=>'(GMT+08:00) Western Standard Time (Australia)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0800_7.save
    timezonegmt_p0700= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0700',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0700.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0700.id,:meaning=>'(格林威治标准时间+07：00) 印度支那时间 (Asia/Bangkok)',:description=>'(格林威治标准时间+07：00) 印度支那时间 (Asia/Bangkok)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0700.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0700.id,:meaning=>'(GMT+07:00) Indochina Time (Asia/Bangkok)',:description=>'(GMT+07:00) Indochina Time (Asia/Bangkok)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0700.save
    timezonegmt_p0700_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0700_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0700_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0700_2.id,:meaning=>'(格林威治标准时间+07：00) 西印度尼西亚时间 (Asia/Jakarta)',:description=>'(格林威治标准时间+07：00) 西印度尼西亚时间 (Asia/Jakarta)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0700_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0700_2.id,:meaning=>'(GMT+07:00) West Indonesia Time (Asia/Jakarta)',:description=>'(GMT+07:00) West Indonesia Time (Asia/Jakarta)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0700_2.save
    timezonegmt_p0700_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0700_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0700_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0700_3.id,:meaning=>'(格林威治标准时间+07：00) 印度支那时间 (Asia/Saigon)',:description=>'(格林威治标准时间+07：00) 印度支那时间 (Asia/Saigon)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0700_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0700_3.id,:meaning=>'(GMT+07:00) Indochina Time (Asia/Saigon)',:description=>'(GMT+07:00) Indochina Time (Asia/Saigon)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0700_3.save
    timezonegmt_p0630= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0630',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0630.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0630.id,:meaning=>'(格林威治标准时间+06：30) 缅甸时间 (Asia/Rangoon)',:description=>'(格林威治标准时间+06：30) 缅甸时间 (Asia/Rangoon)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0630.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0630.id,:meaning=>'(GMT+06:30) Myanmar Time (Asia/Rangoon)',:description=>'(GMT+06:30) Myanmar Time (Asia/Rangoon)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0630.save
    timezonegmt_p0600= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0600',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0600.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0600.id,:meaning=>'(格林威治标准时间+06：00) 孟加拉夏令时 (Asia/Dacca)',:description=>'(格林威治标准时间+06：00) 孟加拉夏令时 (Asia/Dacca)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0600.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0600.id,:meaning=>'(GMT+06:00) Bangladesh Summer Time (Asia/Dacca)',:description=>'(GMT+06:00) Bangladesh Summer Time (Asia/Dacca)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0600.save
    timezonegmt_p0545= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0545',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0545.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0545.id,:meaning=>'(格林威治标准时间+05：45) 尼泊尔时间 (Asia/Katmandu)',:description=>'(格林威治标准时间+05：45) 尼泊尔时间 (Asia/Katmandu)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0545.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0545.id,:meaning=>'(GMT+05:45) Nepal Time (Asia/Katmandu)',:description=>'(GMT+05:45) Nepal Time (Asia/Katmandu)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0545.save
    timezonegmt_p0530= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0530',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0530.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0530.id,:meaning=>'(格林威治标准时间+05：30) 印度标准时间 (Asia/Calcutta)',:description=>'(格林威治标准时间+05：30) 印度标准时间 (Asia/Calcutta)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0530.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0530.id,:meaning=>'(GMT+05:30) India Standard Time (Asia/Calcutta)',:description=>'(GMT+05:30) India Standard Time (Asia/Calcutta)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0530.save
    timezonegmt_p0530_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0530_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0530_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0530_2.id,:meaning=>'(格林威治标准时间+05：30) 印度标准时间 (Asia/Colombo)',:description=>'(格林威治标准时间+05：30) 印度标准时间 (Asia/Colombo)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0530_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0530_2.id,:meaning=>'(GMT+05:30) India Standard Time (Asia/Colombo)',:description=>'(GMT+05:30) India Standard Time (Asia/Colombo)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0530_2.save
    timezonegmt_p0500= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0500',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0500.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0500.id,:meaning=>'(格林威治标准时间+05：00) 巴基斯坦时间 (Asia/Karachi)',:description=>'(格林威治标准时间+05：00) 巴基斯坦时间 (Asia/Karachi)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0500.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0500.id,:meaning=>'(GMT+05:00) Pakistan Time (Asia/Karachi)',:description=>'(GMT+05:00) Pakistan Time (Asia/Karachi)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0500.save
    timezonegmt_p0500_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0500_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0500_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0500_2.id,:meaning=>'(格林威治标准时间+05：00) 乌兹别克斯坦时间 (Asia/Tashkent)',:description=>'(格林威治标准时间+05：00) 乌兹别克斯坦时间 (Asia/Tashkent)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0500_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0500_2.id,:meaning=>'(GMT+05:00) Uzbekistan Time (Asia/Tashkent)',:description=>'(GMT+05:00) Uzbekistan Time (Asia/Tashkent)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0500_2.save
    timezonegmt_p0500_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0500_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0500_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0500_3.id,:meaning=>'(格林威治标准时间+05：00) Yekaterinburg 时间 (Asia/Yekaterinburg)',:description=>'(格林威治标准时间+05：00) Yekaterinburg 时间 (Asia/Yekaterinburg)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0500_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0500_3.id,:meaning=>'(GMT+05:00) Yekaterinburg Time (Asia/Yekaterinburg)',:description=>'(GMT+05:00) Yekaterinburg Time (Asia/Yekaterinburg)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0500_3.save
    timezonegmt_p0430= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0430',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0430.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0430.id,:meaning=>'(格林威治标准时间+04：30) 阿富汗时间 (Asia/Kabul)',:description=>'(格林威治标准时间+04：30) 阿富汗时间 (Asia/Kabul)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0430.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0430.id,:meaning=>'(GMT+04:30) Afghanistan Time (Asia/Kabul)',:description=>'(GMT+04:30) Afghanistan Time (Asia/Kabul)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0430.save
    timezonegmt_p0400= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0400',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0400.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0400.id,:meaning=>'(格林威治标准时间+04：00) 波斯湾标准时间 (Asia/Dubai)',:description=>'(格林威治标准时间+04：00) 波斯湾标准时间 (Asia/Dubai)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0400.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0400.id,:meaning=>'(GMT+04:00) Gulf Standard Time (Asia/Dubai)',:description=>'(GMT+04:00) Gulf Standard Time (Asia/Dubai)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0400.save
    timezonegmt_p0400_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0400_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0400_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0400_2.id,:meaning=>'(格林威治标准时间+04：00) 乔治亚时间 (Asia/Tbilisi)',:description=>'(格林威治标准时间+04：00) 乔治亚时间 (Asia/Tbilisi)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0400_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0400_2.id,:meaning=>'(GMT+04:00) Georgia Time (Asia/Tbilisi)',:description=>'(GMT+04:00) Georgia Time (Asia/Tbilisi)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0400_2.save
    timezonegmt_p0330= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0330',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0330.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0330.id,:meaning=>'(格林威治标准时间+03：30) 伊朗标准时间 (Asia/Tehran)',:description=>'(格林威治标准时间+03：30) 伊朗标准时间 (Asia/Tehran)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0330.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0330.id,:meaning=>'(GMT+03:30) Iran Standard Time (Asia/Tehran)',:description=>'(GMT+03:30) Iran Standard Time (Asia/Tehran)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0330.save
    timezonegmt_p0300= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0300',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0300.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300.id,:meaning=>'(格林威治标准时间+03：00) 东非时间 (Africa/Nairobi)',:description=>'(格林威治标准时间+03：00) 东非时间 (Africa/Nairobi)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300.id,:meaning=>'(GMT+03:00) Eastern African Time (Africa/Nairobi)',:description=>'(GMT+03:00) Eastern African Time (Africa/Nairobi)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300.save
    timezonegmt_p0300_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0300_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0300_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300_2.id,:meaning=>'(格林威治标准时间+03：00) 阿拉伯标准时间 (Asia/Baghdad)',:description=>'(格林威治标准时间+03：00) 阿拉伯标准时间 (Asia/Baghdad)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300_2.id,:meaning=>'(GMT+03:00) Arabia Standard Time (Asia/Baghdad)',:description=>'(GMT+03:00) Arabia Standard Time (Asia/Baghdad)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300_2.save
    timezonegmt_p0300_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0300_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0300_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300_3.id,:meaning=>'(格林威治标准时间+03：00) 阿拉伯标准时间 (Asia/Kuwait)',:description=>'(格林威治标准时间+03：00) 阿拉伯标准时间 (Asia/Kuwait)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300_3.id,:meaning=>'(GMT+03:00) Arabia Standard Time (Asia/Kuwait)',:description=>'(GMT+03:00) Arabia Standard Time (Asia/Kuwait)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300_3.save
    timezonegmt_p0300_4= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0300_4',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0300_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300_4.id,:meaning=>'(格林威治标准时间+03：00) 阿拉伯标准时间 (Asia/Riyadh)',:description=>'(格林威治标准时间+03：00) 阿拉伯标准时间 (Asia/Riyadh)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300_4.id,:meaning=>'(GMT+03:00) Arabia Standard Time (Asia/Riyadh)',:description=>'(GMT+03:00) Arabia Standard Time (Asia/Riyadh)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300_4.save
    timezonegmt_p0300_5= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0300_5',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0300_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300_5.id,:meaning=>'(格林威治标准时间+03：00) 莫斯科标准时间 (Europe/Moscow)',:description=>'(格林威治标准时间+03：00) 莫斯科标准时间 (Europe/Moscow)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0300_5.id,:meaning=>'(GMT+03:00) Moscow Standard Time (Europe/Moscow)',:description=>'(GMT+03:00) Moscow Standard Time (Europe/Moscow)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0300_5.save
    timezonegmt_p0200= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0200',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0200.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200.id,:meaning=>'(格林威治标准时间+02：00) 东欧时间 (Africa/Cairo)',:description=>'(格林威治标准时间+02：00) 东欧时间 (Africa/Cairo)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200.id,:meaning=>'(GMT+02:00) Eastern European Time (Africa/Cairo)',:description=>'(GMT+02:00) Eastern European Time (Africa/Cairo)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200.save
    timezonegmt_p0200_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0200_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0200_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_2.id,:meaning=>'(格林威治标准时间+02：00) 南非标准时间 (Africa/Johannesburg)',:description=>'(格林威治标准时间+02：00) 南非标准时间 (Africa/Johannesburg)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_2.id,:meaning=>'(GMT+02:00) South Africa Standard Time (Africa/Johannesburg)',:description=>'(GMT+02:00) South Africa Standard Time (Africa/Johannesburg)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_2.save
    timezonegmt_p0200_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0200_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0200_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_3.id,:meaning=>'(格林威治标准时间+02：00) 以色列标准时间 (Asia/Jerusalem)',:description=>'(格林威治标准时间+02：00) 以色列标准时间 (Asia/Jerusalem)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_3.id,:meaning=>'(GMT+02:00) Israel Standard Time (Asia/Jerusalem)',:description=>'(GMT+02:00) Israel Standard Time (Asia/Jerusalem)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_3.save
    timezonegmt_p0200_4= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0200_4',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0200_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_4.id,:meaning=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Athens)',:description=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Athens)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_4.id,:meaning=>'(GMT+02:00) Eastern European Time (Europe/Athens)',:description=>'(GMT+02:00) Eastern European Time (Europe/Athens)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_4.save
    timezonegmt_p0200_5= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0200_5',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0200_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_5.id,:meaning=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Bucharest)',:description=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Bucharest)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_5.id,:meaning=>'(GMT+02:00) Eastern European Time (Europe/Bucharest)',:description=>'(GMT+02:00) Eastern European Time (Europe/Bucharest)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_5.save
    timezonegmt_p0200_6= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0200_6',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0200_6.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_6.id,:meaning=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Helsinki)',:description=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Helsinki)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_6.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_6.id,:meaning=>'(GMT+02:00) Eastern European Time (Europe/Helsinki)',:description=>'(GMT+02:00) Eastern European Time (Europe/Helsinki)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_6.save
    timezonegmt_p0200_7= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0200_7',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0200_7.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_7.id,:meaning=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Istanbul)',:description=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Istanbul)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_7.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_7.id,:meaning=>'(GMT+02:00) Eastern European Time (Europe/Istanbul)',:description=>'(GMT+02:00) Eastern European Time (Europe/Istanbul)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_7.save
    timezonegmt_p0200_8= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0200_8',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0200_8.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_8.id,:meaning=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Minsk)',:description=>'(格林威治标准时间+02：00) 东欧时间 (Europe/Minsk)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_8.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0200_8.id,:meaning=>'(GMT+02:00) Eastern European Time (Europe/Minsk)',:description=>'(GMT+02:00) Eastern European Time (Europe/Minsk)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0200_8.save
    timezonegmt_p0100= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0100',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0100.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100.id,:meaning=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Amsterdam)',:description=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Amsterdam)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100.id,:meaning=>'(GMT+01:00) Central European Time (Europe/Amsterdam)',:description=>'(GMT+01:00) Central European Time (Europe/Amsterdam)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100.save
    timezonegmt_p0100_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0100_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0100_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_2.id,:meaning=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Berlin)',:description=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Berlin)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_2.id,:meaning=>'(GMT+01:00) Central European Time (Europe/Berlin)',:description=>'(GMT+01:00) Central European Time (Europe/Berlin)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_2.save
    timezonegmt_p0100_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0100_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0100_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_3.id,:meaning=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Brussels)',:description=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Brussels)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_3.id,:meaning=>'(GMT+01:00) Central European Time (Europe/Brussels)',:description=>'(GMT+01:00) Central European Time (Europe/Brussels)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_3.save
    timezonegmt_p0100_4= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0100_4',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0100_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_4.id,:meaning=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Paris)',:description=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Paris)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_4.id,:meaning=>'(GMT+01:00) Central European Time (Europe/Paris)',:description=>'(GMT+01:00) Central European Time (Europe/Paris)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_4.save
    timezonegmt_p0100_5= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0100_5',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0100_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_5.id,:meaning=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Prague)',:description=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Prague)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_5.id,:meaning=>'(GMT+01:00) Central European Time (Europe/Prague)',:description=>'(GMT+01:00) Central European Time (Europe/Prague)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_5.save
    timezonegmt_p0100_6= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0100_6',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0100_6.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_6.id,:meaning=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Rome)',:description=>'(格林威治标准时间+01：00) 中欧时间 (Europe/Rome)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_6.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0100_6.id,:meaning=>'(GMT+01:00) Central European Time (Europe/Rome)',:description=>'(GMT+01:00) Central European Time (Europe/Rome)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0100_6.save
    timezonegmt_p0000= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0000',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0000.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0000.id,:meaning=>'(格林威治标准时间+00：00) 格林威治时间 (Europe/Dublin)',:description=>'(格林威治标准时间+00：00) 格林威治时间 (Europe/Dublin)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0000.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0000.id,:meaning=>'(GMT+00:00) Greenwich Mean Time (Europe/Dublin)',:description=>'(GMT+00:00) Greenwich Mean Time (Europe/Dublin)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0000.save
    timezonegmt_p0000_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0000_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0000_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0000_2.id,:meaning=>'(格林威治标准时间+00：00) 西欧时间 (Europe/Lisbon)',:description=>'(格林威治标准时间+00：00) 西欧时间 (Europe/Lisbon)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0000_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0000_2.id,:meaning=>'(GMT+00:00) Western European Time (Europe/Lisbon)',:description=>'(GMT+00:00) Western European Time (Europe/Lisbon)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0000_2.save
    timezonegmt_p0000_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0000_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0000_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0000_3.id,:meaning=>'(格林威治标准时间+00：00) 格林威治时间 (Europe/London)',:description=>'(格林威治标准时间+00：00) 格林威治时间 (Europe/London)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0000_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0000_3.id,:meaning=>'(GMT+00:00) Greenwich Mean Time (Europe/London)',:description=>'(GMT+00:00) Greenwich Mean Time (Europe/London)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0000_3.save
    timezonegmt_p0000_4= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_P0000_4',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_p0000_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0000_4.id,:meaning=>'(格林威治标准时间+00：00) 格林威治时间 (GMT)',:description=>'(格林威治标准时间+00：00) 格林威治时间 (GMT)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0000_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_p0000_4.id,:meaning=>'(GMT+00:00) Greenwich Mean Time (GMT)',:description=>'(GMT+00:00) Greenwich Mean Time (GMT)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_p0000_4.save
    timezonegmt_m0100= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0100',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0100.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0100.id,:meaning=>'(格林威治标准时间-01：00) 佛德角时间 (Atlantic/Cape_Verde)',:description=>'(格林威治标准时间-01：00) 佛德角时间 (Atlantic/Cape_Verde)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0100.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0100.id,:meaning=>'(GMT-01:00) Cape Verde Time (Atlantic/Cape_Verde)',:description=>'(GMT-01:00) Cape Verde Time (Atlantic/Cape_Verde)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0100.save
    timezonegmt_m0200= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0200',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0200.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0200.id,:meaning=>'(格林威治标准时间-02：00) 南乔治亚标准时间 (Atlantic/South_Georgia)',:description=>'(格林威治标准时间-02：00) 南乔治亚标准时间 (Atlantic/South_Georgia)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0200.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0200.id,:meaning=>'(GMT-02:00) South Georgia Time (Atlantic/South_Georgia)',:description=>'(GMT-02:00) South Georgia Standard Time (Atlantic/South_Georgia)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0200.save
    timezonegmt_m0300= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0300',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0300.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0300.id,:meaning=>'(格林威治标准时间-03：00) 阿根廷时间 (America/Buenos_Aires)',:description=>'(格林威治标准时间-03：00) 阿根廷时间 (America/Buenos_Aires)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0300.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0300.id,:meaning=>'(GMT-03:00) Argentine Time (America/Buenos_Aires)',:description=>'(GMT-03:00) Argentine Time (America/Buenos_Aires)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0300.save
    timezonegmt_m0300_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0300_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0300_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0300_2.id,:meaning=>'(格林威治标准时间-03：00) 巴西利亚夏令时 (America/Sao_Paulo)',:description=>'(格林威治标准时间-03：00) 巴西利亚夏令时 (America/Sao_Paulo)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0300_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0300_2.id,:meaning=>'(GMT-03:00) Brasilia Summer Time (America/Sao_Paulo)',:description=>'(GMT-03:00) Brasilia Summer Time (America/Sao_Paulo)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0300_2.save
    timezonegmt_m0330= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0330',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0330.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0330.id,:meaning=>'(格林威治标准时间-03：30) 纽芬兰标准时间 (America/St_Johns)',:description=>'(格林威治标准时间-03：30) 纽芬兰标准时间 (America/St_Johns)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0330.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0330.id,:meaning=>'(GMT-03:30) Newfoundland Standard Time (America/St_Johns)',:description=>'(GMT-03:30) Newfoundland Standard Time (America/St_Johns)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0330.save
    timezonegmt_m0400= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0400',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0400.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0400.id,:meaning=>'(格林威治标准时间-04：00) 大西洋标准时间 (America/Halifax)',:description=>'(格林威治标准时间-04：00) 大西洋标准时间 (America/Halifax)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0400.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0400.id,:meaning=>'(GMT-04:00) Atlantic Standard Time (America/Halifax)',:description=>'(GMT-04:00) Atlantic Standard Time (America/Halifax)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0400.save
    timezonegmt_m0400_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0400_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0400_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0400_2.id,:meaning=>'(格林威治标准时间-04：00) 大西洋标准时间 (America/Puerto_Rico)',:description=>'(格林威治标准时间-04：00) 大西洋标准时间 (America/Puerto_Rico)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0400_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0400_2.id,:meaning=>'(GMT-04:00) Atlantic Standard Time (America/Puerto_Rico)',:description=>'(GMT-04:00) Atlantic Standard Time (America/Puerto_Rico)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0400_2.save
    timezonegmt_m0400_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0400_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0400_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0400_3.id,:meaning=>'(格林威治标准时间-04：00) 智利夏令时 (America/Santiago)',:description=>'(格林威治标准时间-04：00) 智利夏令时 (America/Santiago)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0400_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0400_3.id,:meaning=>'(GMT-04:00) Chile Summer Time (America/Santiago)',:description=>'(GMT-04:00) Chile Summer Time (America/Santiago)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0400_3.save
    timezonegmt_m0400_4= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0400_4',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0400_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0400_4.id,:meaning=>'(格林威治标准时间-04：00) 大西洋标准时间 (Atlantic/Bermuda)',:description=>'(格林威治标准时间-04：00) 大西洋标准时间 (Atlantic/Bermuda)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0400_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0400_4.id,:meaning=>'(GMT-04:00) Atlantic Standard Time (Atlantic/Bermuda)',:description=>'(GMT-04:00) Atlantic Standard Time (Atlantic/Bermuda)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0400_4.save
    timezonegmt_m0430= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0430',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0430.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0430.id,:meaning=>'(格林威治标准时间-04：30) 委内瑞拉时间 (America/Caracas)',:description=>'(格林威治标准时间-04：30) 委内瑞拉时间 (America/Caracas)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0430.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0430.id,:meaning=>'(GMT-04:30) Venezuela Time (America/Caracas)',:description=>'(GMT-04:30) Venezuela Time (America/Caracas)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0430.save
    timezonegmt_m0500= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0500',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0500.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500.id,:meaning=>'(格林威治标准时间-05：00) 哥伦比亚时间 (America/Bogota)',:description=>'(格林威治标准时间-05：00) 哥伦比亚时间 (America/Bogota)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500.id,:meaning=>'(GMT-05:00) Colombia Time (America/Bogota)',:description=>'(GMT-05:00) Colombia Time (America/Bogota)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500.save
    timezonegmt_m0500_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0500_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0500_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500_2.id,:meaning=>'(格林威治标准时间-05：00) 东部标准时间 (America/Indianapolis)',:description=>'(格林威治标准时间-05：00) 东部标准时间 (America/Indianapolis)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500_2.id,:meaning=>'(GMT-05:00) Eastern Standard Time (America/Indianapolis)',:description=>'(GMT-05:00) Eastern Standard Time (America/Indianapolis)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500_2.save
    timezonegmt_m0500_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0500_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0500_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500_3.id,:meaning=>'(格林威治标准时间-05：00) 秘鲁时间 (America/Lima)',:description=>'(格林威治标准时间-05：00) 秘鲁时间 (America/Lima)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500_3.id,:meaning=>'(GMT-05:00) Peru Time (America/Lima)',:description=>'(GMT-05:00) Peru Time (America/Lima)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500_3.save
    timezonegmt_m0500_4= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0500_4',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0500_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500_4.id,:meaning=>'(格林威治标准时间-05：00) 东部标准时间 (America/New_York)',:description=>'(格林威治标准时间-05：00) 东部标准时间 (America/New_York)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500_4.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500_4.id,:meaning=>'(GMT-05:00) Eastern Standard Time (America/New_York)',:description=>'(GMT-05:00) Eastern Standard Time (America/New_York)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500_4.save
    timezonegmt_m0500_5= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0500_5',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0500_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500_5.id,:meaning=>'(格林威治标准时间-05：00) 东部标准时间 (America/Panama)',:description=>'(格林威治标准时间-05：00) 东部标准时间 (America/Panama)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500_5.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0500_5.id,:meaning=>'(GMT-05:00) Eastern Standard Time (America/Panama)',:description=>'(GMT-05:00) Eastern Standard Time (America/Panama)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0500_5.save
    timezonegmt_m0600= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0600',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0600.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0600.id,:meaning=>'(格林威治标准时间-06：00) 中央标准时间 (America/Chicago)',:description=>'(格林威治标准时间-06：00) 中央标准时间 (America/Chicago)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0600.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0600.id,:meaning=>'(GMT-06:00) Central Standard Time (America/Chicago)',:description=>'(GMT-06:00) Central Standard Time (America/Chicago)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0600.save
    timezonegmt_m0600_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0600_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0600_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0600_2.id,:meaning=>'(格林威治标准时间-06：00) 中央标准时间 (America/El_Salvador)',:description=>'(格林威治标准时间-06：00) 中央标准时间 (America/El_Salvador)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0600_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0600_2.id,:meaning=>'(GMT-06:00) Central Standard Time (America/El_Salvador)',:description=>'(GMT-06:00) Central Standard Time (America/El_Salvador)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0600_2.save
    timezonegmt_m0600_3= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0600_3',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0600_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0600_3.id,:meaning=>'(格林威治标准时间-06：00) 中央标准时间 (America/Mexico_City)',:description=>'(格林威治标准时间-06：00) 中央标准时间 (America/Mexico_City)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0600_3.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0600_3.id,:meaning=>'(GMT-06:00) Central Standard Time (America/Mexico_City)',:description=>'(GMT-06:00) Central Standard Time (America/Mexico_City)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0600_3.save
    timezonegmt_m0700= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0700',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0700.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0700.id,:meaning=>'(格林威治标准时间-07：00) Mountain 标准时间 (America/Denver)',:description=>'(格林威治标准时间-07：00) Mountain 标准时间 (America/Denver)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0700.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0700.id,:meaning=>'(GMT-07:00) Mountain Standard Time (America/Denver)',:description=>'(GMT-07:00) Mountain Standard Time (America/Denver)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0700.save
    timezonegmt_m0700_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0700_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0700_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0700_2.id,:meaning=>'(格林威治标准时间-07：00) Mountain 标准时间 (America/Phoenix)',:description=>'(格林威治标准时间-07：00) Mountain 标准时间 (America/Phoenix)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0700_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0700_2.id,:meaning=>'(GMT-07:00) Mountain Standard Time (America/Phoenix)',:description=>'(GMT-07:00) Mountain Standard Time (America/Phoenix)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0700_2.save
    timezonegmt_m0800= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0800',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0800.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0800.id,:meaning=>'(格林威治标准时间-08：00) 太平洋标准时间 (America/Los_Angeles)',:description=>'(格林威治标准时间-08：00) 太平洋标准时间 (America/Los_Angeles)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0800.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0800.id,:meaning=>'(GMT-08:00) Pacific Standard Time (America/Los_Angeles)',:description=>'(GMT-08:00) Pacific Standard Time (America/Los_Angeles)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0800.save
    timezonegmt_m0800_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0800_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0800_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0800_2.id,:meaning=>'(格林威治标准时间-08：00) 太平洋标准时间 (America/Tijuana)',:description=>'(格林威治标准时间-08：00) 太平洋标准时间 (America/Tijuana)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0800_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0800_2.id,:meaning=>'(GMT-08:00) Pacific Standard Time (America/Tijuana)',:description=>'(GMT-08:00) Pacific Standard Time (America/Tijuana)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0800_2.save
    timezonegmt_m0900= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M0900',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m0900.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0900.id,:meaning=>'(格林威治标准时间-09：00) 阿拉斯加标准时间 (America/Anchorage)',:description=>'(格林威治标准时间-09：00) 阿拉斯加标准时间 (America/Anchorage)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0900.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m0900.id,:meaning=>'(GMT-09:00) Alaska Standard Time (America/Anchorage)',:description=>'(GMT-09:00) Alaska Standard Time (America/Anchorage)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m0900.save
    timezonegmt_m1000= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M1000',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m1000.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m1000.id,:meaning=>'(格林威治标准时间-10：00) 夏威夷标准时间 (Pacific/Honolulu)',:description=>'(格林威治标准时间-10：00) 夏威夷标准时间 (Pacific/Honolulu)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m1000.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m1000.id,:meaning=>'(GMT-10:00) Hawaii Standard Time (Pacific/Honolulu)',:description=>'(GMT-10:00) Hawaii Standard Time (Pacific/Honolulu)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m1000.save
    timezonegmt_m1100= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M1100',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m1100.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m1100.id,:meaning=>'(格林威治标准时间-11：00) 纽威岛时间 (Pacific/Niue)',:description=>'(格林威治标准时间-11：00) 纽威岛时间 (Pacific/Niue)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m1100.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m1100.id,:meaning=>'(GMT-11:00) Niue Time (Pacific/Niue)',:description=>'(GMT-11:00) Niue Time (Pacific/Niue)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m1100.save
    timezonegmt_m1100_2= Irm::LookupValue.new(:lookup_type=>'TIMEZONE',:lookup_code=>'GMT_M1100_2',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    timezonegmt_m1100_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m1100_2.id,:meaning=>'(格林威治标准时间-11：00) 萨摩亚群岛标准时间 (Pacific/Pago_Pago)',:description=>'(格林威治标准时间-11：00) 萨摩亚群岛标准时间 (Pacific/Pago_Pago)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m1100_2.lookup_values_tls.build(:lookup_value_id=>timezonegmt_m1100_2.id,:meaning=>'(GMT-11:00) Samoa Standard Time (Pacific/Pago_Pago)',:description=>'(GMT-11:00) Samoa Standard Time (Pacific/Pago_Pago)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    timezonegmt_m1100_2.save
    skm_file_categoriesother= Irm::LookupValue.new(:lookup_type=>'SKM_FILE_CATEGORIES',:lookup_code=>'OTHER',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_file_categoriesother.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesother.id,:meaning=>'其它',:description=>'其它',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesother.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesother.id,:meaning=>'Other',:description=>'Other',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesother.save
    skm_file_categoriesdocument= Irm::LookupValue.new(:lookup_type=>'SKM_FILE_CATEGORIES',:lookup_code=>'DOCUMENT',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_file_categoriesdocument.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesdocument.id,:meaning=>'文档',:description=>'文档',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesdocument.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesdocument.id,:meaning=>'Document',:description=>'Document',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesdocument.save
    skm_file_categoriesimage= Irm::LookupValue.new(:lookup_type=>'SKM_FILE_CATEGORIES',:lookup_code=>'IMAGE',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_file_categoriesimage.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesimage.id,:meaning=>'图片',:description=>'图片',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesimage.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesimage.id,:meaning=>'Image',:description=>'Image',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesimage.save
    skm_file_categoriesvoice= Irm::LookupValue.new(:lookup_type=>'SKM_FILE_CATEGORIES',:lookup_code=>'VOICE',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_file_categoriesvoice.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesvoice.id,:meaning=>'声音',:description=>'声音',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesvoice.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesvoice.id,:meaning=>'Voice',:description=>'Voice',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesvoice.save
    skm_file_categoriesvideo= Irm::LookupValue.new(:lookup_type=>'SKM_FILE_CATEGORIES',:lookup_code=>'VIDEO',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_file_categoriesvideo.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesvideo.id,:meaning=>'视频',:description=>'视频',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesvideo.lookup_values_tls.build(:lookup_value_id=>skm_file_categoriesvideo.id,:meaning=>'Video',:description=>'Video',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_file_categoriesvideo.save
    irm_sys_para_content_typeglobal_setting= Irm::LookupValue.new(:lookup_type=>'IRM_SYS_PARA_CONTENT_TYPE',:lookup_code=>'GLOBAL_SETTING',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_content_typeglobal_setting.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_content_typeglobal_setting.id,:meaning=>'全局设置',:description=>'全局设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_content_typeglobal_setting.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_content_typeglobal_setting.id,:meaning=>'Global setting',:description=>'Global setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_content_typeglobal_setting.save
    irm_sys_para_content_typeskm_setting= Irm::LookupValue.new(:lookup_type=>'IRM_SYS_PARA_CONTENT_TYPE',:lookup_code=>'SKM_SETTING',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_content_typeskm_setting.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_content_typeskm_setting.id,:meaning=>'知识库设置',:description=>'知识库设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_content_typeskm_setting.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_content_typeskm_setting.id,:meaning=>'Service knowledge setting',:description=>'Service knowledge setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_content_typeskm_setting.save
    irm_sys_para_data_typefile= Irm::LookupValue.new(:lookup_type=>'IRM_SYS_PARA_DATA_TYPE',:lookup_code=>'FILE',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_data_typefile.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typefile.id,:meaning=>'文件',:description=>'文件',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typefile.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typefile.id,:meaning=>'File',:description=>'File',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typefile.save
    irm_sys_para_data_typetext= Irm::LookupValue.new(:lookup_type=>'IRM_SYS_PARA_DATA_TYPE',:lookup_code=>'TEXT',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_data_typetext.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typetext.id,:meaning=>'文本',:description=>'文本',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typetext.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typetext.id,:meaning=>'Text',:description=>'Text',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typetext.save
    irm_sys_para_data_typetext_area= Irm::LookupValue.new(:lookup_type=>'IRM_SYS_PARA_DATA_TYPE',:lookup_code=>'TEXT_AREA',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_data_typetext_area.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typetext_area.id,:meaning=>'多行文本',:description=>'多行文本',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typetext_area.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typetext_area.id,:meaning=>'Text Area',:description=>'Text Area',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typetext_area.save
    irm_sys_para_data_typeselect= Irm::LookupValue.new(:lookup_type=>'IRM_SYS_PARA_DATA_TYPE',:lookup_code=>'SELECT',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_data_typeselect.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typeselect.id,:meaning=>'下拉列表',:description=>'下拉列表',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typeselect.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typeselect.id,:meaning=>'Combo Box',:description=>'Combo Box',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typeselect.save
    irm_todo_event_prioritynormal= Irm::LookupValue.new(:lookup_type=>'IRM_TODO_EVENT_PRIORITY',:lookup_code=>'NORMAL',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_prioritynormal.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_prioritynormal.id,:meaning=>'一般',:description=>'一般',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_prioritynormal.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_prioritynormal.id,:meaning=>'Normal',:description=>'Normal',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_prioritynormal.save
    irm_todo_event_prioritylow= Irm::LookupValue.new(:lookup_type=>'IRM_TODO_EVENT_PRIORITY',:lookup_code=>'LOW',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_prioritylow.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_prioritylow.id,:meaning=>'低',:description=>'低',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_prioritylow.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_prioritylow.id,:meaning=>'Low',:description=>'Low',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_prioritylow.save
    irm_todo_event_priorityhigh= Irm::LookupValue.new(:lookup_type=>'IRM_TODO_EVENT_PRIORITY',:lookup_code=>'HIGH',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_priorityhigh.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_priorityhigh.id,:meaning=>'高',:description=>'高',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_priorityhigh.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_priorityhigh.id,:meaning=>'High',:description=>'High',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_priorityhigh.save
    irm_todo_event_statusnot_started= Irm::LookupValue.new(:lookup_type=>'IRM_TODO_EVENT_STATUS',:lookup_code=>'NOT_STARTED',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_statusnot_started.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statusnot_started.id,:meaning=>'未开始',:description=>'未开始',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statusnot_started.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statusnot_started.id,:meaning=>'Not Started',:description=>'Not Started',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statusnot_started.save
    irm_todo_event_statusin_progress= Irm::LookupValue.new(:lookup_type=>'IRM_TODO_EVENT_STATUS',:lookup_code=>'IN_PROGRESS',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_statusin_progress.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statusin_progress.id,:meaning=>'进行中',:description=>'进行中',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statusin_progress.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statusin_progress.id,:meaning=>'In Progress',:description=>'In Progress',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statusin_progress.save
    irm_todo_event_statuscompleted= Irm::LookupValue.new(:lookup_type=>'IRM_TODO_EVENT_STATUS',:lookup_code=>'COMPLETED',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_statuscompleted.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statuscompleted.id,:meaning=>'已完成',:description=>'已完成',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statuscompleted.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statuscompleted.id,:meaning=>'Completed',:description=>'Completed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statuscompleted.save
    irm_todo_event_statuswaitting= Irm::LookupValue.new(:lookup_type=>'IRM_TODO_EVENT_STATUS',:lookup_code=>'WAITTING',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_statuswaitting.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statuswaitting.id,:meaning=>'等待',:description=>'等待',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statuswaitting.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statuswaitting.id,:meaning=>'Waiting on someone else',:description=>'Waiting on someone else',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statuswaitting.save
    irm_todo_event_statusdeferred= Irm::LookupValue.new(:lookup_type=>'IRM_TODO_EVENT_STATUS',:lookup_code=>'DEFERRED',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_todo_event_statusdeferred.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statusdeferred.id,:meaning=>'延迟',:description=>'延迟',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statusdeferred.lookup_values_tls.build(:lookup_value_id=>irm_todo_event_statusdeferred.id,:meaning=>'Deferred',:description=>'Deferred',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_todo_event_statusdeferred.save
    bo_attribute_typerelation_column= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_TYPE',:lookup_code=>'RELATION_COLUMN',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_typerelation_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typerelation_column.id,:meaning=>'关联列',:description=>'关联列',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typerelation_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typerelation_column.id,:meaning=>'Relation Column',:description=>'Relation Column',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typerelation_column.save
    bo_attribute_typemodel_attribute= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_TYPE',:lookup_code=>'MODEL_ATTRIBUTE',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_typemodel_attribute.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typemodel_attribute.id,:meaning=>'Model属性',:description=>'Model属性',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typemodel_attribute.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typemodel_attribute.id,:meaning=>'Model Attribute',:description=>'Model Attribute',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typemodel_attribute.save
    bo_attribute_typetable_column= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_TYPE',:lookup_code=>'TABLE_COLUMN',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_typetable_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typetable_column.id,:meaning=>'表格列',:description=>'表格列',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typetable_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typetable_column.id,:meaning=>'Table Column',:description=>'Table Column',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typetable_column.save
    bo_attribute_relation_typeleft_outer_join= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_RELATION_TYPE',:lookup_code=>'LEFT_OUTER_JOIN',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_relation_typeleft_outer_join.lookup_values_tls.build(:lookup_value_id=>bo_attribute_relation_typeleft_outer_join.id,:meaning=>'左外连接',:description=>'左外连接',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_relation_typeleft_outer_join.lookup_values_tls.build(:lookup_value_id=>bo_attribute_relation_typeleft_outer_join.id,:meaning=>'Left Outer Join',:description=>'Left Outer Join',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_relation_typeleft_outer_join.save
    bo_attribute_relation_typejoin= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_RELATION_TYPE',:lookup_code=>'JOIN',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_relation_typejoin.lookup_values_tls.build(:lookup_value_id=>bo_attribute_relation_typejoin.id,:meaning=>'外连接',:description=>'外连接',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_relation_typejoin.lookup_values_tls.build(:lookup_value_id=>bo_attribute_relation_typejoin.id,:meaning=>'Join',:description=>'Join',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_relation_typejoin.save
    workflow_rule_evaluate_typecreate_edit_first_time= Irm::LookupValue.new(:lookup_type=>'WORKFLOW_RULE_EVALUATE_TYPE',:lookup_code=>'CREATE_EDIT_FIRST_TIME',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    workflow_rule_evaluate_typecreate_edit_first_time.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_typecreate_edit_first_time.id,:meaning=>'当创建或编辑记录且原先未曾达到规则条件',:description=>'当创建或编辑记录且原先未曾达到规则条件',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_typecreate_edit_first_time.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_typecreate_edit_first_time.id,:meaning=>'When a record is created,or when a record is edited,first time',:description=>'When a record is created, or when a record is edited and did not previously meet the rule criteria',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_typecreate_edit_first_time.save
    workflow_rule_evaluate_typeonly_create= Irm::LookupValue.new(:lookup_type=>'WORKFLOW_RULE_EVALUATE_TYPE',:lookup_code=>'ONLY_CREATE',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    workflow_rule_evaluate_typeonly_create.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_typeonly_create.id,:meaning=>'仅创建记录时',:description=>'仅创建记录时',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_typeonly_create.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_typeonly_create.id,:meaning=>'Only when a record is created',:description=>'Only when a record is created',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_typeonly_create.save
    workflow_rule_evaluate_typecreate_edit_every_time= Irm::LookupValue.new(:lookup_type=>'WORKFLOW_RULE_EVALUATE_TYPE',:lookup_code=>'CREATE_EDIT_EVERY_TIME',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    workflow_rule_evaluate_typecreate_edit_every_time.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_typecreate_edit_every_time.id,:meaning=>'每一次创建或更新记录时',:description=>'每一次创建或更新记录时',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_typecreate_edit_every_time.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_typecreate_edit_every_time.id,:meaning=>'Every time a record is created or edited',:description=>'Every time a record is created or edited',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_typecreate_edit_every_time.save
    workflow_rule_evaluate_modefilter= Irm::LookupValue.new(:lookup_type=>'WORKFLOW_RULE_EVALUATE_MODE',:lookup_code=>'FILTER',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    workflow_rule_evaluate_modefilter.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_modefilter.id,:meaning=>'过滤条件',:description=>'过滤条件',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_modefilter.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_modefilter.id,:meaning=>'Filter',:description=>'Filter',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_modefilter.save
    workflow_rule_evaluate_modeformula= Irm::LookupValue.new(:lookup_type=>'WORKFLOW_RULE_EVALUATE_MODE',:lookup_code=>'FORMULA',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    workflow_rule_evaluate_modeformula.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_modeformula.id,:meaning=>'公式条件',:description=>'公式条件',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_modeformula.lookup_values_tls.build(:lookup_value_id=>workflow_rule_evaluate_modeformula.id,:meaning=>'Formula',:description=>'Formula',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workflow_rule_evaluate_modeformula.save
    rule_filter_operatore= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'E',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatore.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatore.id,:meaning=>'等于',:description=>'等于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatore.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatore.id,:meaning=>'Equal',:description=>'Equal',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatore.save
    rule_filter_operatorn= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'N',:start_date_active=>'2011-02-21',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatorn.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorn.id,:meaning=>'不等于',:description=>'不等于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorn.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorn.id,:meaning=>'Not Equal',:description=>'Not Equal',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorn.save
    rule_filter_operatorg= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'G',:start_date_active=>'2011-02-22',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatorg.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorg.id,:meaning=>'大于',:description=>'大于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorg.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorg.id,:meaning=>'Greater Than',:description=>'Greater Than',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorg.save
    rule_filter_operatorl= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'L',:start_date_active=>'2011-02-23',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatorl.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorl.id,:meaning=>'小于',:description=>'小于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorl.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorl.id,:meaning=>'Letter Than',:description=>'Letter Than',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorl.save
    rule_filter_operatorm= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'M',:start_date_active=>'2011-02-24',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatorm.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorm.id,:meaning=>'大于或等于',:description=>'大于或等于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorm.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorm.id,:meaning=>'Greater than or equal to',:description=>'Greater than or equal to',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorm.save
    rule_filter_operatorh= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'H',:start_date_active=>'2011-02-25',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatorh.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorh.id,:meaning=>'小于或等于',:description=>'小于或等于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorh.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorh.id,:meaning=>'Less than or?equal to',:description=>'Less than or?equal to',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorh.save
    rule_filter_operatornil= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'NIL',:start_date_active=>'2011-02-26',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatornil.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatornil.id,:meaning=>'为空值',:description=>'为空值',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatornil.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatornil.id,:meaning=>'Is Null',:description=>'Is Null',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatornil.save
    rule_filter_operatornnil= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'NNIL',:start_date_active=>'2011-02-27',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatornnil.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatornnil.id,:meaning=>'不为空值',:description=>'不为空值',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatornnil.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatornnil.id,:meaning=>'Not Null',:description=>'Not Null',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatornnil.save
    rule_filter_operatorbw= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'BW',:start_date_active=>'2011-02-28',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatorbw.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorbw.id,:meaning=>'开始字符等于',:description=>'开始字符等于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorbw.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorbw.id,:meaning=>'Begin With',:description=>'Begin With',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorbw.save
    rule_filter_operatorew= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'EW',:start_date_active=>'2011-03-01',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatorew.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorew.id,:meaning=>'结束字符等于',:description=>'结束字符等于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorew.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorew.id,:meaning=>'End With',:description=>'End With',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorew.save
    rule_filter_operatoru= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'U',:start_date_active=>'2011-03-02',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatoru.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatoru.id,:meaning=>'包括',:description=>'包括',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatoru.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatoru.id,:meaning=>'Include',:description=>'Include',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatoru.save
    rule_filter_operatorx= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'X',:start_date_active=>'2011-03-03',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatorx.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorx.id,:meaning=>'不包括',:description=>'不包括',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorx.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorx.id,:meaning=>'Not Include',:description=>'Not Include',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorx.save
    rule_filter_operatorin= Irm::LookupValue.new(:lookup_type=>'RULE_FILTER_OPERATOR',:lookup_code=>'IN',:start_date_active=>'2011-03-04',:status_code=>'ENABLED',:not_auto_mult=>true)
    rule_filter_operatorin.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorin.id,:meaning=>'(日期)N天内',:description=>'(日期)N天内',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorin.lookup_values_tls.build(:lookup_value_id=>rule_filter_operatorin.id,:meaning=>'Days in',:description=>'Days in',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    rule_filter_operatorin.save
    wf_field_update_value_typenull_value= Irm::LookupValue.new(:lookup_type=>'WF_FIELD_UPDATE_VALUE_TYPE',:lookup_code=>'NULL_VALUE',:start_date_active=>'2011-03-05',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_field_update_value_typenull_value.lookup_values_tls.build(:lookup_value_id=>wf_field_update_value_typenull_value.id,:meaning=>'空值(null)',:description=>'空值(null)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_field_update_value_typenull_value.lookup_values_tls.build(:lookup_value_id=>wf_field_update_value_typenull_value.id,:meaning=>'Null Vaule',:description=>'Null Vaule',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_field_update_value_typenull_value.save
    wf_field_update_value_typeformula_value= Irm::LookupValue.new(:lookup_type=>'WF_FIELD_UPDATE_VALUE_TYPE',:lookup_code=>'FORMULA_VALUE',:start_date_active=>'2011-03-06',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_field_update_value_typeformula_value.lookup_values_tls.build(:lookup_value_id=>wf_field_update_value_typeformula_value.id,:meaning=>'使用公式设置新值',:description=>'使用公式设置新值',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_field_update_value_typeformula_value.lookup_values_tls.build(:lookup_value_id=>wf_field_update_value_typeformula_value.id,:meaning=>'Formula Value',:description=>'Formula Value',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_field_update_value_typeformula_value.save
    wf_field_update_value_typeoptions_value= Irm::LookupValue.new(:lookup_type=>'WF_FIELD_UPDATE_VALUE_TYPE',:lookup_code=>'OPTIONS_VALUE',:start_date_active=>'2011-03-07',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_field_update_value_typeoptions_value.lookup_values_tls.build(:lookup_value_id=>wf_field_update_value_typeoptions_value.id,:meaning=>'从列中选择新值',:description=>'从列中选择新值',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_field_update_value_typeoptions_value.lookup_values_tls.build(:lookup_value_id=>wf_field_update_value_typeoptions_value.id,:meaning=>'Options Value',:description=>'Options Value',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_field_update_value_typeoptions_value.save
    irm_formula_function_typedatetime= Irm::LookupValue.new(:lookup_type=>'IRM_FORMULA_FUNCTION_TYPE',:lookup_code=>'DATETIME',:start_date_active=>'2011-03-08',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_formula_function_typedatetime.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typedatetime.id,:meaning=>'日期和时间',:description=>'日期和时间',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typedatetime.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typedatetime.id,:meaning=>'Date and Time',:description=>'Date and Time',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typedatetime.save
    irm_formula_function_typelogic= Irm::LookupValue.new(:lookup_type=>'IRM_FORMULA_FUNCTION_TYPE',:lookup_code=>'LOGIC',:start_date_active=>'2011-03-09',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_formula_function_typelogic.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typelogic.id,:meaning=>'逻辑',:description=>'逻辑',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typelogic.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typelogic.id,:meaning=>'Logic',:description=>'Logic',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typelogic.save
    irm_formula_function_typemath= Irm::LookupValue.new(:lookup_type=>'IRM_FORMULA_FUNCTION_TYPE',:lookup_code=>'MATH',:start_date_active=>'2011-03-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_formula_function_typemath.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typemath.id,:meaning=>'数学',:description=>'数学',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typemath.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typemath.id,:meaning=>'Math',:description=>'Math',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typemath.save
    irm_formula_function_typetext= Irm::LookupValue.new(:lookup_type=>'IRM_FORMULA_FUNCTION_TYPE',:lookup_code=>'TEXT',:start_date_active=>'2011-03-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_formula_function_typetext.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typetext.id,:meaning=>'文本',:description=>'文本',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typetext.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typetext.id,:meaning=>'Text',:description=>'Text',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typetext.save
    irm_formula_function_typeadvance= Irm::LookupValue.new(:lookup_type=>'IRM_FORMULA_FUNCTION_TYPE',:lookup_code=>'ADVANCE',:start_date_active=>'2011-03-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_formula_function_typeadvance.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typeadvance.id,:meaning=>'高级',:description=>'高级',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typeadvance.lookup_values_tls.build(:lookup_value_id=>irm_formula_function_typeadvance.id,:meaning=>'Advance',:description=>'Advance',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_formula_function_typeadvance.save
    wf_mail_alert_recipient_typerelated_person= Irm::LookupValue.new(:lookup_type=>'WF_MAIL_ALERT_RECIPIENT_TYPE',:lookup_code=>'RELATED_PERSON',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_mail_alert_recipient_typerelated_person.lookup_values_tls.build(:lookup_value_id=>wf_mail_alert_recipient_typerelated_person.id,:meaning=>'相关人员',:description=>'相关人员',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_mail_alert_recipient_typerelated_person.lookup_values_tls.build(:lookup_value_id=>wf_mail_alert_recipient_typerelated_person.id,:meaning=>'Related Person',:description=>'Related Person',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_mail_alert_recipient_typerelated_person.save
    wf_mail_alert_recipient_typeperson= Irm::LookupValue.new(:lookup_type=>'WF_MAIL_ALERT_RECIPIENT_TYPE',:lookup_code=>'PERSON',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_mail_alert_recipient_typeperson.lookup_values_tls.build(:lookup_value_id=>wf_mail_alert_recipient_typeperson.id,:meaning=>'人员',:description=>'人员',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_mail_alert_recipient_typeperson.lookup_values_tls.build(:lookup_value_id=>wf_mail_alert_recipient_typeperson.id,:meaning=>'Person',:description=>'Person',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_mail_alert_recipient_typeperson.save
    wf_mail_alert_recipient_typerole= Irm::LookupValue.new(:lookup_type=>'WF_MAIL_ALERT_RECIPIENT_TYPE',:lookup_code=>'ROLE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_mail_alert_recipient_typerole.lookup_values_tls.build(:lookup_value_id=>wf_mail_alert_recipient_typerole.id,:meaning=>'角色',:description=>'角色',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_mail_alert_recipient_typerole.lookup_values_tls.build(:lookup_value_id=>wf_mail_alert_recipient_typerole.id,:meaning=>'Role',:description=>'Role',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_mail_alert_recipient_typerole.save
    irm_sys_para_data_typeimage= Irm::LookupValue.new(:lookup_type=>'IRM_SYS_PARA_DATA_TYPE',:lookup_code=>'IMAGE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_data_typeimage.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typeimage.id,:meaning=>'图片',:description=>'图片',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typeimage.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typeimage.id,:meaning=>'Image',:description=>'Image',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typeimage.save
    wf_rule_trigger_time_unitday= Irm::LookupValue.new(:lookup_type=>'WF_RULE_TRIGGER_TIME_UNIT',:lookup_code=>'DAY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_rule_trigger_time_unitday.lookup_values_tls.build(:lookup_value_id=>wf_rule_trigger_time_unitday.id,:meaning=>'天',:description=>'天',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_unitday.lookup_values_tls.build(:lookup_value_id=>wf_rule_trigger_time_unitday.id,:meaning=>'Day',:description=>'Day',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_unitday.save
    wf_rule_trigger_time_unithour= Irm::LookupValue.new(:lookup_type=>'WF_RULE_TRIGGER_TIME_UNIT',:lookup_code=>'HOUR',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_rule_trigger_time_unithour.lookup_values_tls.build(:lookup_value_id=>wf_rule_trigger_time_unithour.id,:meaning=>'小时',:description=>'小时',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_unithour.lookup_values_tls.build(:lookup_value_id=>wf_rule_trigger_time_unithour.id,:meaning=>'Hour',:description=>'Hour',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_unithour.save
    wf_rule_trigger_time_modebefore= Irm::LookupValue.new(:lookup_type=>'WF_RULE_TRIGGER_TIME_MODE',:lookup_code=>'BEFORE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_rule_trigger_time_modebefore.lookup_values_tls.build(:lookup_value_id=>wf_rule_trigger_time_modebefore.id,:meaning=>'早于',:description=>'早于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_modebefore.lookup_values_tls.build(:lookup_value_id=>wf_rule_trigger_time_modebefore.id,:meaning=>'Before',:description=>'Before',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_modebefore.save
    wf_rule_trigger_time_modeafter= Irm::LookupValue.new(:lookup_type=>'WF_RULE_TRIGGER_TIME_MODE',:lookup_code=>'AFTER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_rule_trigger_time_modeafter.lookup_values_tls.build(:lookup_value_id=>wf_rule_trigger_time_modeafter.id,:meaning=>'晚于',:description=>'晚于',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_modeafter.lookup_values_tls.build(:lookup_value_id=>wf_rule_trigger_time_modeafter.id,:meaning=>'After',:description=>'After',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_rule_trigger_time_modeafter.save
    irm_sys_para_data_typenumber= Irm::LookupValue.new(:lookup_type=>'IRM_SYS_PARA_DATA_TYPE',:lookup_code=>'NUMBER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_sys_para_data_typenumber.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typenumber.id,:meaning=>'数字',:description=>'数字',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typenumber.lookup_values_tls.build(:lookup_value_id=>irm_sys_para_data_typenumber.id,:meaning=>'Number',:description=>'Number',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_sys_para_data_typenumber.save
    wf_process_record_editabilityonly_admin= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_RECORD_EDITABILITY',:lookup_code=>'ONLY_ADMIN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_record_editabilityonly_admin.lookup_values_tls.build(:lookup_value_id=>wf_process_record_editabilityonly_admin.id,:meaning=>'只管理员可在批准过程中编辑记录。',:description=>'只管理员可在批准过程中编辑记录。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_record_editabilityonly_admin.lookup_values_tls.build(:lookup_value_id=>wf_process_record_editabilityonly_admin.id,:meaning=>'Only admin can edit the record',:description=>'Only admin can edit the record',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_record_editabilityonly_admin.save
    wf_process_record_editabilityadmin_approver= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_RECORD_EDITABILITY',:lookup_code=>'ADMIN_APPROVER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_record_editabilityadmin_approver.lookup_values_tls.build(:lookup_value_id=>wf_process_record_editabilityadmin_approver.id,:meaning=>'管理员或当前分配的批准人可在批准过程中编辑记录。',:description=>'管理员或当前分配的批准人可在批准过程中编辑记录。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_record_editabilityadmin_approver.lookup_values_tls.build(:lookup_value_id=>wf_process_record_editabilityadmin_approver.id,:meaning=>'Admin and approver can edit the record',:description=>'Admin and approver can edit the record',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_record_editabilityadmin_approver.save
    wf_step_evaluate_resutlnext_step= Irm::LookupValue.new(:lookup_type=>'WF_STEP_EVALUATE_RESUTL',:lookup_code=>'NEXT_STEP',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_evaluate_resutlnext_step.lookup_values_tls.build(:lookup_value_id=>wf_step_evaluate_resutlnext_step.id,:meaning=>'进入下一步审批',:description=>'进入下一步审批',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutlnext_step.lookup_values_tls.build(:lookup_value_id=>wf_step_evaluate_resutlnext_step.id,:meaning=>'Next Step',:description=>'Next Step',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutlnext_step.save
    wf_step_evaluate_resutlapproval= Irm::LookupValue.new(:lookup_type=>'WF_STEP_EVALUATE_RESUTL',:lookup_code=>'APPROVAL',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_evaluate_resutlapproval.lookup_values_tls.build(:lookup_value_id=>wf_step_evaluate_resutlapproval.id,:meaning=>'审批通过',:description=>'审批通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutlapproval.lookup_values_tls.build(:lookup_value_id=>wf_step_evaluate_resutlapproval.id,:meaning=>'Approval',:description=>'Approval',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutlapproval.save
    wf_step_evaluate_resutlreject= Irm::LookupValue.new(:lookup_type=>'WF_STEP_EVALUATE_RESUTL',:lookup_code=>'REJECT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_evaluate_resutlreject.lookup_values_tls.build(:lookup_value_id=>wf_step_evaluate_resutlreject.id,:meaning=>'审批拒绝',:description=>'审批拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutlreject.lookup_values_tls.build(:lookup_value_id=>wf_step_evaluate_resutlreject.id,:meaning=>'Reject',:description=>'Reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutlreject.save
    wf_step_approver_typeselect_by_sumbitter= Irm::LookupValue.new(:lookup_type=>'WF_STEP_APPROVER_TYPE',:lookup_code=>'SELECT_BY_SUMBITTER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_approver_typeselect_by_sumbitter.lookup_values_tls.build(:lookup_value_id=>wf_step_approver_typeselect_by_sumbitter.id,:meaning=>'允许提交人手动选择批准人',:description=>'允许提交人手动选择批准人',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_approver_typeselect_by_sumbitter.lookup_values_tls.build(:lookup_value_id=>wf_step_approver_typeselect_by_sumbitter.id,:meaning=>'Mannual select approver',:description=>'Mannual select approver',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_approver_typeselect_by_sumbitter.save
    wf_step_approver_typeprocess_default= Irm::LookupValue.new(:lookup_type=>'WF_STEP_APPROVER_TYPE',:lookup_code=>'PROCESS_DEFAULT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_approver_typeprocess_default.lookup_values_tls.build(:lookup_value_id=>wf_step_approver_typeprocess_default.id,:meaning=>'使用前一个审批人的用户字段自动分配',:description=>'使用前一个审批人的用户字段自动分配',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_approver_typeprocess_default.lookup_values_tls.build(:lookup_value_id=>wf_step_approver_typeprocess_default.id,:meaning=>'Last approver person field',:description=>'Last approver person field',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_approver_typeprocess_default.save
    wf_step_approver_typeauto_approver= Irm::LookupValue.new(:lookup_type=>'WF_STEP_APPROVER_TYPE',:lookup_code=>'AUTO_APPROVER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_approver_typeauto_approver.lookup_values_tls.build(:lookup_value_id=>wf_step_approver_typeauto_approver.id,:meaning=>'自动分配至审批人',:description=>'自动分配至审批人',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_approver_typeauto_approver.lookup_values_tls.build(:lookup_value_id=>wf_step_approver_typeauto_approver.id,:meaning=>'Auto assign to approver',:description=>'Auto assign to approver',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_approver_typeauto_approver.save
    wf_step_mulit_approver_modefirst_approved= Irm::LookupValue.new(:lookup_type=>'WF_STEP_MULIT_APPROVER_MODE',:lookup_code=>'FIRST_APPROVED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_mulit_approver_modefirst_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_mulit_approver_modefirst_approved.id,:meaning=>'基于首次审批结果',:description=>'基于首次审批结果',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_mulit_approver_modefirst_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_mulit_approver_modefirst_approved.id,:meaning=>'First approv  result',:description=>'First approv  result',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_mulit_approver_modefirst_approved.save
    wf_step_mulit_approver_modeall_approved= Irm::LookupValue.new(:lookup_type=>'WF_STEP_MULIT_APPROVER_MODE',:lookup_code=>'ALL_APPROVED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_mulit_approver_modeall_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_mulit_approver_modeall_approved.id,:meaning=>'需要一致批准',:description=>'需要一致批准',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_mulit_approver_modeall_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_mulit_approver_modeall_approved.id,:meaning=>'All approver approved',:description=>'All approver approved',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_mulit_approver_modeall_approved.save
    wf_step_reject_modereject_step= Irm::LookupValue.new(:lookup_type=>'WF_STEP_REJECT_MODE',:lookup_code=>'REJECT_STEP',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_reject_modereject_step.lookup_values_tls.build(:lookup_value_id=>wf_step_reject_modereject_step.id,:meaning=>'返回',:description=>'返回',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_reject_modereject_step.lookup_values_tls.build(:lookup_value_id=>wf_step_reject_modereject_step.id,:meaning=>'Back to step',:description=>'Back to step',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_reject_modereject_step.save
    wf_step_reject_modereject_process= Irm::LookupValue.new(:lookup_type=>'WF_STEP_REJECT_MODE',:lookup_code=>'REJECT_PROCESS',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_reject_modereject_process.lookup_values_tls.build(:lookup_value_id=>wf_step_reject_modereject_process.id,:meaning=>'最终拒绝',:description=>'最终拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_reject_modereject_process.lookup_values_tls.build(:lookup_value_id=>wf_step_reject_modereject_process.id,:meaning=>'Final reject',:description=>'Final reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_reject_modereject_process.save
    wf_process_instance_statussubmitted= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_INSTANCE_STATUS',:lookup_code=>'SUBMITTED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_instance_statussubmitted.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statussubmitted.id,:meaning=>'提交待审批',:description=>'提交待审批',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statussubmitted.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statussubmitted.id,:meaning=>'Submitted',:description=>'Submitted',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statussubmitted.save
    wf_process_instance_statusapproved= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_INSTANCE_STATUS',:lookup_code=>'APPROVED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_instance_statusapproved.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusapproved.id,:meaning=>'审批通过',:description=>'审批通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusapproved.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusapproved.id,:meaning=>'Approved',:description=>'Approved',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusapproved.save
    wf_process_instance_statusreject= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_INSTANCE_STATUS',:lookup_code=>'REJECT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_instance_statusreject.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusreject.id,:meaning=>'审批拒绝',:description=>'审批拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusreject.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusreject.id,:meaning=>'Reject',:description=>'Reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusreject.save
    wf_process_instance_statusrecall= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_INSTANCE_STATUS',:lookup_code=>'RECALL',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_instance_statusrecall.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusrecall.id,:meaning=>'已回调',:description=>'已回调',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusrecall.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusrecall.id,:meaning=>'Recall',:description=>'Recall',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusrecall.save
    wf_step_instance_statuspending= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'PENDING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statuspending.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statuspending.id,:meaning=>'审批中',:description=>'审批中',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statuspending.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statuspending.id,:meaning=>'Pending',:description=>'Pending',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statuspending.save
    wf_step_instance_statusapproved= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'APPROVED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusapproved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusapproved.id,:meaning=>'审批通过',:description=>'审批通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusapproved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusapproved.id,:meaning=>'Approved',:description=>'Approved',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusapproved.save
    wf_step_instance_statusreject= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'REJECT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusreject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusreject.id,:meaning=>'审批拒绝',:description=>'审批拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusreject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusreject.id,:meaning=>'Reject',:description=>'Reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusreject.save
    wf_step_instance_statusreassign= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'REASSIGN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusreassign.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusreassign.id,:meaning=>'转交',:description=>'转交',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusreassign.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusreassign.id,:meaning=>'Reassign',:description=>'Reassign',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusreassign.save
    wf_step_instance_statusmultiple_approved= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'MULTIPLE_APPROVED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusmultiple_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusmultiple_approved.id,:meaning=>'自动通过',:description=>'自动通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusmultiple_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusmultiple_approved.id,:meaning=>'Auto approved',:description=>'Auto approved',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusmultiple_approved.save
    wf_step_instance_statusmultiple_reject= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'MULTIPLE_REJECT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusmultiple_reject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusmultiple_reject.id,:meaning=>'自动拒绝',:description=>'自动拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusmultiple_reject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusmultiple_reject.id,:meaning=>'Auto reject',:description=>'Auto reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusmultiple_reject.save
    wf_step_instance_statusfilter_auto_approved= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'FILTER_AUTO_APPROVED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusfilter_auto_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_approved.id,:meaning=>'不满足条件通过',:description=>'不满足条件通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_approved.id,:meaning=>'Approved(Filter)',:description=>'Approved(Filter)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_approved.save
    wf_step_instance_statusfilter_auto_reject= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'FILTER_AUTO_REJECT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusfilter_auto_reject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_reject.id,:meaning=>'不满足条件拒绝',:description=>'不满足条件拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_reject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_reject.id,:meaning=>'Reject(Filter)',:description=>'Reject(Filter)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_reject.save
    wf_step_instance_statusfilter_auto_next_step= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'FILTER_AUTO_NEXT_STEP',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusfilter_auto_next_step.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_next_step.id,:meaning=>'不满足条件下一步',:description=>'不满足条件下一步',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_next_step.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_next_step.id,:meaning=>'Next step(Filter)',:description=>'Next step(Filter)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_next_step.save
    wf_step_instance_statusrecall= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'RECALL',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusrecall.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusrecall.id,:meaning=>'已回调',:description=>'已回调',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusrecall.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusrecall.id,:meaning=>'Recall',:description=>'Recall',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusrecall.save
    irm_delayed_job_statusenqueue= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'ENQUEUE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusenqueue.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusenqueue.id,:meaning=>'已进入队列',:description=>'已进入队列',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusenqueue.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusenqueue.id,:meaning=>'Enqueued',:description=>'Enqueued',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusenqueue.save
    irm_delayed_job_statusrun= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'RUN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusrun.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusrun.id,:meaning=>'执行中',:description=>'执行中',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusrun.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusrun.id,:meaning=>'Running',:description=>'Running',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusrun.save
    irm_delayed_job_statuslock= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'LOCK',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statuslock.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuslock.id,:meaning=>'锁定',:description=>'锁定',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuslock.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuslock.id,:meaning=>'Lock',:description=>'Lock',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuslock.save
    irm_delayed_job_statusunlock= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'UNLOCK',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusunlock.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusunlock.id,:meaning=>'解除锁定',:description=>'解除锁定',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusunlock.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusunlock.id,:meaning=>'Unlock',:description=>'Unlock',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusunlock.save
    irm_delayed_job_statuscomplete= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'COMPLETE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statuscomplete.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuscomplete.id,:meaning=>'完成',:description=>'完成',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuscomplete.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuscomplete.id,:meaning=>'Completed',:description=>'Completed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuscomplete.save
    irm_delayed_job_statusdestroy= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'DESTROY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusdestroy.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusdestroy.id,:meaning=>'完成并移除任务',:description=>'完成并移除任务',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusdestroy.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusdestroy.id,:meaning=>'Completed & Removed',:description=>'Completed & Removed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusdestroy.save
    irm_delayed_job_statuserror= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'ERROR',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statuserror.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuserror.id,:meaning=>'错误',:description=>'错误',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuserror.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuserror.id,:meaning=>'Error',:description=>'Error',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuserror.save
    irm_delayed_job_statusparam= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'PARAM',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusparam.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusparam.id,:meaning=>'参数',:description=>'参数',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusparam.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusparam.id,:meaning=>'Parameters',:description=>'Parameters',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusparam.save
    irm_report_folder_access_typeforbid= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_ACCESS_TYPE',:lookup_code=>'FORBID',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_access_typeforbid.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeforbid.id,:meaning=>'禁止访问',:description=>'禁止访问',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeforbid.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeforbid.id,:meaning=>'Forbid',:description=>'Forbid',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeforbid.save
    irm_report_folder_access_typeread= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_ACCESS_TYPE',:lookup_code=>'READ',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_access_typeread.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeread.id,:meaning=>'只读',:description=>'只读',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeread.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeread.id,:meaning=>'Read Only',:description=>'Read Only',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeread.save
    irm_report_folder_access_typeread_write= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_ACCESS_TYPE',:lookup_code=>'READ_WRITE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_access_typeread_write.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeread_write.id,:meaning=>'读写',:description=>'读写',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeread_write.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_access_typeread_write.id,:meaning=>'Read Write',:description=>'Read Write',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_access_typeread_write.save
    irm_report_date_group_typeday= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_DATE_GROUP_TYPE',:lookup_code=>'DAY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_date_group_typeday.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typeday.id,:meaning=>'日期',:description=>'日期',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typeday.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typeday.id,:meaning=>'Day',:description=>'Day',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typeday.save
    irm_report_date_group_typemonth= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_DATE_GROUP_TYPE',:lookup_code=>'MONTH',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_date_group_typemonth.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typemonth.id,:meaning=>'月份',:description=>'月份',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typemonth.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typemonth.id,:meaning=>'Month',:description=>'Month',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typemonth.save
    irm_report_date_group_typeyear= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_DATE_GROUP_TYPE',:lookup_code=>'YEAR',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_date_group_typeyear.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typeyear.id,:meaning=>'年份',:description=>'年份',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typeyear.lookup_values_tls.build(:lookup_value_id=>irm_report_date_group_typeyear.id,:meaning=>'Year',:description=>'Year',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_date_group_typeyear.save
    irm_report_group_column_sortasc= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_GROUP_COLUMN_SORT',:lookup_code=>'ASC',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_group_column_sortasc.lookup_values_tls.build(:lookup_value_id=>irm_report_group_column_sortasc.id,:meaning=>'正序',:description=>'正序',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sortasc.lookup_values_tls.build(:lookup_value_id=>irm_report_group_column_sortasc.id,:meaning=>'Asc',:description=>'Asc',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sortasc.save
    irm_report_group_column_sortdesc= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_GROUP_COLUMN_SORT',:lookup_code=>'DESC',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_group_column_sortdesc.lookup_values_tls.build(:lookup_value_id=>irm_report_group_column_sortdesc.id,:meaning=>'倒序',:description=>'倒序',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sortdesc.lookup_values_tls.build(:lookup_value_id=>irm_report_group_column_sortdesc.id,:meaning=>'Desc',:description=>'Desc',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_group_column_sortdesc.save
    irm_report_folder_member_typemember= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_MEMBER_TYPE',:lookup_code=>'MEMBER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_member_typemember.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typemember.id,:meaning=>'报表文件夹指定成员可见',:description=>'报表文件夹指定成员可见',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typemember.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typemember.id,:meaning=>'This folder is accessible by all users',:description=>'This folder is accessible by all users',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typemember.save
    irm_report_folder_member_typeprivate= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_MEMBER_TYPE',:lookup_code=>'PRIVATE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_member_typeprivate.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typeprivate.id,:meaning=>'仅创建人可见',:description=>'仅创建人可见',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typeprivate.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typeprivate.id,:meaning=>'This folder is hidden from all users',:description=>'This folder is hidden from all users',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typeprivate.save
    irm_report_folder_member_typepublic= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_FOLDER_MEMBER_TYPE',:lookup_code=>'PUBLIC',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_folder_member_typepublic.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typepublic.id,:meaning=>'公共报表文件夹',:description=>'公共报表文件夹',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typepublic.lookup_values_tls.build(:lookup_value_id=>irm_report_folder_member_typepublic.id,:meaning=>'This folder is accessible only by the following users',:description=>'This folder is accessible only by the following users',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_folder_member_typepublic.save
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
    irm_function_group_zonesystem_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'SYSTEM_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonesystem_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonesystem_setting.id,:meaning=>'应用设置',:description=>'应用设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonesystem_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonesystem_setting.id,:meaning=>'Setup Application',:description=>'Setup Application',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonesystem_setting.save
    irm_function_group_zoneincident_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'INCIDENT_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneincident_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneincident_setting.id,:meaning=>'事故单设置',:description=>'事故单设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneincident_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneincident_setting.id,:meaning=>'Incident Request Setting',:description=>'Incident Request Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneincident_setting.save
    irm_function_group_zoneskm_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'SKM_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zoneskm_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneskm_setting.id,:meaning=>'知识库设置',:description=>'知识库设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneskm_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zoneskm_setting.id,:meaning=>'Knowledge Management Setting',:description=>'Knowledge Management Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zoneskm_setting.save
    irm_function_group_zonecloud_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'CLOUD_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonecloud_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonecloud_setting.id,:meaning=>'Cloud设置',:description=>'Cloud设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonecloud_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonecloud_setting.id,:meaning=>'Cloud Setting',:description=>'Cloud Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonecloud_setting.save
    irm_profile_user_licensesupporter= Irm::LookupValue.new(:lookup_type=>'IRM_PROFILE_USER_LICENSE',:lookup_code=>'SUPPORTER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_profile_user_licensesupporter.lookup_values_tls.build(:lookup_value_id=>irm_profile_user_licensesupporter.id,:meaning=>'服务台',:description=>'服务台',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_licensesupporter.lookup_values_tls.build(:lookup_value_id=>irm_profile_user_licensesupporter.id,:meaning=>'Supporter',:description=>'Supporter',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_licensesupporter.save
    irm_profile_user_licenserequester= Irm::LookupValue.new(:lookup_type=>'IRM_PROFILE_USER_LICENSE',:lookup_code=>'REQUESTER',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_profile_user_licenserequester.lookup_values_tls.build(:lookup_value_id=>irm_profile_user_licenserequester.id,:meaning=>'客户',:description=>'客户',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_licenserequester.lookup_values_tls.build(:lookup_value_id=>irm_profile_user_licenserequester.id,:meaning=>'Customer',:description=>'Customer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_profile_user_licenserequester.save
    icm_incident_request_eventcreate= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'CREATE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventcreate.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcreate.id,:meaning=>'新建',:description=>'新建',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcreate.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcreate.id,:meaning=>'Create',:description=>'Create',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcreate.save
    icm_incident_request_eventassign= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'ASSIGN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventassign.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventassign.id,:meaning=>'分配',:description=>'分配',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventassign.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventassign.id,:meaning=>'Assign',:description=>'Assign',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventassign.save
    icm_incident_request_eventsupporter_reply= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'SUPPORTER_REPLY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventsupporter_reply.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventsupporter_reply.id,:meaning=>'支持人员回复',:description=>'支持人员回复',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventsupporter_reply.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventsupporter_reply.id,:meaning=>'Reply by Supporter',:description=>'Reply by Supporter',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventsupporter_reply.save
    icm_incident_request_eventcustomer_reply= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'CUSTOMER_REPLY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventcustomer_reply.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcustomer_reply.id,:meaning=>'客户回复',:description=>'客户回复',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcustomer_reply.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcustomer_reply.id,:meaning=>'Reply by Customer',:description=>'Reply by Customer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcustomer_reply.save
    icm_incident_request_eventpass= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'PASS',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventpass.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventpass.id,:meaning=>'转交',:description=>'转交',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventpass.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventpass.id,:meaning=>'Pass',:description=>'Pass',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventpass.save
    icm_incident_request_eventupgrade= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'UPGRADE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventupgrade.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventupgrade.id,:meaning=>'升级',:description=>'升级',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventupgrade.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventupgrade.id,:meaning=>'Upgrade',:description=>'Upgrade',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventupgrade.save
    icm_incident_request_eventclose= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'CLOSE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventclose.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventclose.id,:meaning=>'关闭',:description=>'关闭',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventclose.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventclose.id,:meaning=>'Close',:description=>'Close',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventclose.save
    irm_psw_expire_in30= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'30',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in30.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in30.id,:meaning=>'30天',:description=>'30天',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in30.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in30.id,:meaning=>'30 Days',:description=>'30 Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in30.save
    irm_psw_expire_in60= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'60',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in60.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in60.id,:meaning=>'60天',:description=>'60天',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in60.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in60.id,:meaning=>'60 Days',:description=>'60 Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in60.save
    irm_psw_expire_in90= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'90',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in90.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in90.id,:meaning=>'90天',:description=>'90天',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in90.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in90.id,:meaning=>'90 Days',:description=>'90 Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in90.save
    irm_psw_expire_in180= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'180',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in180.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in180.id,:meaning=>'180天',:description=>'180天',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in180.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in180.id,:meaning=>'180 Days',:description=>'180 Days',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in180.save
    irm_psw_expire_in365= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'365',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in365.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in365.id,:meaning=>'一年',:description=>'一年',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in365.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in365.id,:meaning=>'One Years',:description=>'One Years',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in365.save
    irm_psw_expire_in0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_EXPIRE_IN',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_expire_in0.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in0.id,:meaning=>'永不到期',:description=>'永不到期',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in0.lookup_values_tls.build(:lookup_value_id=>irm_psw_expire_in0.id,:meaning=>'Never expires',:description=>'Never expires',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_expire_in0.save
    irm_psw_enforce_history1= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'1',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history1.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history1.id,:meaning=>'记住1个密码',:description=>'记住1个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history1.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history1.id,:meaning=>'1 password remembered',:description=>'1 password remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history1.save
    irm_psw_enforce_history2= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'2',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history2.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history2.id,:meaning=>'记住2个密码',:description=>'记住2个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history2.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history2.id,:meaning=>'2 passwords remembered',:description=>'2 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history2.save
    irm_psw_enforce_history3= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'3',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history3.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history3.id,:meaning=>'记住3个密码',:description=>'记住3个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history3.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history3.id,:meaning=>'3 passwords remembered',:description=>'3 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history3.save
    irm_psw_enforce_history4= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'4',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history4.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history4.id,:meaning=>'记住4个密码',:description=>'记住4个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history4.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history4.id,:meaning=>'4 passwords remembered',:description=>'4 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history4.save
    irm_psw_enforce_history5= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'5',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history5.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history5.id,:meaning=>'记住5个密码',:description=>'记住5个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history5.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history5.id,:meaning=>'5 passwords remembered',:description=>'5 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history5.save
    irm_psw_enforce_history6= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'6',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history6.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history6.id,:meaning=>'记住6个密码',:description=>'记住6个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history6.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history6.id,:meaning=>'6 passwords remembered',:description=>'6 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history6.save
    irm_psw_enforce_history7= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'7',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history7.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history7.id,:meaning=>'记住7个密码',:description=>'记住7个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history7.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history7.id,:meaning=>'7 passwords remembered',:description=>'7 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history7.save
    irm_psw_enforce_history8= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'8',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history8.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history8.id,:meaning=>'记住8个密码',:description=>'记住8个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history8.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history8.id,:meaning=>'8 passwords remembered',:description=>'8 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history8.save
    irm_psw_enforce_history9= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'9',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history9.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history9.id,:meaning=>'记住9个密码',:description=>'记住9个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history9.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history9.id,:meaning=>'9 passwords remembered',:description=>'9 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history9.save
    irm_psw_enforce_history10= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'10',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history10.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history10.id,:meaning=>'记住10个密码',:description=>'记住10个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history10.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history10.id,:meaning=>'10 passwords remembered',:description=>'10 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history10.save
    irm_psw_enforce_history11= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'11',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history11.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history11.id,:meaning=>'记住11个密码',:description=>'记住11个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history11.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history11.id,:meaning=>'11 passwords remembered',:description=>'11 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history11.save
    irm_psw_enforce_history12= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'12',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history12.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history12.id,:meaning=>'记住12个密码',:description=>'记住12个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history12.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history12.id,:meaning=>'12 passwords remembered',:description=>'12 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history12.save
    irm_psw_enforce_history13= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'13',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history13.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history13.id,:meaning=>'记住13个密码',:description=>'记住13个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history13.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history13.id,:meaning=>'13 passwords remembered',:description=>'13 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history13.save
    irm_psw_enforce_history14= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'14',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history14.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history14.id,:meaning=>'记住14个密码',:description=>'记住14个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history14.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history14.id,:meaning=>'14 passwords remembered',:description=>'14 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history14.save
    irm_psw_enforce_history15= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'15',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history15.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history15.id,:meaning=>'记住15个密码',:description=>'记住15个密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history15.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history15.id,:meaning=>'15 passwords remembered',:description=>'15 passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history15.save
    irm_psw_enforce_history0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_ENFORCE_HISTORY',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_enforce_history0.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history0.id,:meaning=>'未记住任何密码',:description=>'未记住任何密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history0.lookup_values_tls.build(:lookup_value_id=>irm_psw_enforce_history0.id,:meaning=>'No passwords remembered',:description=>'No passwords remembered',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_enforce_history0.save
    irm_psw_minimum_length5= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MINIMUM_LENGTH',:lookup_code=>'5',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_minimum_length5.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length5.id,:meaning=>'5个字符',:description=>'5个字符',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length5.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length5.id,:meaning=>'5 characters',:description=>'5 characters',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length5.save
    irm_psw_minimum_length8= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MINIMUM_LENGTH',:lookup_code=>'8',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_minimum_length8.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length8.id,:meaning=>'8个字符',:description=>'8个字符',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length8.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length8.id,:meaning=>'8 characters',:description=>'8 characters',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length8.save
    irm_psw_minimum_length10= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MINIMUM_LENGTH',:lookup_code=>'10',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_minimum_length10.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length10.id,:meaning=>'10个字符',:description=>'10个字符',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length10.lookup_values_tls.build(:lookup_value_id=>irm_psw_minimum_length10.id,:meaning=>'10 characters',:description=>'10 characters',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_minimum_length10.save
    irm_psw_complexity_req0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_COMPLEXITY_REQ',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_complexity_req0.lookup_values_tls.build(:lookup_value_id=>irm_psw_complexity_req0.id,:meaning=>'无限制',:description=>'无限制',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req0.lookup_values_tls.build(:lookup_value_id=>irm_psw_complexity_req0.id,:meaning=>'No restriction',:description=>'No restriction',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req0.save
    irm_psw_complexity_req1= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_COMPLEXITY_REQ',:lookup_code=>'1',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_complexity_req1.lookup_values_tls.build(:lookup_value_id=>irm_psw_complexity_req1.id,:meaning=>'必须混合使用字母和数字',:description=>'必须混合使用字母和数字',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req1.lookup_values_tls.build(:lookup_value_id=>irm_psw_complexity_req1.id,:meaning=>'Must mix alpha and numeric',:description=>'Must mix alpha and numeric',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_complexity_req1.save
    irm_psw_question_req0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_QUESTION_REQ',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_question_req0.lookup_values_tls.build(:lookup_value_id=>irm_psw_question_req0.id,:meaning=>'无',:description=>'无',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req0.lookup_values_tls.build(:lookup_value_id=>irm_psw_question_req0.id,:meaning=>'None',:description=>'None',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req0.save
    irm_psw_question_req1= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_QUESTION_REQ',:lookup_code=>'1',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_question_req1.lookup_values_tls.build(:lookup_value_id=>irm_psw_question_req1.id,:meaning=>'不能包含密码',:description=>'不能包含密码',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req1.lookup_values_tls.build(:lookup_value_id=>irm_psw_question_req1.id,:meaning=>'Cannot contain password',:description=>'Cannot contain password',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_question_req1.save
    irm_psw_maximum_attempts3= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:lookup_code=>'3',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts3.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts3.id,:meaning=>'3',:description=>'3',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts3.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts3.id,:meaning=>'3',:description=>'3',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts3.save
    irm_psw_maximum_attempts5= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:lookup_code=>'5',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts5.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts5.id,:meaning=>'5',:description=>'5',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts5.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts5.id,:meaning=>'5',:description=>'5',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts5.save
    irm_psw_maximum_attempts10= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:lookup_code=>'10',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts10.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts10.id,:meaning=>'10',:description=>'10',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts10.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts10.id,:meaning=>'10',:description=>'10',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts10.save
    irm_psw_maximum_attempts0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_MAXIMUM_ATTEMPTS',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_maximum_attempts0.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts0.id,:meaning=>'无限制',:description=>'无限制',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts0.lookup_values_tls.build(:lookup_value_id=>irm_psw_maximum_attempts0.id,:meaning=>'No limit',:description=>'No limit',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_maximum_attempts0.save
    irm_psw_lockout_period15= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:lookup_code=>'15',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period15.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period15.id,:meaning=>'15 分钟',:description=>'15 分钟',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period15.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period15.id,:meaning=>'15 minutes',:description=>'15 minutes',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period15.save
    irm_psw_lockout_period30= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:lookup_code=>'30',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period30.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period30.id,:meaning=>'30 分钟',:description=>'30 分钟',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period30.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period30.id,:meaning=>'30 minutes',:description=>'30 minutes',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period30.save
    irm_psw_lockout_period60= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:lookup_code=>'60',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period60.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period60.id,:meaning=>'60 分钟',:description=>'60 分钟',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period60.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period60.id,:meaning=>'60 minutes',:description=>'60 minutes',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period60.save
    irm_psw_lockout_period0= Irm::LookupValue.new(:lookup_type=>'IRM_PSW_LOCKOUT_PERIOD',:lookup_code=>'0',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_psw_lockout_period0.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period0.id,:meaning=>'始终(必须从管理员重置)',:description=>'始终(必须从管理员重置)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period0.lookup_values_tls.build(:lookup_value_id=>irm_psw_lockout_period0.id,:meaning=>'Forever (must be reset by admin)',:description=>'Forever (must be reset by admin)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_psw_lockout_period0.save
    icm_assign_process_typemini_open_task= Irm::LookupValue.new(:lookup_type=>'ICM_ASSIGN_PROCESS_TYPE',:lookup_code=>'MINI_OPEN_TASK',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_assign_process_typemini_open_task.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_typemini_open_task.id,:meaning=>'最少任务',:description=>'最少任务',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_typemini_open_task.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_typemini_open_task.id,:meaning=>'Minimum Open Task',:description=>'Minimum Open Task',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_typemini_open_task.save
    icm_assign_process_typelongest_time_not_assign= Irm::LookupValue.new(:lookup_type=>'ICM_ASSIGN_PROCESS_TYPE',:lookup_code=>'LONGEST_TIME_NOT_ASSIGN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_assign_process_typelongest_time_not_assign.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_typelongest_time_not_assign.id,:meaning=>'最久未分配',:description=>'最久未分配',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_typelongest_time_not_assign.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_typelongest_time_not_assign.id,:meaning=>'Longest Time not Assign',:description=>'Longest Time not Assign',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_typelongest_time_not_assign.save
    icm_assign_process_typenever_assign= Irm::LookupValue.new(:lookup_type=>'ICM_ASSIGN_PROCESS_TYPE',:lookup_code=>'NEVER_ASSIGN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_assign_process_typenever_assign.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_typenever_assign.id,:meaning=>'不分配',:description=>'不分配',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_typenever_assign.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_typenever_assign.id,:meaning=>'Do not Assign',:description=>'Do not Assign',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_typenever_assign.save
    irm_kanban_positionhome_page= Irm::LookupValue.new(:lookup_type=>'IRM_KANBAN_POSITION',:lookup_code=>'HOME_PAGE',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_kanban_positionhome_page.lookup_values_tls.build(:lookup_value_id=>irm_kanban_positionhome_page.id,:meaning=>'首页',:description=>'首页',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_positionhome_page.lookup_values_tls.build(:lookup_value_id=>irm_kanban_positionhome_page.id,:meaning=>'Home Page',:description=>'Home Page',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_positionhome_page.save
    irm_kanban_positionincident_request_page= Irm::LookupValue.new(:lookup_type=>'IRM_KANBAN_POSITION',:lookup_code=>'INCIDENT_REQUEST_PAGE',:start_date_active=>'1900-01-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_kanban_positionincident_request_page.lookup_values_tls.build(:lookup_value_id=>irm_kanban_positionincident_request_page.id,:meaning=>'事故单首页',:description=>'事故单首页',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_positionincident_request_page.lookup_values_tls.build(:lookup_value_id=>irm_kanban_positionincident_request_page.id,:meaning=>'Incident Request Home',:description=>'Incident Request Home',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_kanban_positionincident_request_page.save

    datetime_date= Irm::FormulaFunction.new(:function_code=>'DATE',:parameters=>'year,month,day',:function_type => 'DATETIME',:not_auto_mult=>true)
    datetime_date.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'通过年、月、日创建日期')
    datetime_date.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Creates a date from a year, month and day')
    datetime_date.save
    datetime_datevalue= Irm::FormulaFunction.new(:function_code=>'DATEVALUE',:parameters=>'string',:function_type => 'DATETIME',:not_auto_mult=>true)
    datetime_datevalue.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'从日期时间或文本表示方式创建日期')
    datetime_datevalue.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Creates a date from its datetime or text representation')
    datetime_datevalue.save
    datetime_year= Irm::FormulaFunction.new(:function_code=>'YEAR',:parameters=>'date',:function_type => 'DATETIME',:not_auto_mult=>true)
    datetime_year.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回日期的年份，是 1900 与 9999 之间的一个数字')
    datetime_year.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the year of a date, a number between 1900 and 9999')
    datetime_year.save
    datetime_month= Irm::FormulaFunction.new(:function_code=>'MONTH',:parameters=>'date',:function_type => 'DATETIME',:not_auto_mult=>true)
    datetime_month.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回月份，是 1（一月）与 12（十二月）之间的一个数字')
    datetime_month.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the month, a number between 1 (January) and 12 (December)')
    datetime_month.save
    datetime_day= Irm::FormulaFunction.new(:function_code=>'DAY',:parameters=>'date',:function_type => 'DATETIME',:not_auto_mult=>true)
    datetime_day.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回一个月中的某一天，是 1 与 31 之间的一个数字')
    datetime_day.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the day of the month, a number between 1 and 31')
    datetime_day.save
    datetime_today= Irm::FormulaFunction.new(:function_code=>'TODAY',:parameters=>'',:function_type => 'DATETIME',:not_auto_mult=>true)
    datetime_today.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回当前日期')
    datetime_today.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the current date')
    datetime_today.save
    datetime_now= Irm::FormulaFunction.new(:function_code=>'NOW',:parameters=>'',:function_type => 'DATETIME',:not_auto_mult=>true)
    datetime_now.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回表示当前时刻的日期时间')
    datetime_now.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns a datetime representing the current moment')
    datetime_now.save
    logic_and= Irm::FormulaFunction.new(:function_code=>'AND',:parameters=>'logical1,logical2,...',:function_type => 'LOGIC',:not_auto_mult=>true)
    logic_and.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'检查是否所有参数均为真，如果所有参数均为真则返回 TRUE（真）')
    logic_and.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Checks whether all arguments are true and returns TRUE if all arguments are true')
    logic_and.save
    logic_case= Irm::FormulaFunction.new(:function_code=>'CASE',:parameters=>'expression, value1, result1, value2, result2,...,else_result',:function_type => 'LOGIC',:not_auto_mult=>true)
    logic_case.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'根据一系列值检查表达式。如果表达式比较等于任何值，则返回相应结果。如果不等于任何值，则返回 else（其他）结果')
    logic_case.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'CASE(expression, value1, result1, value2, result2,...,else_result)')
    logic_case.save
    #REF!
    logic_isnew= Irm::FormulaFunction.new(:function_code=>'ISNEW',:parameters=>'',:function_type => 'LOGIC',:not_auto_mult=>true)
    logic_isnew.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'检查记录是否是新的，如果是新的，则返回 TRUE（真）。否则返回 FALSE（假）。')
    logic_isnew.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Checks whether a condition is true, and returns one value if TRUE and another value if FALSE.')
    logic_isnew.save
    logic_isnull= Irm::FormulaFunction.new(:function_code=>'ISNULL',:parameters=>'expression',:function_type => 'LOGIC',:not_auto_mult=>true)
    logic_isnull.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'检查表达式是否为空以及是否返回 TRUE（真）或 FALSE（假）')
    logic_isnull.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Checks if the record is new, and returns TRUE if it is new. Otherwise, returns FALSE')
    logic_isnull.save
    logic_isnumber= Irm::FormulaFunction.new(:function_code=>'ISNUMBER',:parameters=>'Text',:function_type => 'LOGIC',:not_auto_mult=>true)
    logic_isnumber.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'文本值为数字时，返回 TRUE。反之，返回 FALSE。')
    logic_isnumber.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Checks whether an expression is null and returns TRUE or FALSE')
    logic_isnumber.save
    logic_not= Irm::FormulaFunction.new(:function_code=>'NOT',:parameters=>'logical',:function_type => 'LOGIC',:not_auto_mult=>true)
    logic_not.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'将 FALSE 改为 TRUE 或将 TRUE 改为 FALSE')
    logic_not.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns TRUE if the text value is a number. Otherwise, it returns FALSE.')
    logic_not.save
    logic_nullvalue= Irm::FormulaFunction.new(:function_code=>'NULLVALUE',:parameters=>'expression, substitute_expression',:function_type => 'LOGIC',:not_auto_mult=>true)
    logic_nullvalue.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'检查表达式是否为空，以及如果为空是否返回 substitute_expression。 如果表达式不为空，返回原始表达式值。')
    logic_nullvalue.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Changes FALSE to TRUE or TRUE to FALSE')
    logic_nullvalue.save
    logic_or= Irm::FormulaFunction.new(:function_code=>'OR',:parameters=>'logical1,logical2,…',:function_type => 'LOGIC',:not_auto_mult=>true)
    logic_or.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'检查任何参数是否为真，并返回 TRUE（真）或 FALSE（假）。仅当所有参数均为假时才返回 FALSE（假）')
    logic_or.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Checks whether expression is null and returns substitute_expression if it is null. If expression is not null, returns the original expression value.')
    logic_or.save
    math_max= Irm::FormulaFunction.new(:function_code=>'MAX',:parameters=>'number,number,...',:function_type => 'MATH',:not_auto_mult=>true)
    math_max.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回所有参数的最大值')
    math_max.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Checks whether any of the arguments are true and returns TRUE or FALSE. Returns FALSE only if all arguments are false')
    math_max.save
    math_min= Irm::FormulaFunction.new(:function_code=>'MIN',:parameters=>'number,number,...',:function_type => 'MATH',:not_auto_mult=>true)
    math_min.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回所有参数的最小值')
    math_min.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the greatest of all the arguments')
    math_min.save
    math_mod= Irm::FormulaFunction.new(:function_code=>'MOD',:parameters=>'number,divisor',:function_type => 'MATH',:not_auto_mult=>true)
    math_mod.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回一个数值除以除数后的余数')
    math_mod.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the remainder after a number is divided by a divisor')
    math_mod.save
    math_round= Irm::FormulaFunction.new(:function_code=>'ROUND',:parameters=>'number,num_digits',:function_type => 'MATH',:not_auto_mult=>true)
    math_round.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'按指定的位数舍入数值')
    math_round.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Rounds a number to a specified number of digits')
    math_round.save
    math_sqrt= Irm::FormulaFunction.new(:function_code=>'SQRT',:parameters=>'number',:function_type => 'MATH',:not_auto_mult=>true)
    math_sqrt.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回数值的正平方根')
    math_sqrt.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the positive square root of a number')
    math_sqrt.save
    text_begins= Irm::FormulaFunction.new(:function_code=>'BEGINS',:parameters=>'text, compare_text',:function_type => 'TEXT',:not_auto_mult=>true)
    text_begins.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'检查文本是否以特定字符开头，如果是则返回 TRUE（真）。否则返回 FALSE（假）。')
    text_begins.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Checks if text begins with specified characters and returns TRUE if it does. Otherwise returns FALSE')
    text_begins.save
    text_br= Irm::FormulaFunction.new(:function_code=>'BR',:parameters=>'',:function_type => 'TEXT',:not_auto_mult=>true)
    text_br.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'在字符串公式中插入 HTML 断行标记')
    text_br.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Inserts an HTML break tag in string formulas')
    text_br.save
    text_contains= Irm::FormulaFunction.new(:function_code=>'CONTAINS',:parameters=>'text, compare_text',:function_type => 'TEXT',:not_auto_mult=>true)
    text_contains.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'检查文本是否包含特定字符，如果是则返回 TRUE（真）。否则返回 FALSE（假）。')
    text_contains.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Checks if text contains specified characters, and returns TRUE if it does. Otherwise, returns FALSE')
    text_contains.save
    text_find= Irm::FormulaFunction.new(:function_code=>'FIND',:parameters=>'search_text, text [, start_num]',:function_type => 'TEXT',:not_auto_mult=>true)
    text_find.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回文本中 search_text 字符串的位置')
    text_find.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the position of the search_text string in text')
    text_find.save
    text_includes= Irm::FormulaFunction.new(:function_code=>'INCLUDES',:parameters=>'multiselect_picklist_field, text_literal',:function_type => 'TEXT',:not_auto_mult=>true)
    text_includes.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'确定多选选项列表字段中的任何值是否等于您指定的文本文字。')
    text_includes.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Determines if any value selected in a multi-select picklist field equals a text literal you specify.')
    text_includes.save
    text_ispickval= Irm::FormulaFunction.new(:function_code=>'ISPICKVAL',:parameters=>'picklist_field, text_literal',:function_type => 'TEXT',:not_auto_mult=>true)
    text_ispickval.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'检查选项列表字段的值是否等于一个字符串文字')
    text_ispickval.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Checks whether the value of a picklist field is equal to a string literal')
    text_ispickval.save
    text_left= Irm::FormulaFunction.new(:function_code=>'LEFT',:parameters=>'text, num_chars',:function_type => 'TEXT',:not_auto_mult=>true)
    text_left.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回从文本字符串左边算起的指定数量的字符')
    text_left.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the specified number of characters from the start of a text string')
    text_left.save
    text_len= Irm::FormulaFunction.new(:function_code=>'LEN',:parameters=>'text',:function_type => 'TEXT',:not_auto_mult=>true)
    text_len.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回一个文本字符串所含的字符数')
    text_len.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the number of characters in a text string')
    text_len.save
    text_lower= Irm::FormulaFunction.new(:function_code=>'LOWER',:parameters=>'text',:function_type => 'TEXT',:not_auto_mult=>true)
    text_lower.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'将该值中的所有字母转换为小写字母')
    text_lower.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Converts all letters in the value to lowercase')
    text_lower.save
    text_lpad= Irm::FormulaFunction.new(:function_code=>'LPAD',:parameters=>'text, padded_length [, pad_string]',:function_type => 'TEXT',:not_auto_mult=>true)
    text_lpad.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'使用空格或可选填充字符串填充在该值的左侧以使其长度达到 padded_length')
    text_lpad.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Pad the left side of the value with spaces or the optional pad string so that the length is padded_length')
    text_lpad.save
    text_mid= Irm::FormulaFunction.new(:function_code=>'MID',:parameters=>'text, start_num, num_chars',:function_type => 'TEXT',:not_auto_mult=>true)
    text_mid.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'给定字符串的起始位置和长度，返回字符串中间的字符')
    text_mid.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns character from the middle of a text string, given a starting position and length')
    text_mid.save
    text_right= Irm::FormulaFunction.new(:function_code=>'RIGHT',:parameters=>'text, num_chars',:function_type => 'TEXT',:not_auto_mult=>true)
    text_right.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回从文本字符串右边算起的指定数量的字符')
    text_right.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Returns the specified number of characters from the end of a text string')
    text_right.save
    text_rpad= Irm::FormulaFunction.new(:function_code=>'RPAD',:parameters=>'text, padded_length [, pad_string]',:function_type => 'TEXT',:not_auto_mult=>true)
    text_rpad.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'使用空格或可选填充字符串填充在该值的右侧以使其长度达到 padded_length')
    text_rpad.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Pad the right side of the value with spaces or the optional pad string so that the length is padded_length')
    text_rpad.save
    text_substitute= Irm::FormulaFunction.new(:function_code=>'SUBSTITUTE',:parameters=>'text, old_text, new_text',:function_type => 'TEXT',:not_auto_mult=>true)
    text_substitute.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'用 new_text 替换文本字符串中的 old_text。要替换文本字符串中的特定文本时，使用 SUBSTITUTE')
    text_substitute.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Substitutes new_text for old_text in a text string. Use SUBSTITUTE when you want to replace specific text in a text string')
    text_substitute.save
    text_text= Irm::FormulaFunction.new(:function_code=>'TEXT',:parameters=>'value',:function_type => 'TEXT',:not_auto_mult=>true)
    text_text.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'将一个值转换为使用标准显示格式的文本')
    text_text.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Converts a value to text using standard display format')
    text_text.save
    text_trim= Irm::FormulaFunction.new(:function_code=>'TRIM',:parameters=>'text',:function_type => 'TEXT',:not_auto_mult=>true)
    text_trim.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'从文本字符串中删除所有空格，单词之间的单个空格除外')
    text_trim.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Removes all spaces from a text string except for single spaces between words')
    text_trim.save
    text_upper= Irm::FormulaFunction.new(:function_code=>'UPPER',:parameters=>'text',:function_type => 'TEXT',:not_auto_mult=>true)
    text_upper.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'将该值中的所有字母转换为大写字母')
    text_upper.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Converts all letters in the value to uppercase')
    text_upper.save
    text_value= Irm::FormulaFunction.new(:function_code=>'VALUE',:parameters=>'text',:function_type => 'TEXT',:not_auto_mult=>true)
    text_value.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'将表示数值的文本字符串转换为数值')
    text_value.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Converts a text string that represents a number to a number')
    text_value.save
    advance_currentperson= Irm::FormulaFunction.new(:function_code=>'CURRENTPERSON',:parameters=>'',:function_type => 'ADVANCE',:not_auto_mult=>true)
    advance_currentperson.formula_functions_tls.build(:language=>'zh',:source_lang=>'en',:description=>'返回当前人员的ID')
    advance_currentperson.formula_functions_tls.build(:language=>'en',:source_lang=>'en',:description=>'Return current person id')
    advance_currentperson.save



  end

  def self.down
  end
end