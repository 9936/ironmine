# -*- coding: utf-8 -*-
class AddSecurityControlMenuData < ActiveRecord::Migration
  def self.up
    menu_entiry_94= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'SECURITY_CONTROL',:sub_function_group_code=>nil,:display_sequence=>130)
    menu_entiry_94.save
  end

  def self.down
  end
end
