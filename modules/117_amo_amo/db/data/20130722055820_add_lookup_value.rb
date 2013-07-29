# -*- coding: utf-8 -*-
class AddLookupValue < ActiveRecord::Migration
  def change
    lookup_value = Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_EVENT', :lookup_code=>'RATING', :start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lookup_value.lookup_values_tls.build(:lookup_value_id=>lookup_value.id,:meaning=>'客户评价',:description=>'客户评价',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lookup_value.lookup_values_tls.build(:lookup_value_id=>lookup_value.id,:meaning=>'Customer Rating',:description=>'Customer Rating',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lookup_value.lookup_values_tls.build(:lookup_value_id=>lookup_value.id,:meaning=>'Customer Rating',:description=>'Customer Rating',:language=>'ja',:status_code=>'ENABLED',:source_lang=>'en')
    lookup_value.save
  end
end
