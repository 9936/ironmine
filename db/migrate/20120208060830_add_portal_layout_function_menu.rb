class AddPortalLayoutFunctionMenu < ActiveRecord::Migration
  def up
    irm_portal_layout= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'PORTAL_LAYOUT',:controller=>'irm/portal_layouts',:action=>'index',:not_auto_mult=>true)
    irm_portal_layout.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Portal布局',:description=>'查看，提交，编辑，操作Portal布局')
    irm_portal_layout.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portal Layout',:description=>'Submit,edit change Portal Layout')
    irm_portal_layout.save

    irm_portal_layout= Irm::Function.new(:function_group_code=>'PORTAL_LAYOUT',:code=>'PORTAL_LAYOUT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_portal_layout.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Portal布局',:description=>'查看，提交，编辑，操作Portal布局')
    irm_portal_layout.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portal Layout',:description=>'Submit,edit change Portal Layout')
    irm_portal_layout.save
    menu_entiry_116= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>nil,:sub_function_group_code=>'PORTAL_LAYOUT',:display_sequence=>37)
    menu_entiry_116.save


  end

  def down
  end
end
