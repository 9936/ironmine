# -*- coding: utf-8 -*-
class AddChangeTaskMenuFunction < ActiveRecord::Migration
  def up
    chm_change_task_phase= Irm::FunctionGroup.new(:zone_code=>'CHANGE_SETTING',:code=>'CHANGE_TASK_PHASE',:controller=>'chm/change_task_phases',:action=>'index',:not_auto_mult=>true)
    chm_change_task_phase.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'任务阶段',:description=>'查看,提交,编辑,操作变更任务阶段')
    chm_change_task_phase.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Task Phase',:description=>'Submit,edit change task phase')
    chm_change_task_phase.save
    chm_change_task_template= Irm::FunctionGroup.new(:zone_code=>'CHANGE_SETTING',:code=>'CHANGE_TASK_TEMPLATE',:controller=>'chm/change_task_templates',:action=>'index',:not_auto_mult=>true)
    chm_change_task_template.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'任务模板',:description=>'查看,提交,编辑,操作变更任务模板及模板任务')
    chm_change_task_template.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Task Template',:description=>'Submit,edit change task template')
    chm_change_task_template.save
    chm_change_task_phase= Irm::Function.new(:function_group_code=>'CHANGE_TASK_PHASE',:code=>'CHANGE_TASK_PHASE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_task_phase.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更任务阶段',:description=>'变更任务阶段')
    chm_change_task_phase.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Task Phase',:description=>'Change Task Phase')
    chm_change_task_phase.save
    chm_change_task_template= Irm::Function.new(:function_group_code=>'CHANGE_TASK_TEMPLATE',:code=>'CHANGE_TASK_TEMPLATE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_task_template.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更任务模板',:description=>'变更任务模板')
    chm_change_task_template.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Task Template',:description=>'Change Task Template')
    chm_change_task_template.save
    chm_change_task= Irm::Function.new(:function_group_code=>'CHANGE_REQUEST',:code=>'CHANGE_TASK',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_change_task.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'变更任务',:description=>'变更任务')
    chm_change_task.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Change Task',:description=>'Change Task')
    chm_change_task.save
    menu_entiry_110= Irm::MenuEntry.new(:menu_code=>'CHANGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CHANGE_TASK_PHASE',:display_sequence=>60)
    menu_entiry_110.save
    menu_entiry_111= Irm::MenuEntry.new(:menu_code=>'CHANGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CHANGE_TASK_TEMPLATE',:display_sequence=>70)
    menu_entiry_111.save
  end

  def down
  end
end
