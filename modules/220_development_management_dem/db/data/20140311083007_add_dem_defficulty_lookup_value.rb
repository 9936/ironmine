# -*- coding: utf-8 -*-
class AddDemDefficultyLookupValue < ActiveRecord::Migration
  def up
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'DEM_DIFFICULTY',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Difficulty',:description=>'Difficulty',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Difficulty',:description=>'Difficulty',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_DIFFICULTY',:lookup_code=>'DEM_VERY_EASY',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Very Easy',:description=>'Very Easy',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Very Easy',:description=>'Very Easy',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_DIFFICULTY',:lookup_code=>'DEM_EASY',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Easy',:description=>'Easy',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Easy',:description=>'Easy',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_DIFFICULTY',:lookup_code=>'DEM_MEDIUM',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Medium',:description=>'Medium',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Medium',:description=>'Medium',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_DIFFICULTY',:lookup_code=>'DEM_COMPLEX',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Complex',:description=>'Complex',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Complex',:description=>'Complex',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    #Module
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'DEM_MODULE',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Module',:description=>'Module',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Module',:description=>'Module',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    #Develop Method
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'DEM_DEVELOP_METHOD',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Develop Method',:description=>'Develop Method',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Develop Method',:description=>'Develop Method',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    #Phase Status
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'DEM_PHASE_STATUS',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Phase Status',:description=>'Develop Method',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Phase Status',:description=>'Develop Method',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_PHASE_STATUS',:lookup_code=>'DEM_PHASE_OPEN',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Open',:description=>'Open',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Open',:description=>'Open',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_PHASE_STATUS',:lookup_code=>'DEM_PHASE_IP',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'In Progress',:description=>'In Progress',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'In Progress',:description=>'In Progress',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_PHASE_STATUS',:lookup_code=>'DEM_PHASE_COMPLETED',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Completed',:description=>'Completed',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Completed',:description=>'Completed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save

    lv = Irm::LookupValue.new(:lookup_type=>'DEM_PHASE_STATUS',:lookup_code=>'DEM_PHASE_DELAYED',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Delayed',:description=>'Delayed',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lv.lookup_values_tls.build(:lookup_value_id=> lv.id,:meaning=>'Delayed',:description=>'Delayed',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lv.save
  end

  def down
  end
end
