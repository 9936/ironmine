# -*- coding: utf-8 -*-
class AddSkmColumnMenuData < ActiveRecord::Migration
  def self.up
    skm_menu_entiry_144= Irm::MenuEntry.new(:menu_code=>'SERVICE_KNOWLEDGE',:sub_menu_code=>nil,:page_controller=>'skm/columns',:display_sequence=>50,:display_flag=>'Y',:not_auto_mult=>true)
    skm_menu_entiry_144.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'栏目',:description=>'栏目')
    skm_menu_entiry_144.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Columns',:description=>'Columns')
    skm_menu_entiry_144.save
  end

  def self.down

  end
end
