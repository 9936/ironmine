# -*- coding: utf-8 -*-
class AddBulletinColumnMenuData < ActiveRecord::Migration
  def self.up
    irm_bulletin_setting= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'BULLETIN_SETTING',:controller=>'irm/bulletins',:action=>'index',:not_auto_mult=>true)
    irm_bulletin_setting.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公告设置',:description=>'公告设置')
    irm_bulletin_setting.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Bulletin Setting',:description=>'Bulletin Setting')
    irm_bulletin_setting.save
    irm_bulletin_column= Irm::FunctionGroup.new(:zone_code=>'BULLETIN_SETTING',:code=>'BULLETIN_COLUMN',:controller=>'irm/bu_columns',:action=>'index',:not_auto_mult=>true)
    irm_bulletin_column.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公告栏目',:description=>'公告栏目')
    irm_bulletin_column.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Bulletin Setting',:description=>'Bulletin Setting')
    irm_bulletin_column.save

    irm_bulletin_column= Irm::Function.new(:function_group_code=>'BULLETIN_COLUMN',:code=>'BULLETIN_COLUMN',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_bulletin_column.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理公告栏目',:description=>'管理公告栏目')
    irm_bulletin_column.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Bulletin Columns',:description=>'Manage Bulletin Columns')
    irm_bulletin_column.save

    bulletin_management= Irm::Menu.new(:code=>'BULLETIN_MANAGEMENT',:not_auto_mult=>true)
    bulletin_management.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'公告管理',:description=>'公告管理')
    bulletin_management.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Bulletn',:description=>'Bulletin')
    bulletin_management.save

    menu_entiry_87= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'BULLETIN_MANAGEMENT',:sub_function_group_code=>nil,:display_sequence=>120)
    menu_entiry_87.save
    menu_entiry_88= Irm::MenuEntry.new(:menu_code=>'BULLETIN_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'BULLETIN_COLUMN',:display_sequence=>10)
    menu_entiry_88.save
  end

  def self.down
  end
end
