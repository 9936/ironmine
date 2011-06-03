# -*- coding: utf-8 -*-
class AddNextStepLookup < ActiveRecord::Migration
  def self.up
    wf_step_evaluate_resutlnext_step= Irm::LookupValue.new(:lookup_type=>'WF_STEP_EVALUATE_RESUTL',:lookup_code=>'NEXT_STEP',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    wf_step_evaluate_resutlnext_step.lookup_values_tls.build(:lookup_value_id=>wf_step_evaluate_resutlnext_step.id,:meaning=>'进入下一步审批',:description=>'进入下一步审批',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutlnext_step.lookup_values_tls.build(:lookup_value_id=>wf_step_evaluate_resutlnext_step.id,:meaning=>'Next Step',:description=>'Next Step',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    wf_step_evaluate_resutlnext_step.save
  end

  def self.down
  end
end
