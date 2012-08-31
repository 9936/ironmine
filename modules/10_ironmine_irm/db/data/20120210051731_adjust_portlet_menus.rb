# -*- coding: utf-8 -*-
class AdjustPortletMenus < ActiveRecord::Migration
  def up

     execute("DELETE FROM irm_menu_entries_tl WHERE menu_entry_id IN ( SELECT ime.id FROM irm_menu_entries ime WHERE ime.sub_function_group_id IN ( SELECT id FROM irm_function_groups ifg WHERE ifg. CODE IN ( 'PORTLET_CONFIG', 'PORTLET', 'PORTAL_LAYOUT' )))")
     execute("DELETE FROM irm_menu_entries WHERE sub_function_group_id IN ( SELECT id FROM irm_function_groups ifg WHERE ifg. CODE IN ( 'PORTLET_CONFIG', 'PORTLET', 'PORTAL_LAYOUT' ))")
     execute("DELETE FROM irm_functions_tl WHERE function_id IN ( SELECT id FROM irm_functions ifs WHERE ifs. CODE IN ( 'PORTLET_CONFIG', 'PORTLET', 'BULLETIN_PORTLET', 'ENTRY_HEADER_PORTLET', 'TODO_TASK_PORTLET', 'REPORT_PORTLET', 'PORTAL_LAYOUT' ))")
     execute("DELETE FROM irm_functions WHERE `code` IN ( 'PORTLET_CONFIG', 'PORTLET', 'BULLETIN_PORTLET', 'ENTRY_HEADER_PORTLET', 'TODO_TASK_PORTLET', 'REPORT_PORTLET', 'PORTAL_LAYOUT' )")
     execute("DELETE FROM irm_function_groups_tl WHERE function_group_id IN ( SELECT ifg.id FROM irm_function_groups ifg WHERE ifg. CODE IN ( 'PORTLET_CONFIG', 'PORTLET', 'PORTAL_LAYOUT' ))")
     execute("DELETE FROM irm_function_groups WHERE `code` IN ( 'PORTLET_CONFIG', 'PORTLET', 'PORTAL_LAYOUT' )")


    irm_portlet= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'PORTLET',:controller=>'irm/portlets',:action=>'index',:not_auto_mult=>true)
    irm_portlet.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理Portlet',:description=>'查看，提交，编辑，操作Portlet')
    irm_portlet.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portlet ',:description=>'Submit,edit change Portlet')
    irm_portlet.save
    irm_portal_layout= Irm::FunctionGroup.new(:zone_code=>'SYSTEM_CREATE',:code=>'PORTAL_LAYOUT',:controller=>'irm/portal_layouts',:action=>'index',:not_auto_mult=>true)
    irm_portal_layout.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Portal布局',:description=>'查看，提交，编辑，操作Portal布局')
    irm_portal_layout.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portal Layout',:description=>'Submit,edit change Portal Layout')
    irm_portal_layout.save

     irm_portal_portlet= Irm::FunctionGroup.new(:zone_code=>'PORTLET',:code=>'PORTAL_PORTLET',:controller=>'irm/home',:action=>'index',:not_auto_mult=>true)
     irm_portal_portlet.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Portlets',:description=>'全部Portlet')
     irm_portal_portlet.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portlets',:description=>'all portlets')
     irm_portal_portlet.save

     irm_portlet= Irm::Function.new(:function_group_code=>'PORTLET',:code=>'PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
     irm_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'管理Portlet',:description=>'管理Portlet')
     irm_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portlet ',:description=>'Portlet ')
     irm_portlet.save
     irm_bulletin_portlet= Irm::Function.new(:function_group_code=>'PORTAL_PORTLET',:code=>'BULLETIN_PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
     irm_bulletin_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看公告Portlet',:description=>'查看公告Portlet')
     irm_bulletin_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Portlet of Bulletins',:description=>'View Portlet of Bulletins')
     irm_bulletin_portlet.save
     irm_entry_header_portlet= Irm::Function.new(:function_group_code=>'PORTAL_PORTLET',:code=>'ENTRY_HEADER_PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
     irm_entry_header_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'查看我的知识库Portlet',:description=>'查看我的知识库Portlet')
     irm_entry_header_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Portlet of My Skm Entries',:description=>'View Portlet of My Skm Entries')
     irm_entry_header_portlet.save
     irm_todo_task_portlet= Irm::Function.new(:function_group_code=>'PORTAL_PORTLET',:code=>'TODO_TASK_PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
     irm_todo_task_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'待办事项Portlet',:description=>'待办事项Portlet')
     irm_todo_task_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Portlet of My To Do Tasks',:description=>'View Portlet of My To Do Tasks')
     irm_todo_task_portlet.save
     irm_report_portlet= Irm::Function.new(:function_group_code=>'PORTAL_PORTLET',:code=>'REPORT_PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
     irm_report_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表Portlet',:description=>'报表Portlet')
     irm_report_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Portlet of Report',:description=>'View Portlet of Report')
     irm_report_portlet.save
     irm_portal_layout= Irm::Function.new(:function_group_code=>'PORTAL_LAYOUT',:code=>'PORTAL_LAYOUT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
     irm_portal_layout.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Portal布局',:description=>'查看，提交，编辑，操作Portal布局')
     irm_portal_layout.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portal Layout',:description=>'Submit,edit change Portal Layout')
     irm_portal_layout.save
     portal= Irm::Menu.new(:code=>'PORTAL',:not_auto_mult=>true)
     portal.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Portal',:description=>'Portal门户')
     portal.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Portal',:description=>'Portal')
     portal.save
     menu_entiry_114= Irm::MenuEntry.new(:menu_code=>'GLOBAL_CREATE',:sub_menu_code=>'PORTAL',:sub_function_group_code=>nil,:display_sequence=>70)
     menu_entiry_114.save
     menu_entiry_115= Irm::MenuEntry.new(:menu_code=>'PORTAL',:sub_menu_code=>nil,:sub_function_group_code=>'PORTLET',:display_sequence=>10)
     menu_entiry_115.save
     menu_entiry_116= Irm::MenuEntry.new(:menu_code=>'PORTAL',:sub_menu_code=>nil,:sub_function_group_code=>'PORTAL_LAYOUT',:display_sequence=>20)
     menu_entiry_116.save
  end

  def down
  end
end
