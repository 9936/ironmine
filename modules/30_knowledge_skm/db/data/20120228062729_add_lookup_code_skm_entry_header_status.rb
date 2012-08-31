# -*- coding: utf-8 -*-
class AddLookupCodeSkmEntryHeaderStatus < ActiveRecord::Migration
  def up
    skm_entry_status=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SKM_ENTRY_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_entry_status.lookup_types_tls.build(:lookup_type_id=>skm_entry_status.id,:meaning=>'知识状态',:description=>'知识状态',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_status.lookup_types_tls.build(:lookup_type_id=>skm_entry_status.id,:meaning=>'Knowledge Status',:description=>'Knowledge Status',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_status.save

    skm_entry_statusdraft= Irm::LookupValue.new(:lookup_type=>'SKM_ENTRY_STATUS',:lookup_code=>'DRAFT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_entry_statusdraft.lookup_values_tls.build(:lookup_value_id=>skm_entry_statusdraft.id,:meaning=>'草稿',:description=>'草稿',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_statusdraft.lookup_values_tls.build(:lookup_value_id=>skm_entry_statusdraft.id,:meaning=>'Draft',:description=>'Draft',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_statusdraft.save
    skm_entry_statuspublished= Irm::LookupValue.new(:lookup_type=>'SKM_ENTRY_STATUS',:lookup_code=>'PUBLISHED',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_entry_statuspublished.lookup_values_tls.build(:lookup_value_id=>skm_entry_statuspublished.id,:meaning=>'发布',:description=>'发布',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_statuspublished.lookup_values_tls.build(:lookup_value_id=>skm_entry_statuspublished.id,:meaning=>'Published',:description=>'Published',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_statuspublished.save
    skm_entry_statuswait_approve= Irm::LookupValue.new(:lookup_type=>'SKM_ENTRY_STATUS',:lookup_code=>'WAIT_APPROVE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_entry_statuswait_approve.lookup_values_tls.build(:lookup_value_id=>skm_entry_statuswait_approve.id,:meaning=>'等待审核',:description=>'等待审核',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_statuswait_approve.lookup_values_tls.build(:lookup_value_id=>skm_entry_statuswait_approve.id,:meaning=>'Auditing',:description=>'Auditing',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_statuswait_approve.save
    skm_entry_statusapprove_deny= Irm::LookupValue.new(:lookup_type=>'SKM_ENTRY_STATUS',:lookup_code=>'APPROVE_DENY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    skm_entry_statusapprove_deny.lookup_values_tls.build(:lookup_value_id=>skm_entry_statusapprove_deny.id,:meaning=>'审核拒绝',:description=>'审核拒绝',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_statusapprove_deny.lookup_values_tls.build(:lookup_value_id=>skm_entry_statusapprove_deny.id,:meaning=>'Reject',:description=>'Reject',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    skm_entry_statusapprove_deny.save


  end

  def down
  end
end
