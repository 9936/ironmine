# -*- coding:utf-8 -*-
class AddIcmGroupAssignTypeLookupData < ActiveRecord::Migration
  def self.up
    icm_group_assign_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'ICM_GROUP_ASSIGN_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_group_assign_type.lookup_types_tls.build(:lookup_type_id=>icm_group_assign_type.id,:meaning=>'组指派维度',:description=>'组指派维度',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_group_assign_type.lookup_types_tls.build(:lookup_type_id=>icm_group_assign_type.id,:meaning=>'Group Assign Type',:description=>'Group Assign Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_group_assign_type.save
    icm_group_assign_typeorganizational= Irm::LookupValue.new(:lookup_type=>'ICM_GROUP_ASSIGN_TYPE',:lookup_code=>'ORGANIZATIONAL',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_group_assign_typeorganizational.lookup_values_tls.build(:lookup_value_id=>icm_group_assign_typeorganizational.id,:meaning=>'组织维度',:description=>'组织维度',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_group_assign_typeorganizational.lookup_values_tls.build(:lookup_value_id=>icm_group_assign_typeorganizational.id,:meaning=>'Organizational',:description=>'Organizational',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_group_assign_typeorganizational.save
    icm_group_assign_typeservice= Irm::LookupValue.new(:lookup_type=>'ICM_GROUP_ASSIGN_TYPE',:lookup_code=>'SERVICE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_group_assign_typeservice.lookup_values_tls.build(:lookup_value_id=>icm_group_assign_typeservice.id,:meaning=>'服务维度',:description=>'服务维度',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_group_assign_typeservice.lookup_values_tls.build(:lookup_value_id=>icm_group_assign_typeservice.id,:meaning=>'Service',:description=>'Service',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_group_assign_typeservice.save
  end

  def self.down
  end
end
