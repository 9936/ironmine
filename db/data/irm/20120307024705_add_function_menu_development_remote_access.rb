# -*- coding: utf-8 -*-
class AddFunctionMenuDevelopmentRemoteAccess < ActiveRecord::Migration
  def up
    irm_remote_access_client= Irm::FunctionGroup.new(:zone_code=>'DEVELOPMENT_SETTING',:code=>'REMOTE_ACCESS_CLIENT',:controller=>'irm/oauth_access_clients',:action=>'index',:not_auto_mult=>true)
    irm_remote_access_client.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'远程访问',:description=>'远程访问')
    irm_remote_access_client.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Remote Access',:description=>'Remote Access')
    irm_remote_access_client.save

    irm_remote_access_client= Irm::Function.new(:function_group_code=>'REMOTE_ACCESS_CLIENT',:code=>'REMOTE_ACCESS_CLIENT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_remote_access_client.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'远程访问',:description=>'远程访问')
    irm_remote_access_client.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Remote Access',:description=>'Remote Access')
    irm_remote_access_client.save

    development= Irm::Menu.new(:code=>'DEVELOPMENT',:not_auto_mult=>true)
    development.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'开发',:description=>'开发')
    development.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Development',:description=>'Development')
    development.save


    menu_entiry_121= Irm::MenuEntry.new(:menu_code=>'DEVELOPMENT',:sub_menu_code=>nil,:sub_function_group_code=>'REMOTE_ACCESS_CLIENT',:display_sequence=>10)
    menu_entiry_121.save


  end

  def down
  end
end
