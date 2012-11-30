# -*- coding: utf-8 -*-
class AddBoAttributeCategoryDate < ActiveRecord::Migration
  def up
    bo_attribute_categorydate= Irm::LookupValue.new(:lookup_type=>'BO_ATTRIBUTE_CATEGORY',:lookup_code=>'DATE',:start_date_active=>'2011-02-20',:status_code=>'ENABLED',:not_auto_mult=>true)
    bo_attribute_categorydate.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorydate.id,:meaning=>'日期',:description=>'允许用户输入日期或从弹出式日历中选择日期。',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorydate.lookup_values_tls.build(:lookup_value_id=>bo_attribute_categorydate.id,:meaning=>'Date',:description=>'Allows users to enter a date , or pick a date from a popup calendar.',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    bo_attribute_categorydate.save
  end

  def down
  end
end
