# -*- coding: utf-8 -*-
class AddMoreIcmFunctions < ActiveRecord::Migration
  def up
    icm_edit_workload= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'EDIT_WORKLOAD',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_edit_workload.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'登记工时',:description=>'登记工时')
    icm_edit_workload.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Workload',:description=>'Edit Workload')
    icm_edit_workload.save

    icm_remove_any_journal= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'REMOVE_ANY_JOURNAL',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_remove_any_journal.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'删除任意回复',:description=>'删除任意回复')
    icm_remove_any_journal.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Remove Any Journal',:description=>'Remove Any Journal')
    icm_remove_any_journal.save

    icm_remove_self_journal= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'REMOVE_SELF_JOURNAL',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_remove_self_journal.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'删除自己的回复',:description=>'删除自己的回复')
    icm_remove_self_journal.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Remove Self Journal',:description=>'Remove Self Journal')
    icm_remove_self_journal.save

    icm_remove_attachment= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'REMOVE_ATTACHMENT',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_remove_attachment.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'删除附件',:description=>'删除附件')
    icm_remove_attachment.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Remove Attachment',:description=>'Remove Attachment')
    icm_remove_attachment.save
    
    icm_edit_incident_request_priority= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'EDIT_INCIDENT_REQUEST_PRIORITY',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_edit_incident_request_priority.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'更改优先级',:description=>'单独更改事故单优先级的权限')
    icm_edit_incident_request_priority.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Edit Priority',:description=>'Edit Priority')
    icm_edit_incident_request_priority.save

    icm_cancel_request= Irm::Function.new(:function_group_code=>'INCIDENT_REQUEST',:code=>'CANCEL_REQUEST',:default_flag=>'N',:login_flag => 'N', :public_flag=>'N',:not_auto_mult=>true)
    icm_cancel_request.functions_tls.build(:language=>'zh',:source_lang=>'en',:name=>'取消事故单',:description=>'取消事故单')
    icm_cancel_request.functions_tls.build(:language=>'en',:source_lang=>'en',:name=>'Cancel Request',:description=>'Cancel Request')
    icm_cancel_request.save
  end

  def down
  end
end
