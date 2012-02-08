# -*- coding: utf-8 -*-
class AddTaskAndReportPortletFunctionsGroup < ActiveRecord::Migration
  def up
    irm_todo_task_portlet= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'TODO_TASK_PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_todo_task_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'待办事项Portlet',:description=>'待办事项Portlet')
    irm_todo_task_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Portlet of My To Do Tasks',:description=>'View Portlet of My To Do Tasks')
    irm_todo_task_portlet.save

    irm_report_portlet= Irm::Function.new(:function_group_code=>'HOME_PAGE',:code=>'REPORT_PORTLET',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_report_portlet.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表Portlet',:description=>'报表Portlet')
    irm_report_portlet.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'View Portlet of Report',:description=>'View Portlet of Report')
    irm_report_portlet.save
  end

  def down
  end
end
