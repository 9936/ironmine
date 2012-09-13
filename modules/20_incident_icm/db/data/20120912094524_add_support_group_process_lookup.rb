# -*- coding: utf-8 -*-
class AddSupportGroupProcessLookup < ActiveRecord::Migration
  def up
    icm_assign_process_type_assign_person = Irm::LookupValue.new(:lookup_type=>'ICM_ASSIGN_PROCESS_TYPE',:lookup_code=>'ASSIGN_PERSON',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_assign_process_type_assign_person.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_type_assign_person.id,:meaning=>'指定处理人',:description=>'指定处理人',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_type_assign_person.lookup_values_tls.build(:lookup_value_id=>icm_assign_process_type_assign_person.id,:meaning=>'Choose Person',:description=>'Choose Person',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_assign_process_type_assign_person.save
  end

  def down
    icm_assign_process_type_assign_person = Irm::LookupValue.where(:lookup_type=>'ICM_ASSIGN_PROCESS_TYPE',:lookup_code=>'ASSIGN_PERSON',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true).first
    icm_assign_process_type_assign_person.destroy
  end
end
