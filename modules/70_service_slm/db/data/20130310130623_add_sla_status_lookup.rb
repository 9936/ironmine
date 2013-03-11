# -*- coding: utf-8 -*-
class AddSlaStatusLookup < ActiveRecord::Migration
  def up
    slm_sla_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SLM_SLA_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    slm_sla_status.lookup_types_tls.build(:meaning=>'服水平协议状态',:description=>'服水平协议状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status.lookup_types_tls.build(:meaning=>'Service level agreement status',:description=>'Service level agreement status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status.save

    slm_sla_status_start= Irm::LookupValue.new(:lookup_type=>'SLM_SLA_STATUS',:lookup_code=>'START',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    slm_sla_status_start.lookup_values_tls.build(:meaning=>'启动',:description=>'应用服务水平协议',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_start.lookup_values_tls.build(:meaning=>'Running',:description=>'Apply service level agreement',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_start.save

    slm_sla_status_pause= Irm::LookupValue.new(:lookup_type=>'SLM_SLA_STATUS',:lookup_code=>'PAUSE',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    slm_sla_status_pause.lookup_values_tls.build(:meaning=>'暂停',:description=>'暂停',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_pause.lookup_values_tls.build(:meaning=>'Pause',:description=>'Pause',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_pause.save

    slm_sla_status_stop= Irm::LookupValue.new(:lookup_type=>'SLM_SLA_STATUS',:lookup_code=>'STOP',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    slm_sla_status_stop.lookup_values_tls.build(:meaning=>'停止',:description=>'停止',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_stop.lookup_values_tls.build(:meaning=>'Stop',:description=>'Stop',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_stop.save

    slm_sla_status_cancel= Irm::LookupValue.new(:lookup_type=>'SLM_SLA_STATUS',:lookup_code=>'CANCEL',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    slm_sla_status_cancel.lookup_values_tls.build(:meaning=>'退出',:description=>'退出',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_cancel.lookup_values_tls.build(:meaning=>'Cancel',:description=>'Cancel',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_cancel.save

    slm_sla_status_timeout= Irm::LookupValue.new(:lookup_type=>'SLM_SLA_STATUS',:lookup_code=>'TIMEOUT',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    slm_sla_status_timeout.lookup_values_tls.build(:meaning=>'超时',:description=>'超时',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_timeout.lookup_values_tls.build(:meaning=>'Timeout',:description=>'Timeout',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    slm_sla_status_timeout.save
  end

  def down
    slm_sla_status=Irm::LookupType.where(:lookup_level=>'GLOBAL',:lookup_type=>'SLM_SLA_STATUS').first
    slm_sla_status.destroy if slm_sla_status.present?

  end
end
