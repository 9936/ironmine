# -*- coding: utf-8 -*-
class AddPasswordPolicyMenuData < ActiveRecord::Migration
  def self.up
    irm_password_policy= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'PASSWORD_POLICY',:controller=>'irm/password_policies',:action=>'index',:not_auto_mult=>true)
    irm_password_policy.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'密码策略设置',:description=>'密码策略设置')
    irm_password_policy.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Password Policy',:description=>'Password Policy')
    irm_password_policy.save

    irm_password_policy= Irm::Function.new(:function_group_code=>'PASSWORD_POLICY',:code=>'PASSWORD_POLICY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_password_policy.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理密码策略',:description=>'管理密码策略')
    irm_password_policy.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Password Policy',:description=>'Manage Password Policy')
    irm_password_policy.save

    security_control= Irm::Menu.new(:code=>'SECURITY_CONTROL',:not_auto_mult=>true)
    security_control.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'安全控制',:description=>'安全控制')
    security_control.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Security Control',:description=>'Security Control')
    security_control.save

    menu_entiry_93= Irm::MenuEntry.new(:menu_code=>'SECURITY_CONTROL',:sub_menu_code=>nil,:sub_function_group_code=>'PASSWORD_POLICY',:display_sequence=>10)
    menu_entiry_93.save
  end

  def self.down
  end
end
