# -*- coding: utf-8 -*-
class AddMailSettingPermissionData < ActiveRecord::Migration
  def up
    irm_mail_setting= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'MAIL_SETTING',:controller=>'irm/mail_settings',:action=>'index',:not_auto_mult=>true)
    irm_mail_setting.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'邮件服务器设置',:description=>'邮件服务器设置')
    irm_mail_setting.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Mail Server Configuration',:description=>'Mail Server Configuration')
    irm_mail_setting.save

    irm_view_mail_setting= Irm::Function.new(:function_group_code=>'MAIL_SETTING',:code=>'VIEW_MAIL_SETTING',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_mail_setting.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看邮件服务器信息',:description=>'查看邮件服务器信息')
    irm_view_mail_setting.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Mail Server',:description=>'View Mail Server')
    irm_view_mail_setting.save
    irm_edit_mail_setting= Irm::Function.new(:function_group_code=>'MAIL_SETTING',:code=>'EDIT_MAIL_SETTING',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_mail_setting.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑邮件服务器配置',:description=>'编辑邮件服务器配置')
    irm_edit_mail_setting.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Mail Server Configuration',:description=>'Edit Mail Server Configuration')
    irm_edit_mail_setting.save

    menu_entiry_100= Irm::MenuEntry.new(:menu_code=>'MAIL_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MAIL_SETTING',:display_sequence=>20, :not_auto_mult=>true)
    menu_entiry_100.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'邮件服务器设置',:description=>'邮件服务器设置')
    menu_entiry_100.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Mail Server Configuration',:description=>'Mail Server Configuration')
    menu_entiry_100.save
  end

  def down
  end
end
