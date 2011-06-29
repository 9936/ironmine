# -*- coding: utf-8 -*-
class AddDelayedJobLogMenuData < ActiveRecord::Migration
  def self.up
    irm_delayed_job_logs= Irm::Function.new(:group_code=>'IRM_MONITOR',:function_code=>'DELAYED_JOB_LOGS',:default_flag=>'Y',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    irm_delayed_job_logs.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Delayed Job运行记录',:description=>'Delayed Job运行记录')
    irm_delayed_job_logs.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Delayed Job Logs',:description=>'Delayed Job Logs')
    irm_delayed_job_logs.save

    irm_delayed_job_log= Irm::Menu.new(:menu_code=>'DELAYED_JOB_LOG',:leaf_flag=>'Y',:not_auto_mult=>true)
    irm_delayed_job_log.menus_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Delayed Job运行记录',:description=>'Delayed Job运行记录')
    irm_delayed_job_log.menus_tls.build(:language=>'en',:source_lang=>'en',:name=>'Delayed Job Logs',:description=>'Delayed Job Logs')
    irm_delayed_job_log.save

    irm_menu_entiry_131= Irm::MenuEntry.new(:menu_code=>'MONITOR',:sub_menu_code=>'DELAYED_JOB_LOG',:page_controller=>nil,:display_sequence=>30,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_131.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Delayed Job运行记录',:description=>'Delayed Job运行记录')
    irm_menu_entiry_131.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Delayed Job Logs',:description=>'Delayed Job Logs')
    irm_menu_entiry_131.save
    irm_menu_entiry_132= Irm::MenuEntry.new(:menu_code=>'DELAYED_JOB_LOG',:sub_menu_code=>nil,:page_controller=>'irm/delayed_jobs',:display_sequence=>30,:display_flag=>'Y',:not_auto_mult=>true)
    irm_menu_entiry_132.menu_entries_tls.build(:language=>'zh',:source_lang=>'en',:name=>'Delayed Job运行记录',:description=>'Delayed Job运行记录')
    irm_menu_entiry_132.menu_entries_tls.build(:language=>'en',:source_lang=>'en',:name=>'Delayed Job Logs',:description=>'Delayed Job Logs')
    irm_menu_entiry_132.save
  end

  def self.down
  end
end
