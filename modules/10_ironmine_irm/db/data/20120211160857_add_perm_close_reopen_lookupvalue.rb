# -*- coding: utf-8 -*-
class AddPermCloseReopenLookupvalue < ActiveRecord::Migration
  def up
    icm_incident_request_eventpermanent_close= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'PERMANENT_CLOSE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventpermanent_close.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventpermanent_close.id,:meaning=>'永久关闭',:description=>'永久关闭',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventpermanent_close.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventpermanent_close.id,:meaning=>'Permanently Close',:description=>'Permanently Close',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventpermanent_close.save
    icm_incident_request_eventreopen= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'REOPEN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventreopen.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventreopen.id,:meaning=>'重新打开',:description=>'重新打开',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventreopen.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventreopen.id,:meaning=>'Reopen',:description=>'Reopen',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventreopen.save

  end

  def down
  end
end
