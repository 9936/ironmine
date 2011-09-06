# -*- coding: utf-8 -*-
class AddIncidentRequestAssignMe < ActiveRecord::Migration
  def self.up
    icm_incident_request_assign_me= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'INCIDENT_REQUEST_ASSIGN_ME',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_incident_request_assign_me.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'领取',:description=>'领取')
    icm_incident_request_assign_me.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Request',:description=>'Request')
    icm_incident_request_assign_me.save
    icm_incident_request_edit_status= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'INCIDENT_REQUEST_EDIT_STATUS',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_incident_request_edit_status.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'修改状态',:description=>'修改状态')
    icm_incident_request_edit_status.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Status',:description=>'Edit Status')
    icm_incident_request_edit_status.save
  end

  def self.down
  end
end
