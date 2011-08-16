# -*- coding: utf-8 -*-
class AddExternalSystemMembersPermissionData < ActiveRecord::Migration
  def self.up
    uid_external_system_member= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'EXTERNAL_SYSTEM_MEMBER',:controller=>'uid/external_system_members',:action=>'index',:not_auto_mult=>true)
    uid_external_system_member.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'外部系统成员',:description=>'外部系统成员')
    uid_external_system_member.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'External System Members',:description=>'External System Members')
    uid_external_system_member.save

    uid_external_system_member= Irm::Function.new(:function_group_code=>'EXTERNAL_SYSTEM_MEMBER',:code=>'EXTERNAL_SYSTEM_MEMBER',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    uid_external_system_member.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理外部系统成员',:description=>'管理外部系统成员')
    uid_external_system_member.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage External System Members',:description=>'Manage External System Members')
    uid_external_system_member.save

    menu_entiry_57= Irm::MenuEntry.new(:menu_code=>'EXTERNAL_SYSTEM_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'EXTERNAL_SYSTEM_MEMBER',:display_sequence=>40)
    menu_entiry_57.save
  end

  def self.down
  end
end
