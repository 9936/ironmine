# -*- coding: utf-8 -*-
class AddConfigManagementMenu < ActiveRecord::Migration
  def up
    config_management= Irm::Menu.new(:code=>'CONFIG_MANAGEMENT',:not_auto_mult=>true)
    config_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'配置管理',:description=>'配置管理相关设置')
    config_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Config Management',:description=>'Config Management')
    config_management.save

    menu_entiry_124= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'CONFIG_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>56)
    menu_entiry_124.save
  end

  def down
  end
end
