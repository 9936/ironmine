# -*- coding: utf-8 -*-
class InitReportMenuFunction < ActiveRecord::Migration
  def self.up
   deletable_function_params = [
     ["IRM_PERMISSION","VIEW_REPORT_GROUPS"],
     ["IRM_PERMISSION","CREATE_REPORT_GROUPS"],
     ["IRM_PERMISSION","EDIT_REPORT_GROUPS"],
     ["IRM_PERMISSION","ADD_REPORT_TO_GROUP"],
     ["IRM_AUTOMATOR","VIEW_SCRIPTS"],
     ["IRM_AUTOMATOR","CREATE_SCRIPTS"],
     ["IRM_AUTOMATOR","EDIT_SCRIPTS"],
     ["IRM_SYSTEM_HOME_PAGE","VIEW_REPORT_LISTS"]
   ]
   deletable_function_params.each do |i|
     f = Irm::Function.where(:group_code=>i[0],:function_code=>i[1]).first
     f.destroy if f
   end

   irm_irm_report= Irm::FunctionGroup.new(:group_code=>'IRM_REPORT',:not_auto_mult=>true)
   irm_irm_report.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表',:description=>'报表')
   irm_irm_report.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report',:description=>'Report')
   irm_irm_report.save

   irm_view_reports= Irm::Function.new(:group_code=>'IRM_REPORT',:function_code=>'VIEW_REPORTS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
   irm_view_reports.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看,运行报表',:description=>'查看,运行报表')
   irm_view_reports.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View and Run Report',:description=>'View and Run Report')
   irm_view_reports.save
   irm_create_reports= Irm::Function.new(:group_code=>'IRM_REPORT',:function_code=>'CREATE_REPORTS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
   irm_create_reports.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建报表',:description=>'新建报表')
   irm_create_reports.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New Report',:description=>'New Report')
   irm_create_reports.save
   irm_edit_reports= Irm::Function.new(:group_code=>'IRM_REPORT',:function_code=>'EDIT_REPORTS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
   irm_edit_reports.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑报表',:description=>'编辑报表')
   irm_edit_reports.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Report',:description=>'Edit Report')
   irm_edit_reports.save
   irm_view_report_folders= Irm::Function.new(:group_code=>'IRM_REPORT',:function_code=>'VIEW_REPORT_FOLDERS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
   irm_view_report_folders.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表文件夹',:description=>'报表文件夹')
   irm_view_report_folders.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Folder',:description=>'Report Folder')
   irm_view_report_folders.save
   irm_create_report_folders= Irm::Function.new(:group_code=>'IRM_REPORT',:function_code=>'CREATE_REPORT_FOLDERS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
   irm_create_report_folders.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'新建报表文件夹',:description=>'新建报表文件夹')
   irm_create_report_folders.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'New Report Folder',:description=>'New Report Folder')
   irm_create_report_folders.save
   irm_edit_report_folders= Irm::Function.new(:group_code=>'IRM_REPORT',:function_code=>'EDIT_REPORT_FOLDERS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
   irm_edit_report_folders.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'编辑报表文件夹',:description=>'编辑报表文件夹')
   irm_edit_report_folders.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Report Folder',:description=>'Edit Report Folder')
   irm_edit_report_folders.save
    
   deletable_entries = [
       ["REPORT","","irm/report_lists"],
       ["REPORT","","icm/incident_reports"],
       ["REPORT","","skm/entry_reports"],
       ["SECURITY_COMPONENTS","REPORT_GROUP"],
       ["REPORT_GROUP","","irm/report_groups"],
       ["REPORT_GROUP","","irm/report_group_members"]]
   deletable_entries.each do |m|
     menu_entry = Irm::MenuEntry.where(:menu_code=>m[0])
     if(m[1].present?)
       menu_entry = menu_entry.where(:sub_menu_code=>m[1])
     end
     if(m[2].present?)
       menu_entry = menu_entry.where(:page_controller=>m[2])
     end
     menu_entry = menu_entry.first
     menu_entry.destroy if menu_entry
   end

   irm_menu_entiry_123= Irm::MenuEntry.new(:menu_code=>'REPORT',:sub_menu_code=>nil,:page_controller=>'irm/reports',:display_sequence=>10,:display_flag=>'Y',:not_auto_mult=>true)
   irm_menu_entiry_123.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表',:description=>'报表')
   irm_menu_entiry_123.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report',:description=>'Report')
   irm_menu_entiry_123.save
   icm_menu_entiry_124= Irm::MenuEntry.new(:menu_code=>'REPORT',:sub_menu_code=>nil,:page_controller=>'icm/report_folders',:display_sequence=>20,:display_flag=>'N',:not_auto_mult=>true)
   icm_menu_entiry_124.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表文件夹',:description=>'报表文件夹')
   icm_menu_entiry_124.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Folder',:description=>'Report Folder')
   icm_menu_entiry_124.save
  end

  def self.down
  end
end
