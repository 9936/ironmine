# -*- coding: utf-8 -*-
class AddSkmColumnMenuData < ActiveRecord::Migration
  def self.up
    irm_skm_column= Irm::FunctionGroup.new(:zone_code=>'SKM_SETTING',:code=>'SKM_COLUMN',:controller=>'skm/columns',:action=>'index',:not_auto_mult=>true)
    irm_skm_column.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'知识库栏目',:description=>'知识库栏目')
    irm_skm_column.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Skm Column',:description=>'Skm Column')
    irm_skm_column.save

    skm_skm_column= Irm::Function.new(:function_group_code=>'SKM_COLUMN',:code=>'SKM_COLUMN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    skm_skm_column.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理知识库栏目',:description=>'管理知识库栏目')
    skm_skm_column.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Skm Columns',:description=>'Manage Skm Columns')
    skm_skm_column.save

    menu_entiry_75= Irm::MenuEntry.new(:menu_code=>'KNOWLEDGE_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'SKM_COLUMN',:display_sequence=>50)
    menu_entiry_75.save
  end

  def self.down

  end
end
