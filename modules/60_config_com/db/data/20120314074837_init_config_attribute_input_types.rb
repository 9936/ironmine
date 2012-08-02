# -*- coding: utf-8 -*-
class InitConfigAttributeInputTypes < ActiveRecord::Migration
  def up
    com_config_attribute_inpuy_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'CONFIG_ATTRIBUTE_INPUT_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    com_config_attribute_inpuy_type.lookup_types_tls.build(:lookup_type_id=>com_config_attribute_inpuy_type.id,:meaning=>'配置属性输入类型',:description=>'配置属性输入类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_type.lookup_types_tls.build(:lookup_type_id=>com_config_attribute_inpuy_type.id,:meaning=>'Config Attribute Input Type',:description=>'Config Attribute Input Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_type.save

    com_config_attribute_inpuy_typetext= Irm::LookupValue.new(:lookup_type=>'CONFIG_ATTRIBUTE_INPUT_TYPE',:lookup_code=>'TEXT',:start_date_active=>'2012-03-14',:status_code=>'ENABLED',:not_auto_mult=>true)
    com_config_attribute_inpuy_typetext.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typetext.id,:meaning=>'文本',:description=>'文本',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typetext.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typetext.id,:meaning=>'Text',:description=>'Text',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typetext.save

    com_config_attribute_inpuy_typelong_text= Irm::LookupValue.new(:lookup_type=>'CONFIG_ATTRIBUTE_INPUT_TYPE',:lookup_code=>'LONG_TEXT',:start_date_active=>'2012-03-14',:status_code=>'ENABLED',:not_auto_mult=>true)
    com_config_attribute_inpuy_typelong_text.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typelong_text.id,:meaning=>'长文本',:description=>'长文本',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typelong_text.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typelong_text.id,:meaning=>'Long Text',:description=>'Long Text',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typelong_text.save

    com_config_attribute_inpuy_typeselect= Irm::LookupValue.new(:lookup_type=>'CONFIG_ATTRIBUTE_INPUT_TYPE',:lookup_code=>'SELECT',:start_date_active=>'2012-03-14',:status_code=>'ENABLED',:not_auto_mult=>true)
    com_config_attribute_inpuy_typeselect.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typeselect.id,:meaning=>'下拉选择',:description=>'下拉选择',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typeselect.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typeselect.id,:meaning=>'Select',:description=>'Select',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typeselect.save

    com_config_attribute_inpuy_typedate= Irm::LookupValue.new(:lookup_type=>'CCONFIG_ATTRIBUTE_INPUT_TYPE',:lookup_code=>'DATE',:start_date_active=>'2012-03-14',:status_code=>'ENABLED',:not_auto_mult=>true)
    com_config_attribute_inpuy_typedate.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typedate.id,:meaning=>'日期',:description=>'日期',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typedate.lookup_values_tls.build(:lookup_value_id=>com_config_attribute_inpuy_typedate.id,:meaning=>'Date',:description=>'Date',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    com_config_attribute_inpuy_typedate.save


  end

  def down
  end
end
