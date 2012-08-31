# -*- coding: utf-8 -*-
class InitIncidentCategoryMenu < ActiveRecord::Migration
  def up
    icm_incident_category= Irm::FunctionGroup.new(:zone_code=>'INCIDENT_SETTING',:code=>'INCIDENT_CATEGORY',:controller=>'icm/incident_categories',:action=>'index',:not_auto_mult=>true)
    icm_incident_category.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'事故单分类设置',:description=>'事故单分类设置')
    icm_incident_category.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Incident Category',:description=>'Incident Category')
    icm_incident_category.save

    icm_incident_category= Irm::Function.new(:function_group_code=>'INCIDENT_CATEGORY',:code=>'INCIDENT_CATEGORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_incident_category.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理事故单分类',:description=>'管理事故单分类')
    icm_incident_category.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Manage Incident Category',:description=>'Manage Incident Category')
    icm_incident_category.save

    menu_entiry_103= Irm::MenuEntry.new(:menu_code=>'INCIDENT_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'INCIDENT_CATEGORY',:display_sequence=>35)
     menu_entiry_103.save
  end

  def down
  end
end
