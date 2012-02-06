# -*- coding: utf-8 -*-
class AddPortletConfigPermission < ActiveRecord::Migration
  def up
    irm_portlet_config= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'PORTLET_CONFIG',:controller=>'irm/portlet_configs',:action=>'index',:not_auto_mult=>true)
    irm_portlet_config.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'个人Portal设置',:description=>'查看，提交，编辑，操作个人Portal设置')
    irm_portlet_config.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portal Setting',:description=>'Submit,edit change Portal Setting')
    irm_portlet_config.save
    irm_portlet_config= Irm::Function.new(:function_group_code=>'PORTLET_CONFIG',:code=>'PORTLET_CONFIG',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_portlet_config.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'个人Portal设置',:description=>'个人Portal设置')
    irm_portlet_config.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portal Setting',:description=>'Portal Setting')
    irm_portlet_config.save
    menu_entiry_114= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'PORTLET_CONFIG',:display_sequence=>45)
    menu_entiry_114.save
  end

  def down
  end
end
