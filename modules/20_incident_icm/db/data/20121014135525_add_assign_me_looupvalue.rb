# -*- coding: utf-8 -*-
class AddAssignMeLooupvalue < ActiveRecord::Migration
  def up
    icm_incident_request_receive= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT',:lookup_code=>'ASSIGN_TO_ME',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_receive.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventpermanent_close.id,:meaning=>'领取',:description=>'领取',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_receive.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_eventpermanent_close.id,:meaning=>'Receive',:description=>'Receive',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_receive.save
  end

  def down
  end
end
