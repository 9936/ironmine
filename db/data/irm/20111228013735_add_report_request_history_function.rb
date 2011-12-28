# -*- coding: utf-8 -*-
class AddReportRequestHistoryFunction < ActiveRecord::Migration
  def up
    irm_report_request_history= Irm::FunctionGroup.new(:zone_code=>'IRM_REPORT',:code=>'REPORT_REQUEST_HISTORY',:controller=>'irm/report_request_histories',:action=>'index',:not_auto_mult=>true)
    irm_report_request_history.function_groups_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表运行历史',:description=>'查看报表运行的明细历史记录')
    irm_report_request_history.function_groups_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Request History',:description=>'Report Request History')
    irm_report_request_history.save
    chm_report_request_history= Irm::Function.new(:function_group_code=>'REPORT_REQUEST_HISTORY',:code=>'REPORT_REQUEST_HISTORY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    chm_report_request_history.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'报表运行历史',:description=>'查看报表运行的明细历史记录')
    chm_report_request_history.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Report Request History',:description=>'Report Request History')
    chm_report_request_history.save
    menu_entiry_112= Irm::MenuEntry.new(:menu_code=>'MONITOR_MANAGEMENT',:sub_menu_code=>nil,:sub_function_group_code=>'REPORT_REQUEST_HISTORY',:display_sequence=>50)
    menu_entiry_112.save
  end

  def down
  end
end
