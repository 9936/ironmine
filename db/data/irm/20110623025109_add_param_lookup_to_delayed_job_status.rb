# -*- coding: utf-8 -*-
class AddParamLookupToDelayedJobStatus < ActiveRecord::Migration
  def self.up
    irm_delayed_job_statusparam= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'PARAM',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusparam.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusparam.id,:meaning=>'参数',:description=>'参数',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusparam.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusparam.id,:meaning=>'Parameters',:description=>'Parameters',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusparam.save
  end

  def self.down

  end
end
