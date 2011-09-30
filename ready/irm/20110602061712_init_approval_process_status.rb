# -*- coding: utf-8 -*-
class InitApprovalProcessStatus < ActiveRecord::Migration
  def self.up
    wf_process_instance_statussubmitted= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_INSTANCE_STATUS',:lookup_code=>'SUBMITTED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_instance_statussubmitted.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statussubmitted.id,:meaning=>'提交待审批',:description=>'提交待审批',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statussubmitted.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statussubmitted.id,:meaning=>'Submitted',:description=>'Submitted',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statussubmitted.save
    wf_process_instance_statusapproved= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_INSTANCE_STATUS',:lookup_code=>'APPROVED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_instance_statusapproved.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusapproved.id,:meaning=>'审批通过',:description=>'审批通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusapproved.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusapproved.id,:meaning=>'Approved',:description=>'Approved',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusapproved.save
    wf_process_instance_statusreject= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_INSTANCE_STATUS',:lookup_code=>'REJECT',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_instance_statusreject.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusreject.id,:meaning=>'审批拒绝',:description=>'审批拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusreject.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusreject.id,:meaning=>'Reject',:description=>'Reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusreject.save
    wf_process_instance_statusrecall= Irm::LookupValue.new(:lookup_type=>'WF_PROCESS_INSTANCE_STATUS',:lookup_code=>'RECALL',:start_date_active=>'2011-05-13',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_process_instance_statusrecall.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusrecall.id,:meaning=>'已回调',:description=>'已回调',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusrecall.lookup_values_tls.build(:lookup_value_id=>wf_process_instance_statusrecall.id,:meaning=>'Recall',:description=>'Recall',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_process_instance_statusrecall.save
    wf_step_instance_statuspending= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'PENDING',:start_date_active=>'2011-05-14',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statuspending.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statuspending.id,:meaning=>'审批中',:description=>'审批中',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statuspending.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statuspending.id,:meaning=>'Pending',:description=>'Pending',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statuspending.save
    wf_step_instance_statusapproved= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'APPROVED',:start_date_active=>'2011-05-15',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusapproved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusapproved.id,:meaning=>'审批通过',:description=>'审批通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusapproved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusapproved.id,:meaning=>'Approved',:description=>'Approved',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusapproved.save
    wf_step_instance_statusreject= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'REJECT',:start_date_active=>'2011-05-16',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusreject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusreject.id,:meaning=>'审批拒绝',:description=>'审批拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusreject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusreject.id,:meaning=>'Reject',:description=>'Reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusreject.save
    wf_step_instance_statusreassign= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'REASSIGN',:start_date_active=>'2011-05-17',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusreassign.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusreassign.id,:meaning=>'转交',:description=>'转交',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusreassign.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusreassign.id,:meaning=>'Reassign',:description=>'Reassign',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusreassign.save
    wf_step_instance_statusmultiple_approved= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'MULTIPLE_APPROVED',:start_date_active=>'2011-05-18',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusmultiple_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusmultiple_approved.id,:meaning=>'自动通过',:description=>'自动通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusmultiple_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusmultiple_approved.id,:meaning=>'Auto approved',:description=>'Auto approved',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusmultiple_approved.save
    wf_step_instance_statusmultiple_reject= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'MULTIPLE_REJECT',:start_date_active=>'2011-05-19',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusmultiple_reject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusmultiple_reject.id,:meaning=>'自动拒绝',:description=>'自动拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusmultiple_reject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusmultiple_reject.id,:meaning=>'Auto reject',:description=>'Auto reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusmultiple_reject.save
    wf_step_instance_statusfilter_auto_approved= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'FILTER_AUTO_APPROVED',:start_date_active=>'2011-05-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusfilter_auto_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_approved.id,:meaning=>'不满足条件通过',:description=>'不满足条件通过',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_approved.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_approved.id,:meaning=>'Approved(Filter)',:description=>'Approved(Filter)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_approved.save
    wf_step_instance_statusfilter_auto_reject= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'FILTER_AUTO_REJECT',:start_date_active=>'2011-05-21',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusfilter_auto_reject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_reject.id,:meaning=>'不满足条件拒绝',:description=>'不满足条件拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_reject.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_reject.id,:meaning=>'Reject(Filter)',:description=>'Reject(Filter)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_reject.save
    wf_step_instance_statusfilter_auto_next_step= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'FILTER_AUTO_NEXT_STEP',:start_date_active=>'2011-05-22',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusfilter_auto_next_step.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_next_step.id,:meaning=>'不满足条件下一步',:description=>'不满足条件下一步',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_next_step.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusfilter_auto_next_step.id,:meaning=>'Next step(Filter)',:description=>'Next step(Filter)',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusfilter_auto_next_step.save
    wf_step_instance_statusrecall= Irm::LookupValue.new(:lookup_type=>'WF_STEP_INSTANCE_STATUS',:lookup_code=>'RECALL',:start_date_active=>'2011-05-13',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_instance_statusrecall.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusrecall.id,:meaning=>'已回调',:description=>'已回调',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusrecall.lookup_values_tls.build(:lookup_value_id=>wf_step_instance_statusrecall.id,:meaning=>'Recall',:description=>'Recall',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_instance_statusrecall.save
  end

  def self.down
  end
end
