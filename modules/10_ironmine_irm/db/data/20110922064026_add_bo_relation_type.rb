# -*- coding: utf-8 -*-
class AddBoRelationType < ActiveRecord::Migration
  def up
    bo_attribute_typemaster_detail_column= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_TYPE',:lookup_code=>'MASTER_DETAIL_COLUMN',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_typemaster_detail_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typemaster_detail_column.id,:meaning=>'Master-Detail关联列',:description=>'Master-Detail关联列',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typemaster_detail_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typemaster_detail_column.id,:meaning=>'Master Detail',:description=>'Master Detail',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typemaster_detail_column.save
    bo_attribute_typelookup_column= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_TYPE',:lookup_code=>'LOOKUP_COLUMN',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_typelookup_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typelookup_column.id,:meaning=>'Lookup关联列',:description=>'Lookup关联列',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typelookup_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typelookup_column.id,:meaning=>'Lookup',:description=>'Lookup',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typelookup_column.save
  end

  def down
  end
end
