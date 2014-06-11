class AddBranchLookupNdm < ActiveRecord::Migration
  def up
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'NDM_BRANCH',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Branch',:description=>'Branch',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Branch',:description=>'Branch',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_BRANCH',:lookup_code=>'NDM_BRANCH_YI',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YI',:description=>'YI',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YI',:description=>'YI',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'NDM_BRANCH',:lookup_code=>'NDM_BRANCH_YEU',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YEU',:description=>'YEU',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'YEU',:description=>'YEU',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
  end

  def down
  end
end
