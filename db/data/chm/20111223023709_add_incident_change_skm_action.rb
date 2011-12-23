# -*- coding: utf-8 -*-
class AddIncidentChangeSkmAction < ActiveRecord::Migration
  def up
    icm_incident_request_eventcreate_rfc= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'CREATE_RFC',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventcreate_rfc.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcreate_rfc.id,:meaning=>'创建RFC(变更单)',:description=>'创建RFC(变更单)',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcreate_rfc.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcreate_rfc.id,:meaning=>'Create RFC',:description=>'Create RFC',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcreate_rfc.save
    icm_incident_request_eventcreate_skm= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'CREATE_SKM',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventcreate_skm.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcreate_skm.id,:meaning=>'创建知识',:description=>'创建知识',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcreate_skm.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcreate_skm.id,:meaning=>'Create Knowledge',:description=>'Create Knowledge',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcreate_skm.save
  end

  def down
  end
end
