class CreateMamStatusLookup < ActiveRecord::Migration
  def up

    remove_column :mam_masters, :master_status_id
    add_column :mam_masters, :master_status, :string, :limit => 30, :after => :opu_id

    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'MAM_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_STATUS',:description=>'MAM_STATUS',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'MAM_STATUS',:description=>'MAM_STATUS',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
    lv = Irm::LookupValue.new(:lookup_type=>'MAM_STATUS',:lookup_code=>'NEW',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'New',:description=>'New',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'MAM_STATUS',:lookup_code=>'PROCESSING',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Processing',:description=>'Processing',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Processing',:description=>'Processing',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'MAM_STATUS',:lookup_code=>'USERCONFIRMING',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'User Confirming',:description=>'User Confirming',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'User Confirming',:description=>'User Confirming',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'MAM_STATUS',:lookup_code=>'CLOSE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Close',:description=>'Close',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Close',:description=>'Close',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

  end

  def down
  end
end
