# -*- coding: utf-8 -*-
class ChangeSessionSettingData < ActiveRecord::Migration
  def up
    irm_session_time_out= Irm::FunctionGroup.where(:zone_code=>'SYSTEM_SETTING',:code=>'SESSION_TIME_OUT').first
    irm_session_time_out.destroy

    irm_session_setting= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'SESSION_SETTING',:controller=>'irm/session_settings',:action=>'index',:not_auto_mult=>true)
    irm_session_setting.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'会话设置',:description=>'修改平台全局会话时间')
    irm_session_setting.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Session Setting',:description=>'Session Setting')
    irm_session_setting.save

    irm_session_setting= Irm::Function.new(:function_group_code=>'SESSION_SETTING',:code=>'SESSION_SETTING',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_session_setting.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'会话设置',:description=>'会话设置')
    irm_session_setting.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Session',:description=>'Manage Session')
    irm_session_setting.save

    menu_entiry_117= Irm::MenuEntry.new(:menu_code=>'SECURITY_CONTROL',:sub_menu_code=>nil,:sub_function_group_code=>'SESSION_SETTING',:display_sequence=>20)
    menu_entiry_117.save
  end

  def down
  end
end
