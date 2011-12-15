# -*- coding: utf-8 -*-
class AddChangeJournalPlanFunction < ActiveRecord::Migration
  def up
    chm_change_plan_type= Irm::FunctionGroup.new(:zone_code=>'CHANGE_SETTING',:code=>'CHANGE_PLAN_TYPE',:controller=>'chm/change_plan_types',:action=>'index',:not_auto_mult=>true)
    chm_change_plan_type.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'计划类型',:description=>'查看,提交,编辑,操作变更单计划类型')
    chm_change_plan_type.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Plan Type',:description=>'Submit,edit change plan type')
    chm_change_plan_type.save

    chm_change_plan_type= Irm::Function.new(:function_group_code=>'CHANGE_PLAN_TYPE',:code=>'CHANGE_PLAN_TYPE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_plan_type.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'计划类型',:description=>'计划类型')
    chm_change_plan_type.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Plan Type',:description=>'Change Plan Type')
    chm_change_plan_type.save

    menu_entiry_109= Irm::MenuEntry.new(:menu_code=>'CHANGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CHANGE_PLAN_TYPE',:display_sequence=>50)
    menu_entiry_109.save

    chm_change_journal= Irm::Function.new(:function_group_code=>'CHANGE_REQUEST',:code=>'CHANGE_JOURNAL',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_journal.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'回复变理单',:description=>'回复变理单')
    chm_change_journal.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Reply Change Request',:description=>'Reply Change Request')
    chm_change_journal.save
    chm_change_plan= Irm::Function.new(:function_group_code=>'CHANGE_REQUEST',:code=>'CHANGE_PLAN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_plan.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理变更计划',:description=>'管理变更计划')
    chm_change_plan.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Change Plan',:description=>'Manage Change Plan')
    chm_change_plan.save
  end

  def down
  end
end
