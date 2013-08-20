# -*- coding: utf-8 -*-
class AddSexOptions < ActiveRecord::Migration
  def up
    sug_sex =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'SUG_SEX',:status_code=>'ENABLED',:not_auto_mult=>true)
    sug_sex.lookup_types_tls.build(:lookup_type_id=> sug_sex.id,:meaning=>'性别',:description=>'性别',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    sug_sex.lookup_types_tls.build(:lookup_type_id=> sug_sex.id,:meaning=>'Sex',:description=>'Sex',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    sug_sex.save

    sug_sex_male = Irm::LookupValue.new(:lookup_type=>'SUG_SEX',:lookup_code=>'MALE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    sug_sex_male.lookup_values_tls.build(:lookup_value_id=> sug_sex_male.id,:meaning=>'男',:description=>'男',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    sug_sex_male.lookup_values_tls.build(:lookup_value_id=> sug_sex_male.id,:meaning=>'Male',:description=>'Male',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    sug_sex_male.save

    sug_sex_female = Irm::LookupValue.new(:lookup_type=>'SUG_SEX',:lookup_code=>'FEMALE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    sug_sex_female.lookup_values_tls.build(:lookup_value_id=> sug_sex_female.id,:meaning=>'女',:description=>'女',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    sug_sex_female.lookup_values_tls.build(:lookup_value_id=> sug_sex_female.id,:meaning=>'Female',:description=>'Female',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    sug_sex_female.save
  end

end
