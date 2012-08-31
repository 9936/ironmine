# -*- coding: utf-8 -*-
class InitDataAccessFunctionMenu < ActiveRecord::Migration
  def up
    irm_data_access= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'DATA_ACCESS',:controller=>'irm/data_accesses',:action=>'index',:not_auto_mult=>true)
    irm_data_access.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'共享设置',:description=>'共享设置')
    irm_data_access.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Sharing Setting',:description=>'Sharing Setting')
    irm_data_access.save
    irm_data_access= Irm::Function.new(:function_group_code=>'DATA_ACCESS',:code=>'DATA_ACCESS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_data_access.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'数据访问权限',:description=>'数据访问权限')
    irm_data_access.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Data Access',:description=>'Data Access')
    irm_data_access.save
    menu_entiry_118= Irm::MenuEntry.new(:menu_code=>'SECURITY_CONTROL',:sub_menu_code=>nil,:sub_function_group_code=>'DATA_ACCESS',:display_sequence=>5)
    menu_entiry_118.save
  end

  def down
  end
end
