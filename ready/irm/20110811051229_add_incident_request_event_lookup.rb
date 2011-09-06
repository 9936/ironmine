# -*- coding: utf-8 -*-
class AddIncidentRequestEventLookup < ActiveRecord::Migration
  def self.up
    icm_incident_request_event=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_event.lookup_types_tls.build(:lookup_type_id=>icm_incident_request_event.id,:meaning=>'事故单处理过程中的事件',:description=>'事故单处理过程中的事件',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_event.lookup_types_tls.build(:lookup_type_id=>icm_incident_request_event.id,:meaning=>'Incident request Event',:description=>'Incident request Event',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_event.save

    icm_incident_request_eventcreate= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'CREATE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventcreate.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcreate.id,:meaning=>'新建',:description=>'新建',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcreate.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcreate.id,:meaning=>'Create',:description=>'Create',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcreate.save
    icm_incident_request_eventassign= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'ASSIGN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventassign.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventassign.id,:meaning=>'分配',:description=>'分配',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventassign.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventassign.id,:meaning=>'Assign',:description=>'Assign',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventassign.save
    icm_incident_request_eventsupporter_reply= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'SUPPORTER_REPLY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventsupporter_reply.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventsupporter_reply.id,:meaning=>'支持人员回复',:description=>'支持人员回复',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventsupporter_reply.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventsupporter_reply.id,:meaning=>'Reply by Supporter',:description=>'Reply by Supporter',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventsupporter_reply.save
    icm_incident_request_eventcustomer_reply= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'CUSTOMER_REPLY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventcustomer_reply.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcustomer_reply.id,:meaning=>'客户回复',:description=>'客户回复',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcustomer_reply.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventcustomer_reply.id,:meaning=>'Reply by Customer',:description=>'Reply by Customer',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventcustomer_reply.save
    icm_incident_request_eventpass= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'PASS',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventpass.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventpass.id,:meaning=>'转交',:description=>'转交',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventpass.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventpass.id,:meaning=>'Pass',:description=>'Pass',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventpass.save
    icm_incident_request_eventupgrade= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'UPGRADE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventupgrade.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventupgrade.id,:meaning=>'升级',:description=>'升级',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventupgrade.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventupgrade.id,:meaning=>'Upgrade',:description=>'Upgrade',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventupgrade.save
    icm_incident_request_eventclose= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'CLOSE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_eventclose.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventclose.id,:meaning=>'关闭',:description=>'关闭',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventclose.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventclose.id,:meaning=>'Close',:description=>'Close',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_eventclose.save
  end

  def self.down
  end
end
