# -*- coding: utf-8 -*-
class AddMenuFunctionGroup < ActiveRecord::Migration
  def up
    irm_portlet= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'PORTLET',:controller=>'irm/portlets',:action=>'index',:not_auto_mult=>true)
    irm_portlet.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理Portlet',:description=>'查看，提交，编辑，操作Portlet')
    irm_portlet.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portlet',:description=>'Submit,edit change Portlet')
    irm_portlet.save

    irm_portlet= Irm::Function.new(:function_group_code=>'PORTLET',:code=>'PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理Portlet',:description=>'管理Portlet')
    irm_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portlet',:description=>'Portlet ')
    irm_portlet.save

    menu_entiry_115= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'PORTLET',:display_sequence=>39)
    menu_entiry_115.save
  end

  def down

  end
end
