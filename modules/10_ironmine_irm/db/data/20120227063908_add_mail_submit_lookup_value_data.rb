# -*- coding: utf-8 -*-
class AddMailSubmitLookupValueData < ActiveRecord::Migration
  def up
    icm_request_report_sourcemail_submit= Irm::LookupValue.new(:lookup_type=>'ICM_REQUEST_REPORT_SOURCE',:lookup_code=>'MAIL_SUBMIT',:start_date_active=>'2010-12-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_request_report_sourcemail_submit.lookup_values_tls.build(:lookup_value_id=>icm_request_report_sourcemail_submit.id,:meaning=>'邮件提交',:description=>'邮件提交',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_report_sourcemail_submit.lookup_values_tls.build(:lookup_value_id=>icm_request_report_sourcemail_submit.id,:meaning=>'Mail submit',:description=>'Mail submit',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_request_report_sourcemail_submit.save    
  end

  def down
  end
end
