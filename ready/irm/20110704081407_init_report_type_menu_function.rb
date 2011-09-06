# -*- coding: utf-8 -*-
class InitReportTypeMenuFunction < ActiveRecord::Migration
  def self.up
    irm_report_setting= Irm::Menu.new(:menu_code=>'REPORT_SETTING',:leaf_flag=>'N',:not_auto_mult=>true)
    irm_report_setting.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表',:description=>'报表')
    irm_report_setting.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report',:description=>'Report')
    irm_report_setting.save
    irm_report_type= Irm::Menu.new(:menu_code=>'REPORT_TYPE',:leaf_flag=>'Y',:not_auto_mult=>true)
    irm_report_type.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类型',:description=>'报表类型')
    irm_report_type.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Type',:description=>'Report Type')
    irm_report_type.save

    irm_menu_entiry_42= Irm::MenuEntry.new(:menu_code=>'DEV_TOOLS',:sub_menu_code=>'REPORT_SETTING',:page_controller=>nil,:display_sequence=>40,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_42.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表',:description=>'报表')
    irm_menu_entiry_42.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report',:description=>'Report')
    irm_menu_entiry_42.save
    irm_menu_entiry_43= Irm::MenuEntry.new(:menu_code=>'REPORT_SETTING',:sub_menu_code=>nil,:page_controller=>'irm/report_type_categories',:display_sequence=>10,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_43.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类别',:description=>'报表类别')
    irm_menu_entiry_43.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Category',:description=>'Report Category')
    irm_menu_entiry_43.save
    irm_menu_entiry_44= Irm::MenuEntry.new(:menu_code=>'REPORT_SETTING',:sub_menu_code=>'REPORT_TYPE',:page_controller=>nil,:display_sequence=>20,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_44.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类型',:description=>'报表类型')
    irm_menu_entiry_44.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Type',:description=>'Report Type')
    irm_menu_entiry_44.save
    irm_menu_entiry_45= Irm::MenuEntry.new(:menu_code=>'REPORT_TYPE',:sub_menu_code=>nil,:page_controller=>'irm/report_types',:display_sequence=>10,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_45.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类型',:description=>'报表类型')
    irm_menu_entiry_45.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Type',:description=>'Report Type')
    irm_menu_entiry_45.save
    irm_menu_entiry_46= Irm::MenuEntry.new(:menu_code=>'REPORT_TYPE',:sub_menu_code=>nil,:page_controller=>'irm/report_type_sections',:display_sequence=>20,:display_flag=>'N',:not_auto_mult=>true)
    irm_menu_entiry_46.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表字段分区',:description=>'报表字段分区')
    irm_menu_entiry_46.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Field Section',:description=>'Report Field Section')
    irm_menu_entiry_46.save


    Irm::MenuEntry.where(:page_controller=>"irm/reports").each do |m|
      m.destroy
    end

    irm_irm_report_type= Irm::FunctionGroup.new(:group_code=>'IRM_REPORT_TYPE',:not_auto_mult=>true)
    irm_irm_report_type.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类型',:description=>'报表类型')
    irm_irm_report_type.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Type',:description=>'Report Type')
    irm_irm_report_type.save

    irm_view_report_type_category= Irm::Function.new(:group_code=>'IRM_REPORT_TYPE',:function_code=>'VIEW_REPORT_TYPE_CATEGORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_report_type_category.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类别',:description=>'报表类别')
    irm_view_report_type_category.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Type Category',:description=>'Report Type Category')
    irm_view_report_type_category.save
    irm_create_report_type_category= Irm::Function.new(:group_code=>'IRM_REPORT_TYPE',:function_code=>'CREATE_REPORT_TYPE_CATEGORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_create_report_type_category.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建报表类别',:description=>'新建报表类别')
    irm_create_report_type_category.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Create Report Type Category',:description=>'Create Report Type Category')
    irm_create_report_type_category.save
    irm_edit_report_type_category= Irm::Function.new(:group_code=>'IRM_REPORT_TYPE',:function_code=>'EDIT_REPORT_TYPE_CATEGORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_report_type_category.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑报表类别',:description=>'编辑报表类别')
    irm_edit_report_type_category.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Report Type Category',:description=>'Edit Report Type Category')
    irm_edit_report_type_category.save
    irm_view_report_type= Irm::Function.new(:group_code=>'IRM_REPORT_TYPE',:function_code=>'VIEW_REPORT_TYPE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_view_report_type.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表类型',:description=>'报表类型')
    irm_view_report_type.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Type',:description=>'Report Type')
    irm_view_report_type.save
    irm_create_report_type= Irm::Function.new(:group_code=>'IRM_REPORT_TYPE',:function_code=>'CREATE_REPORT_TYPE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_create_report_type.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建报表类型',:description=>'新建报表类型')
    irm_create_report_type.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Create Report Type',:description=>'Create Report Type')
    irm_create_report_type.save
    irm_edit_report_type= Irm::Function.new(:group_code=>'IRM_REPORT_TYPE',:function_code=>'EDIT_REPORT_TYPE',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_edit_report_type.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑报表类型',:description=>'编辑报表类型')
    irm_edit_report_type.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Report Type',:description=>'Edit Report Type')
    irm_edit_report_type.save
    


  end

  def self.down
  end
end
