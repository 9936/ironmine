# -*- coding: utf-8 -*-
class AddConfigItemFunction < ActiveRecord::Migration
  def up
    com_config_item= Irm::FunctionGroup.new(:zone_code=>'CONFIG_MANAGEMENT',:code=>'CONFIG_ITEM',:controller=>'com/config_items',:action=>'index',:not_auto_mult=>true)
    com_config_item.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'配置项',:description=>'配置项')
    com_config_item.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Item',:description=>'Config Item')
    com_config_item.save
    com_config_item= Irm::Function.new(:function_group_code=>'CONFIG_ITEM',:code=>'CONFIG_ITEM',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    com_config_item.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'配置项',:description=>'配置项')
    com_config_item.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Item',:description=>'Config Item')
    com_config_item.save
    menu_entiry_127= Irm::MenuEntry.new(:menu_code=>'CONFIG_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'CONFIG_ITEM',:display_sequence=>40)
    menu_entiry_127.save
     
  end

  def down
  end
end
