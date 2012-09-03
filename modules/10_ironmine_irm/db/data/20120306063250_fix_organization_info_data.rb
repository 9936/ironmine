# -*- coding: utf-8 -*-
class FixOrganizationInfoData < ActiveRecord::Migration
  def up
    irm_organization_info= Irm::FunctionGroup.where(:zone_code=>'SYSTEM_SETTING',:code=>'ORGANIZATION_INFO').first
    irm_organization_info.destroy

    irm_organization_info= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_SETTING',:code=>'ORGANIZATION_INFO',:controller=>'irm/organization_infos',:action=>'index',:not_auto_mult=>true)
    irm_organization_info.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'组织信息',:description=>'新建、查看、编辑一组织信息')
    irm_organization_info.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Organization Info',:description=>'Organization Info')
    irm_organization_info.save

    irm_organization_info= Irm::Function.new(:function_group_code=>'ORGANIZATION_INFO',:code=>'ORGANIZATION_INFO',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_organization_info.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理组织信息',:description=>'管理组织信息')
    irm_organization_info.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Organization Info',:description=>'Manage Organization Info')
    irm_organization_info.save

    menu_entiry_119= Irm::MenuEntry.new(:menu_code=>'ORGANIZATION_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'ORGANIZATION_INFO',:display_sequence=>30)
    menu_entiry_119.save
  end

  def down
  end
end
