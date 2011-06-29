# -*- coding: utf-8 -*-
class AddMonitorMenuData < ActiveRecord::Migration
  def self.up
    irm_irm_monitor= Irm::FunctionGroup.new(:group_code=>'IRM_MONITOR',:not_auto_mult=>true)
    irm_irm_monitor.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'监控',:description=>'监控')
    irm_irm_monitor.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor',:description=>'Monitor')
    irm_irm_monitor.save

    irm_icm_group_assign_monitor= Irm::Function.new(:group_code=>'IRM_MONITOR',:function_code=>'ICM_GROUP_ASSIGN_MONITOR',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_icm_group_assign_monitor.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单组指派作业',:description=>'事故单组指派作业')
    irm_icm_group_assign_monitor.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'IR Group Assignment Monitor',:description=>'IR Group Assignment Monitor')
    irm_icm_group_assign_monitor.save
    irm_ir_rule_process_monitor= Irm::Function.new(:group_code=>'IRM_MONITOR',:function_code=>'IR_RULE_PROCESS_MONITOR',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_ir_rule_process_monitor.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单工作流规则作业',:description=>'事故单工作流规则作业')
    irm_ir_rule_process_monitor.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'IR Rule Process Monitor',:description=>'IR Rule Process Monitor')
    irm_ir_rule_process_monitor.save

    irm_monitor= Irm::Menu.new(:menu_code=>'MONITOR',:leaf_flag=>'N',:not_auto_mult=>true)
    irm_monitor.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'监控',:description=>'监控菜单')
    irm_monitor.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor',:description=>'Monitor Menu')
    irm_monitor.save
    irm_monitor_icm_group_assign= Irm::Menu.new(:menu_code=>'MONITOR_ICM_GROUP_ASSIGN',:leaf_flag=>'Y',:not_auto_mult=>true)
    irm_monitor_icm_group_assign.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单组指派作业',:description=>'事故单组指派作业')
    irm_monitor_icm_group_assign.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'IR Group Assignment Job',:description=>'IR Group Assignment Job')
    irm_monitor_icm_group_assign.save
    irm_monitor_ir_rule_process= Irm::Menu.new(:menu_code=>'MONITOR_IR_RULE_PROCESS',:leaf_flag=>'Y',:not_auto_mult=>true)
    irm_monitor_ir_rule_process.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单工作流规则作业',:description=>'事故单工作流规则作业')
    irm_monitor_ir_rule_process.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'IR Rule Process Job',:description=>'IR Rule Process Job')
    irm_monitor_ir_rule_process.save

    irm_menu_entiry_126= Irm::MenuEntry.new(:menu_code=>'ADMIN_SETUP',:sub_menu_code=>'MONITOR',:page_controller=>nil,:display_sequence=>110,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_126.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'监控',:description=>'监控')
    irm_menu_entiry_126.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Monitor',:description=>'Monitor')
    irm_menu_entiry_126.save
    irm_menu_entiry_127= Irm::MenuEntry.new(:menu_code=>'MONITOR',:sub_menu_code=>'MONITOR_ICM_GROUP_ASSIGN',:page_controller=>nil,:display_sequence=>10,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_127.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单工作流规则作业',:description=>'事故单工作流规则作业')
    irm_menu_entiry_127.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'IR Rule Process Job',:description=>'IR Rule Process Job')
    irm_menu_entiry_127.save
    irm_menu_entiry_128= Irm::MenuEntry.new(:menu_code=>'MONITOR',:sub_menu_code=>'MONITOR_IR_RULE_PROCESS',:page_controller=>nil,:display_sequence=>20,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_128.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单组指派作业',:description=>'事故单组指派作业')
    irm_menu_entiry_128.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'IR Group Assignment Job',:description=>'IR Group Assignment Job')
    irm_menu_entiry_128.save
    irm_menu_entiry_129= Irm::MenuEntry.new(:menu_code=>'MONITOR_IR_RULE_PROCESS',:sub_menu_code=>nil,:page_controller=>'irm/monitor_ir_rule_processes',:display_sequence=>10,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_129.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单工作流规则作业',:description=>'事故单工作流规则作业')
    irm_menu_entiry_129.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'IR Rule Process Job',:description=>'IR Rule Process Job')
    irm_menu_entiry_129.save
    irm_menu_entiry_130= Irm::MenuEntry.new(:menu_code=>'MONITOR_ICM_GROUP_ASSIGN',:sub_menu_code=>nil,:page_controller=>'irm/monitor_icm_group_assigns',:display_sequence=>20,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_130.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单组指派作业',:description=>'事故单组指派作业')
    irm_menu_entiry_130.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'IR Group Assignment Job',:description=>'IR Group Assignment Job')
    irm_menu_entiry_130.save
  end

  def self.down
  end
end
