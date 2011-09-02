# -*- coding: utf-8 -*-
class AddMyProfileFunctionData < ActiveRecord::Migration
  def self.up
    irm_my_profile= Irm::FunctionGroup.new(:zone_code=>'PERSONAL_SETTING',:code=>'MY_PROFILE',:controller=>'irm/my_profiles',:action=>'index',:not_auto_mult=>true)
    irm_my_profile.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我的简档',:description=>'我的简档')
    irm_my_profile.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'My Profile',:description=>'My Profile')
    irm_my_profile.save

    irm_my_profile= Irm::Function.new(:function_group_code=>'MY_PROFILE',:code=>'MY_PROFILE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_my_profile.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我的简档',:description=>'我的简档')
    irm_my_profile.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'My Profile',:description=>'My Profile')
    irm_my_profile.save

    menu_entiry_6= Irm::MenuEntry.new(:menu_code=>'PERSON_INFO',:sub_menu_code=>nil,:sub_function_group_code=>'MY_PROFILE',:display_sequence=>15)
    menu_entiry_6.save
  end

  def self.down
  end
end
