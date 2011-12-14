# -*- coding: utf-8 -*-
class AddChangeJournalPlanFunction < ActiveRecord::Migration
  def up
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
