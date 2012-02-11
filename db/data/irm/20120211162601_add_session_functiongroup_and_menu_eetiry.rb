# -*- coding: utf-8 -*-
class AddSessionFunctiongroupAndMenuEetiry < ActiveRecord::Migration
  def up
    irm_session_time_out= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'SESSION_TIME_OUT',:controller=>'irm/password_policies',:action=>'index',:not_auto_mult=>true)
    irm_session_time_out.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'会话超时设置',:description=>'修改平台全局会话超时时间')
    irm_session_time_out.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Session Time Out',:description=>'Session Time Out')
    irm_session_time_out.save

    irm_session_time_out= Irm::Function.new(:function_group_code=>'SESSION_TIME_OUT',:code=>'SESSION_TIME_OUT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_session_time_out.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'会话超时设置',:description=>'会话超时设置')
    irm_session_time_out.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Session Time',:description=>'Manage Session Time')
    irm_session_time_out.save

    menu_entiry_117= Irm::MenuEntry.new(:menu_code=>'SECURITY_CONTROL',:sub_menu_code=>nil,:sub_function_group_code=>'SESSION_TIME_OUT',:display_sequence=>20)
    menu_entiry_117.save
  end

  def down
  end
end
