# -*- coding: utf-8 -*-
class AddIcmAssignProcessTypeNeverAssignLookup < ActiveRecord::Migration
  def self.up
    icm_assign_process_typenever_assign= Irm::LookupValue.new(:lookup_type=>'ICM_ASSIGN_PROCESS_TYPE',:lookup_code=>'NEVER_ASSIGN',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_assign_process_typenever_assign.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_typenever_assign.id,:meaning=>'不分配',:description=>'不分配',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_typenever_assign.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_typenever_assign.id,:meaning=>'Do not Assign',:description=>'Do not Assign',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_typenever_assign.save
  end

  def self.down
  end
end
