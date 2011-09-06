# -*- coding: utf-8 -*-
class AddApprovalMailMonitorMenuData < ActiveRecord::Migration
  def self.up
    irm_approval_mail_monitor= Irm::Function.new(:group_code=>'IRM_MONITOR',:function_code=>'APPROVAL_MAIL_MONITOR',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_approval_mail_monitor.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批邮件发送作业',:description=>'审批邮件发送作业')
    irm_approval_mail_monitor.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Approval Mail Job',:description=>'Approval Mail Job')
    irm_approval_mail_monitor.save

    irm_monitor_approval_mail= Irm::Menu.new(:menu_code=>'MONITOR_APPROVAL_MAIL',:leaf_flag=>'Y',:not_auto_mult=>true)
    irm_monitor_approval_mail.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批邮件发送作业',:description=>'审批邮件发送作业')
    irm_monitor_approval_mail.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Approval Mail Job',:description=>'Approval Job')
    irm_monitor_approval_mail.save

    irm_menu_entiry_133= Irm::MenuEntry.new(:menu_code=>'MONITOR',:sub_menu_code=>'MONITOR_APPROVAL_MAIL',:page_controller=>nil,:display_sequence=>40,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_133.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批邮件发送作业',:description=>'审批邮件发送作业')
    irm_menu_entiry_133.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Approval Mail Job',:description=>'Approval Mail Job')
    irm_menu_entiry_133.save
    irm_menu_entiry_134= Irm::MenuEntry.new(:menu_code=>'MONITOR_APPROVAL_MAIL',:sub_menu_code=>nil,:page_controller=>'irm/monitor_approval_mails',:display_sequence=>40,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_134.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批邮件发送作业',:description=>'审批邮件发送作业')
    irm_menu_entiry_134.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Approval Mail Job',:description=>'Approval Mail Job')
    irm_menu_entiry_134.save
  end

  def self.down
  end
end
