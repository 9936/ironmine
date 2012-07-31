# -*- coding: utf-8 -*-
class InitConfigItemStatusFunction < ActiveRecord::Migration
  def up
    com_config_item_status= Irm::FunctionGroup.new(:zone_code=>'CONFIG_MANAGEMENT',:code=>'CONFIG_ITEM_STATUS',:controller=>'com/config_item_statuses',:action=>'index',:not_auto_mult=>true)
    com_config_item_status.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'配置项状态',:description=>'配置项状态')
    com_config_item_status.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Item Status',:description=>'Config Item Status')
    com_config_item_status.save
    com_config_item_status= Irm::Function.new(:function_group_code=>'CONFIG_ITEM_STATUS',:code=>'CONFIG_ITEM_STATUS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    com_config_item_status.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'配置项状态',:description=>'配置项状态')
    com_config_item_status.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Item Status',:description=>'Config Item Status')
    com_config_item_status.save
    menu_entiry_128= Irm::MenuEntry.new(:menu_code=>'CONFIG_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CONFIG_ITEM_STATUS',:display_sequence=>40)
    menu_entiry_128.save
  end

  def down
  end
end
