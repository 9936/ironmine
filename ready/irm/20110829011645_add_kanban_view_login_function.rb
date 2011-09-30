# -*- coding: utf-8 -*-
class AddKanbanViewLoginFunction < ActiveRecord::Migration
  def self.up
    irm_view_kanban= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'VIEW_KANBAN',:default_flag=>'N',:login_flag => 'Y', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_kanban.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'看板访问功能',:description=>'看板访问功能')
    irm_view_kanban.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Kanban View',:description=>'Manage Kanban View')
    irm_view_kanban.save
  end

  def self.down
  end
end
