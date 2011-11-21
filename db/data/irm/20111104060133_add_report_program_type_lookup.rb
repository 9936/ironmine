# -*- coding:utf-8 -*-
class AddReportProgramTypeLookup < ActiveRecord::Migration
  def up
    irm_report_program_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_REPORT_PROGRAM_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_program_type.lookup_types_tls.build(:lookup_type_id=>irm_report_program_type.id,:meaning=>'报表类型',:description=>'报表类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_program_type.lookup_types_tls.build(:lookup_type_id=>irm_report_program_type.id,:meaning=>'Report Program Type',:description=>'Report Program Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_program_type.save

    irm_report_program_typeprogram= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_PROGRAM_TYPE',:lookup_code=>'PROGRAM',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_program_typeprogram.lookup_values_tls.build(:lookup_value_id=>irm_report_program_typeprogram.id,:meaning=>'编程报表',:description=>'编程报表',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_program_typeprogram.lookup_values_tls.build(:lookup_value_id=>irm_report_program_typeprogram.id,:meaning=>'Program Report',:description=>'Program Report',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_program_typeprogram.save
    irm_report_program_typecustom= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_PROGRAM_TYPE',:lookup_code=>'CUSTOM',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_program_typecustom.lookup_values_tls.build(:lookup_value_id=>irm_report_program_typecustom.id,:meaning=>'自定义报表',:description=>'自定义报表',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_program_typecustom.lookup_values_tls.build(:lookup_value_id=>irm_report_program_typecustom.id,:meaning=>'Csutomize Report',:description=>'Program Report',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_program_typecustom.save
  end

  def down
  end
end
