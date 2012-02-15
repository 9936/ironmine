# -*- coding: utf-8 -*-
class AddIrmDataAccessLevelLookup < ActiveRecord::Migration
  def up
    irm_data_access_level=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_DATA_ACCESS_LEVEL',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_data_access_level.lookup_types_tls.build(:lookup_type_id=>irm_data_access_level.id,:meaning=>'数据访问级别',:description=>'数据访问级别',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_data_access_level.lookup_types_tls.build(:lookup_type_id=>irm_data_access_level.id,:meaning=>'Data Access Level',:description=>'Data Access Level',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_data_access_level.save
    irm_data_access_levelprivate_personal= Irm::LookupValue.new(:lookup_type=>'IRM_DATA_ACCESS_LEVEL',:lookup_code=>'PRIVATE_PERSONAL',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_data_access_levelprivate_personal.lookup_values_tls.build(:lookup_value_id=>irm_data_access_levelprivate_personal.id,:meaning=>'私有数据',:description=>'私有数据',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_data_access_levelprivate_personal.lookup_values_tls.build(:lookup_value_id=>irm_data_access_levelprivate_personal.id,:meaning=>'Private Data',:description=>'Private Data',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_data_access_levelprivate_personal.save
    irm_data_access_levelpublic_read= Irm::LookupValue.new(:lookup_type=>'IRM_DATA_ACCESS_LEVEL',:lookup_code=>'PUBLIC_READ',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_data_access_levelpublic_read.lookup_values_tls.build(:lookup_value_id=>irm_data_access_levelpublic_read.id,:meaning=>'公用只读',:description=>'公用只读',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_data_access_levelpublic_read.lookup_values_tls.build(:lookup_value_id=>irm_data_access_levelpublic_read.id,:meaning=>'Public Read Only',:description=>'Public Read Only',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_data_access_levelpublic_read.save
    irm_data_access_levelpublic_read_write= Irm::LookupValue.new(:lookup_type=>'IRM_DATA_ACCESS_LEVEL',:lookup_code=>'PUBLIC_READ_WRITE',:start_date_active=>'2012-02-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_data_access_levelpublic_read_write.lookup_values_tls.build(:lookup_value_id=>irm_data_access_levelpublic_read_write.id,:meaning=>'公用读写',:description=>'公用读写',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_data_access_levelpublic_read_write.lookup_values_tls.build(:lookup_value_id=>irm_data_access_levelpublic_read_write.id,:meaning=>'Public Read and Write',:description=>'Public Read and Write',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_data_access_levelpublic_read_write.save
  end

  def down
  end
end
