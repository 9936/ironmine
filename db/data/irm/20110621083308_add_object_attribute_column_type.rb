# -*- coding:utf-8 -*-
class AddObjectAttributeColumnType < ActiveRecord::Migration
  def self.up
    bo_attribute_field_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'BO_ATTRIBUTE_FIELD_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_field_type.lookup_types_tls.build(:lookup_type_id=>bo_attribute_field_type.id,:meaning=>'业务对像属性字段类型',:description=>'业务对像属性字段类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_type.lookup_types_tls.build(:lookup_type_id=>bo_attribute_field_type.id,:meaning=>'Business Object Field Type',:description=>'Business Object Field Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_type.save

    bo_attribute_typemaster_detail_column= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_TYPE',:lookup_code=>'MASTER_DETAIL_COLUMN',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_typemaster_detail_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typemaster_detail_column.id,:meaning=>'master-detail关系',:description=>'master-detail关系',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typemaster_detail_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typemaster_detail_column.id,:meaning=>'Master Detail Relationship',:description=>'Master Detail Relationship',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typemaster_detail_column.save
    bo_attribute_typelookup_column= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_TYPE',:lookup_code=>'LOOKUP_COLUMN',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_typelookup_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typelookup_column.id,:meaning=>'lookup关系',:description=>'lookup关系',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typelookup_column.lookup_values_tls.build(:lookup_value_id=>bo_attribute_typelookup_column.id,:meaning=>'Lookpup Relationship',:description=>'Lookpup Relationship',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_typelookup_column.save
    bo_attribute_field_typestandard_field= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_FIELD_TYPE',:lookup_code=>'STANDARD_FIELD',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_field_typestandard_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typestandard_field.id,:meaning=>'标准字段',:description=>'标准字段',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typestandard_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typestandard_field.id,:meaning=>'Standard Field',:description=>'Standard Field',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typestandard_field.save
    bo_attribute_field_typeobject_name_field= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_FIELD_TYPE',:lookup_code=>'OBJECT_NAME_FIELD',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_field_typeobject_name_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typeobject_name_field.id,:meaning=>'对像名称字段',:description=>'对像名称字段',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typeobject_name_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typeobject_name_field.id,:meaning=>'Object Name Field',:description=>'Object Name Field',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typeobject_name_field.save
    bo_attribute_field_typecustomed_field= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_FIELD_TYPE',:lookup_code=>'CUSTOMED_FIELD',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_field_typecustomed_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typecustomed_field.id,:meaning=>'自定义字段',:description=>'自定义字段',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typecustomed_field.lookup_values_tls.build(:lookup_value_id=>bo_attribute_field_typecustomed_field.id,:meaning=>'Custom Field',:description=>'Custom Field',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_field_typecustomed_field.save
  end

  def self.down
  end
end
