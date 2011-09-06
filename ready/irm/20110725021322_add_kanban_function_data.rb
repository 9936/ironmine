# -*- coding: utf-8 -*-
class AddKanbanFunctionData < ActiveRecord::Migration
  def self.up
    irm_irm_kanban= Irm::FunctionGroup.new(:group_code=>'IRM_KANBAN',:not_auto_mult=>true)
    irm_irm_kanban.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板',:description=>'看板')
    irm_irm_kanban.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Kanban',:description=>'Kanban')
    irm_irm_kanban.save

    irm_view_kanban= Irm::Function.new(:group_code=>'IRM_KANBAN',:function_code=>'VIEW_KANBAN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_kanban.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看看板 ',:description=>'查看看板')
    irm_view_kanban.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Kanban',:description=>'View Kanban')
    irm_view_kanban.save
    irm_create_kanban= Irm::Function.new(:group_code=>'IRM_KANBAN',:function_code=>'CREATE_KANBAN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_create_kanban.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'创建看板',:description=>'创建看板')
    irm_create_kanban.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Create Kanban',:description=>'Create Kanban')
    irm_create_kanban.save
    irm_edit_kanban= Irm::Function.new(:group_code=>'IRM_KANBAN',:function_code=>'EDIT_KANBAN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_kanban.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑看板',:description=>'编辑看板 ')
    irm_edit_kanban.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Kanban',:description=>'Edit Kanban')
    irm_edit_kanban.save
  end

  def self.down
  end
end
