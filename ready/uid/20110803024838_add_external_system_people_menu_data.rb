# -*- coding: utf-8 -*-
class AddExternalSystemPeopleMenuData < ActiveRecord::Migration
  def self.up
    irm_external_system_people= Irm::Menu.new(:menu_code=>'EXTERNAL_SYSTEM_PEOPLE',:leaf_flag=>'Y',:not_auto_mult=>true)
    irm_external_system_people.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部系统用户管理',:description=>'外部系统用户管理')
    irm_external_system_people.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'External System Members',:description=>'External System Members')
    irm_external_system_people.save

    uid_menu_entiry_142= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM',:sub_menu_code=>'EXTERNAL_SYSTEM_PEOPLE',:page_controller=>nil,:display_sequence=>40,:display_flag=>'Y',:not_auto_mult=>true)
    uid_menu_entiry_142.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部系统用户管理',:description=>'外部系统用户管理')
    uid_menu_entiry_142.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'External System Members',:description=>'External System Members')
    uid_menu_entiry_142.save
    uid_menu_entiry_143= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM_PEOPLE',:sub_menu_code=>nil,:page_controller=>'uid/external_system_members',:display_sequence=>10,:display_flag=>'Y',:not_auto_mult=>true)
    uid_menu_entiry_143.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部系统用户管理',:description=>'外部系统用户管理')
    uid_menu_entiry_143.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'External System Members',:description=>'External System Members')
    uid_menu_entiry_143.save
  end

  def self.down
  end
end
