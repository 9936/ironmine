# -*- coding: utf-8 -*-
class InitChangeRequestMenu < ActiveRecord::Migration
  def up
    irm_function_group_zonechange_setting= Irm::LookupValue.new(:lookup_type=>'IRM_FUNCTION_GROUP_ZONE',:lookup_code=>'CHANGE_SETTING',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_function_group_zonechange_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonechange_setting.id,:meaning=>'变更设置',:description=>'变更设置',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonechange_setting.lookup_values_tls.build(:lookup_value_id=>irm_function_group_zonechange_setting.id,:meaning=>'Change Setting',:description=>'Change Setting',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_function_group_zonechange_setting.save
    chm_change_status= Irm::FunctionGroup.new(:zone_code=>'CHANGE_SETTING',:code=>'CHANGE_STATUS',:controller=>'chm/change_statuses',:action=>'index',:not_auto_mult=>true)
    chm_change_status.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'状态',:description=>'创建、编辑事故单状态')
    chm_change_status.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Status',:description=>'Define,edit change status')
    chm_change_status.save
    chm_change_priority= Irm::FunctionGroup.new(:zone_code=>'CHANGE_SETTING',:code=>'CHANGE_PRIORITY',:controller=>'chm/change_priorities',:action=>'index',:not_auto_mult=>true)
    chm_change_priority.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'优先级',:description=>'查看,编辑根据紧急度和影响度定义，计算出的优先级')
    chm_change_priority.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Priority',:description=>'Define,edit change priority')
    chm_change_priority.save
    chm_change_urgency= Irm::FunctionGroup.new(:zone_code=>'CHANGE_SETTING',:code=>'CHANGE_URGENCY',:controller=>'chm/change_urgencies',:action=>'index',:not_auto_mult=>true)
    chm_change_urgency.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'紧急度',:description=>'定义或编辑事故单紧急度')
    chm_change_urgency.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Urgency',:description=>'Define,edit change urgency')
    chm_change_urgency.save
    chm_change_imapct= Irm::FunctionGroup.new(:zone_code=>'CHANGE_SETTING',:code=>'CHANGE_IMPACT',:controller=>'chm/change_impacts',:action=>'index',:not_auto_mult=>true)
    chm_change_imapct.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'影响度',:description=>'定义或编辑事故单影响度')
    chm_change_imapct.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Impact',:description=>'Define,edit change impact')
    chm_change_imapct.save
    chm_change_request= Irm::FunctionGroup.new(:zone_code=>'CHANGE_SETTING',:code=>'CHANGE_REQUEST',:controller=>'change/change_requests',:action=>'index',:not_auto_mult=>true)
    chm_change_request.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变理单',:description=>'查看,提交,编辑,操作变更单')
    chm_change_request.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Request',:description=>'Submit,edit change request')
    chm_change_request.save

    chm_change_status= Irm::Function.new(:function_group_code=>'CHANGE_STATUS',:code=>'CHANGE_STATUS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_status.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更单状态',:description=>'变更单状态')
    chm_change_status.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Status',:description=>'Change Status')
    chm_change_status.save
    chm_change_priority= Irm::Function.new(:function_group_code=>'CHANGE_PRIORITY',:code=>'CHANGE_PRIORITY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_priority.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更单优先级',:description=>'变更单优先级')
    chm_change_priority.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Priority',:description=>'Change Priority')
    chm_change_priority.save
    chm_change_urgency= Irm::Function.new(:function_group_code=>'CHANGE_URGENCY',:code=>'CHANGE_URGENCY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_urgency.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更单紧急度',:description=>'变更单紧急度')
    chm_change_urgency.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Urgency',:description=>'Change Urgency')
    chm_change_urgency.save
    chm_change_impact= Irm::Function.new(:function_group_code=>'CHANGE_IMPACT',:code=>'CHANGE_IMPACT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_impact.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更单影响度',:description=>'变更单影响度')
    chm_change_impact.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Impact',:description=>'Change Impact')
    chm_change_impact.save
    chm_change_request= Irm::Function.new(:function_group_code=>'CHANGE_REQUEST',:code=>'CHANGE_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更单',:description=>'变更单')
    chm_change_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Request',:description=>'Change Request')
    chm_change_request.save
    chm_new_change_request= Irm::Function.new(:function_group_code=>'CHANGE_REQUEST',:code=>'NEW_CHANGE_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_new_change_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建变更单',:description=>'新建变更单')
    chm_new_change_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New Change Request',:description=>'New Change Request')
    chm_new_change_request.save
    chm_edit_change_request= Irm::Function.new(:function_group_code=>'CHANGE_REQUEST',:code=>'EDIT_CHANGE_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_edit_change_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑变更单',:description=>'编辑变更单')
    chm_edit_change_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Change Request',:description=>'Edit Change Request')
    chm_edit_change_request.save


    change_management= Irm::Menu.new(:code=>'CHANGE_MANAGEMENT',:not_auto_mult=>true)
    change_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更管理',:description=>'变更相关设置与管理')
    change_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Management',:description=>'Change setting')
    change_management.save

    menu_entiry_104= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'CHANGE_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>55)
    menu_entiry_104.save
    menu_entiry_105= Irm::MenuEntry.new(:menu_code=>'CHANGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CHANGE_STATUS',:display_sequence=>10)
    menu_entiry_105.save
    menu_entiry_106= Irm::MenuEntry.new(:menu_code=>'CHANGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CHANGE_PRIORITY',:display_sequence=>20)
    menu_entiry_106.save
    menu_entiry_107= Irm::MenuEntry.new(:menu_code=>'CHANGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CHANGE_URGENCY',:display_sequence=>30)
    menu_entiry_107.save
    menu_entiry_108= Irm::MenuEntry.new(:menu_code=>'CHANGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CHANGE_IMPACT',:display_sequence=>40)
    menu_entiry_108.save
  end

  def down
  end
end
