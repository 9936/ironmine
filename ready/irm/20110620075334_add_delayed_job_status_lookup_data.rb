# -*- coding: utf-8 -*-
class AddDelayedJobStatusLookupData < ActiveRecord::Migration
  def self.up
    irm_delayed_job_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_DELAYED_JOB_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_status.lookup_types_tls.build(:lookup_type_id=>irm_delayed_job_status.id,:meaning=>'Delayed Job状态',:description=>'Delayed Job状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_status.lookup_types_tls.build(:lookup_type_id=>irm_delayed_job_status.id,:meaning=>'Delayed Job Status',:description=>'Delayed Job Status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_status.save
    
    irm_delayed_job_statusenqueue= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'ENQUEUE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusenqueue.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusenqueue.id,:meaning=>'已进入队列',:description=>'已进入队列',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusenqueue.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusenqueue.id,:meaning=>'Enqueued',:description=>'Enqueued',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusenqueue.save
    irm_delayed_job_statusrun= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'RUN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusrun.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusrun.id,:meaning=>'执行中',:description=>'执行中',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusrun.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusrun.id,:meaning=>'Running',:description=>'Running',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusrun.save
    irm_delayed_job_statuslock= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'LOCK',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statuslock.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuslock.id,:meaning=>'锁定',:description=>'锁定',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuslock.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuslock.id,:meaning=>'Lock',:description=>'Lock',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuslock.save
    irm_delayed_job_statusunlock= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'UNLOCK',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusunlock.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusunlock.id,:meaning=>'解除锁定',:description=>'解除锁定',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusunlock.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusunlock.id,:meaning=>'Unlock',:description=>'Unlock',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusunlock.save
    irm_delayed_job_statuscomplete= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'COMPLETE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statuscomplete.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuscomplete.id,:meaning=>'完成',:description=>'完成',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuscomplete.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuscomplete.id,:meaning=>'Completed',:description=>'Completed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuscomplete.save
    irm_delayed_job_statusdestroy= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'DESTROY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statusdestroy.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusdestroy.id,:meaning=>'完成并移除任务',:description=>'完成并移除任务',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusdestroy.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statusdestroy.id,:meaning=>'Completed & Removed',:description=>'Completed & Removed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statusdestroy.save
    irm_delayed_job_statuserror= Irm::LookupValue.new(:lookup_type=>'IRM_DELAYED_JOB_STATUS',:lookup_code=>'ERROR',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_delayed_job_statuserror.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuserror.id,:meaning=>'错误',:description=>'错误',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuserror.lookup_values_tls.build(:lookup_value_id=>irm_delayed_job_statuserror.id,:meaning=>'Error',:description=>'Error',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_delayed_job_statuserror.save
  end

  def self.down
  end
end
