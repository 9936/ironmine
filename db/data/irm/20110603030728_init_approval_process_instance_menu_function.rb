# -*- coding: utf-8 -*-
class InitApprovalProcessInstanceMenuFunction < ActiveRecord::Migration
  def self.up
    irm_wf_process_approval= Irm::Function.new(:group_code=>'IRM_SYSTEM_HOME_PAGE',:function_code=>'WF_PROCESS_APPROVAL',:default_flag=>'Y',:login_flag => 'Y', :public_flag=>'N',:not_auto_mult=>true)
    irm_wf_process_approval.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'个人审批',:description=>'个人审批')
    irm_wf_process_approval.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Personal approval',:description=>'Personal approval')
    irm_wf_process_approval.save
    irm_menu_entiry_124= Irm::MenuEntry.new(:menu_code=>'HOME',:sub_menu_code=>nil,:page_controller=>'irm/wf_process_instances',:display_sequence=>50,:display_flag=>'N',:not_auto_mult=>true)
    irm_menu_entiry_124.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批流程',:description=>'审批流程')
    irm_menu_entiry_124.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Approval Process',:description=>'Approval Process')
    irm_menu_entiry_124.save
    irm_menu_entiry_125= Irm::MenuEntry.new(:menu_code=>'HOME',:sub_menu_code=>nil,:page_controller=>'irm/wf_step_instances',:display_sequence=>60,:display_flag=>'N',:not_auto_mult=>true)
    irm_menu_entiry_125.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'审批步骤',:description=>'审批步骤')
    irm_menu_entiry_125.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Approval Step',:description=>'Approval Step')
    irm_menu_entiry_125.save
  end

  def self.down
  end
end
