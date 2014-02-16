# encoding: utf-8
class InitDemLookup < ActiveRecord::Migration
  def up
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'DEM_PROJECT',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> sug_sex.id,:meaning=>'Project',:description=>'Project',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> sug_sex.id,:meaning=>'Project',:description=>'Project',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_PROJECT',:lookup_code=>'YEU_GAP',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YEU GAP',:description=>'YEU GAP',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YEU GAP',:description=>'YEU GAP',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_PROJECT',:lookup_code=>'YI_GAP',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YI GAP',:description=>'YI GAP',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YI GAP',:description=>'YI GAP',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_PROJECT',:lookup_code=>'ENHANCEMENT',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Enhancement',:description=>'Enhancement',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Enhancement',:description=>'Enhancement',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
  end

  def down
  end
end
