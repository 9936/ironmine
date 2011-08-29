# -*- coding: utf-8 -*-
class AddIcmKanbanFunction < ActiveRecord::Migration
  def self.up
    icm_view_icm_kanban= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'VIEW_ICM_KANBAN',:default_flag=>'N',:login_flag => 'Y', :public_flag=>'N',:not_auto_mult=>true)
    icm_view_icm_kanban.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看看板',:description=>'查看看板')
    icm_view_icm_kanban.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View ICM Kanban',:description=>'View ICM Kanban')
    icm_view_icm_kanban.save
  end

  def self.down
  end
end
