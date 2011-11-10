# -*- coding: utf-8 -*-
class AddMailRequestPermissionData < ActiveRecord::Migration
  def up
    irm_mail_request= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'MAIL_REQUEST',:controller=>'icm/mail_requests',:action=>'index',:not_auto_mult=>true)
    irm_mail_request.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'邮件事故单设置',:description=>'邮件事故单设置')
    irm_mail_request.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Mail Request Conf.',:description=>'Mail Request Conf.')
    irm_mail_request.save

    icm_view_mail_request= Irm::Function.new(:function_group_code=>'MAIL_REQUEST',:code=>'VIEW_MAIL_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_view_mail_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看邮件事故单配置',:description=>'查看邮件事故单配置')
    icm_view_mail_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Mail Request Conf.',:description=>'View Mail Request Conf.')
    icm_view_mail_request.save
    icm_edit_mail_request= Irm::Function.new(:function_group_code=>'MAIL_REQUEST',:code=>'EDIT_MAIL_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_edit_mail_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑邮件事故单配置',:description=>'编辑邮件事故单配置')
    icm_edit_mail_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Mail Request Conf.',:description=>'Edit Mail Request Conf.')
    icm_edit_mail_request.save

    menu_entiry_101= Irm::MenuEntry.new(:menu_code=>'MAIL_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'MAIL_REQUEST',:display_sequence=>30)
    menu_entiry_101.save
  end

  def down
  end
end
