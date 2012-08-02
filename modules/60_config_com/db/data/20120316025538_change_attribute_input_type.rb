# -*- coding: utf-8 -*-
class ChangeAttributeInputType < ActiveRecord::Migration
  def up
    com_config_attribute_inpuy_typedate= Irm::LookupValue.new(:lookup_type=>'CONFIG_ATTRIBUTE_INPUT_TYPE',:lookup_code=>'DATE',:start_date_active=>'2012-03-14',:status_code=>'ENABLED',:not_auto_mult=>true)
    com_config_attribute_inpuy_typedate.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typedate.id,:meaning=>'日期',:description=>'日期',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typedate.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typedate.id,:meaning=>'Date',:description=>'Date',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typedate.save
  end

  def down
  end
end
