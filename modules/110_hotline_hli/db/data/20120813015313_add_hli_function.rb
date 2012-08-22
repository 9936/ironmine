# -*- coding: utf-8 -*-
class AddHliFunction < ActiveRecord::Migration
  def up
    irm_hotline_project= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'HOTLINE_PROJECT',:controller=>'irm/projects',:action=>'index',:not_auto_mult=>true)
    irm_hotline_project.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Hotline项目',:description=>'Hotline项目')
    irm_hotline_project.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Hotline Project',:description=>'Hotline Project')
    irm_hotline_project.save
    
    irm_hotline_project_new= Irm::Function.new(:function_group_code=>'HOTLINE_PROJECT',:code=>'HOTLINE_PROJECT_NEW',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_hotline_project_new.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建Hotline项目',:description=>'新建Hotline项目')
    irm_hotline_project_new.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Create Hotline Project',:description=>'Create Hotline Project')
    irm_hotline_project_new.save

    irm_view_hotline_project= Irm::Function.new(:function_group_code=>'HOTLINE_PROJECT',:code=>'VIEW_HOTLINE_PROJECT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_hotline_project.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看Hotline项目',:description=>'查看Hotline项目')
    irm_view_hotline_project.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Hotline Project',:description=>'View Hotline Project')
    irm_view_hotline_project.save

    irm_edit_hotline_project= Irm::Function.new(:function_group_code=>'HOTLINE_PROJECT',:code=>'EDIT_HOTLINE_PROJECT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_hotline_project.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑Hotline项目',:description=>'编辑Hotline项目')
    irm_edit_hotline_project.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Hotline Project',:description=>'Edit Hotline Project')
    irm_edit_hotline_project.save

    irm_edit_self_hotline_project= Irm::Function.new(:function_group_code=>'HOTLINE_PROJECT',:code=>'EDIT_SELF_HOTLINE_PROJECT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_self_hotline_project.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑自己的项目',:description=>'编辑自己的项目')
    irm_edit_self_hotline_project.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Self Project',:description=>'Edit Self Project')
    irm_edit_self_hotline_project.save

    hotline= Irm::Menu.new(:code=>'HOTLINE',:not_auto_mult=>true)
    hotline.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Hotline',:description=>'Hotline')
    hotline.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Hotline',:description=>'Hotline')
    hotline.save

    menu_entiry_122= Irm::MenuEntry.new(:menu_code=>'MANAGEMENT_SETTING',:sub_menu_code=>'HOTLINE',:sub_function_group_code=>nil,:display_sequence=>80)
    menu_entiry_122.save
    menu_entiry_123= Irm::MenuEntry.new(:menu_code=>'HOTLINE',:sub_menu_code=>nil,:sub_function_group_code=>'HOTLINE_PROJECT',:display_sequence=>10)
    menu_entiry_123.save
  end

  def down
  end
end
