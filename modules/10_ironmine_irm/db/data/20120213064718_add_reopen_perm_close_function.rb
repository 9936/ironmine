# -*- coding: utf-8 -*-
class AddReopenPermCloseFunction < ActiveRecord::Migration
  def up
    icm_permanent_close_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'PERMANENT_CLOSE_INCDNT_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_permanent_close_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'永久关闭',:description=>'永久关闭')
    icm_permanent_close_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Permanently Close',:description=>'Permanently Close')
    icm_permanent_close_incident_request.save
    icm_reopen_incident_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'REOPEN_INCIDENT_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_reopen_incident_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'重新打开',:description=>'重新打开')
    icm_reopen_incident_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Reopen',:description=>'Reopen')
    icm_reopen_incident_request.save

  end

  def down
  end
end
