# encoding: utf-8
class InitNdmLookup < ActiveRecord::Migration
  def up
    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'NDM_PRIORITY',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Priority',:description=>'Priority',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Priority',:description=>'Priority',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'NDM_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Type',:description=>'Type',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Type',:description=>'Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'NDM_MODULE',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Module',:description=>'Module',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Module',:description=>'Module',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'NDM_METHOD',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Method',:description=>'Method',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Method',:description=>'Method',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save

    lt =Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'NDM_DIFFICULTY',:status_code=>'ENABLED',:not_auto_mult=>true)
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Difficulty',:description=>'Difficulty',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    lt.lookup_types_tls.build(:lookup_type_id=> lt.id,:meaning=>'Difficulty',:description=>'Difficulty',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    lt.save
  end

  def down
  end
end
