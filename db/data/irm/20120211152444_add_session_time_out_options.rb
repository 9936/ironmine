# -*- coding: utf-8 -*-
class AddSessionTimeOutOptions < ActiveRecord::Migration
  def up
    irm_session_time_out=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_SESSION_TIME_OUT',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_session_time_out.lookup_types_tls.build(:lookup_type_id=>irm_session_time_out.id,:meaning=>'会话超时时间',:description=>'会话超时时间',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out.lookup_types_tls.build(:lookup_type_id=>irm_session_time_out.id,:meaning=>'Session Time Out',:description=>'Session Time Out',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out.save

    irm_session_time_out15= Irm::LookupValue.new(:lookup_type=>'IRM_SESSION_TIME_OUT',:lookup_code=>'15',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_session_time_out15.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out15.id,:meaning=>'15 分钟',:description=>'15 分钟',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out15.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out15.id,:meaning=>'15 Minutes',:description=>'15 Minutes',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out15.save

    irm_session_time_out30= Irm::LookupValue.new(:lookup_type=>'IRM_SESSION_TIME_OUT',:lookup_code=>'30',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_session_time_out30.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out30.id,:meaning=>'30 分钟',:description=>'30 分钟',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out30.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out30.id,:meaning=>'30 Minutes',:description=>'30 Minutes',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out30.save

    irm_session_time_out60= Irm::LookupValue.new(:lookup_type=>'IRM_SESSION_TIME_OUT',:lookup_code=>'60',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_session_time_out60.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out60.id,:meaning=>'1 小时',:description=>'1 小时',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out60.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out60.id,:meaning=>'1 Hour',:description=>'1 Hour',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out60.save

    irm_session_time_out120= Irm::LookupValue.new(:lookup_type=>'IRM_SESSION_TIME_OUT',:lookup_code=>'120',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_session_time_out120.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out120.id,:meaning=>'2 小时',:description=>'2 小时',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out120.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out120.id,:meaning=>'2 Hours',:description=>'2 Hours',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out120.save

    irm_session_time_out240= Irm::LookupValue.new(:lookup_type=>'IRM_SESSION_TIME_OUT',:lookup_code=>'240',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_session_time_out240.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out240.id,:meaning=>'4 小时',:description=>'4 小时',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out240.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out240.id,:meaning=>'4 Hours',:description=>'4 Hours',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out240.save

    irm_session_time_out480= Irm::LookupValue.new(:lookup_type=>'IRM_SESSION_TIME_OUT',:lookup_code=>'480',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_session_time_out480.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out480.id,:meaning=>'8 小时',:description=>'8 小时',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out480.lookup_values_tls.build(:lookup_value_id=>irm_session_time_out480.id,:meaning=>'8 Hours',:description=>'8 Hours',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_session_time_out480.save
  end

  def down
  end
end
