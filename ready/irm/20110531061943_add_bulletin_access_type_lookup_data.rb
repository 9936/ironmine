# -*- coding: utf-8 -*-
class AddBulletinAccessTypeLookupData < ActiveRecord::Migration
  def self.up
    irm_bulletin_access_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'IRM_BULLETIN_ACCESS_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bulletin_access_type.lookup_types_tls.build(:lookup_type_id=>irm_bulletin_access_type.id,:meaning=>'公告范围类型',:description=>'公告范围类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_type.lookup_types_tls.build(:lookup_type_id=>irm_bulletin_access_type.id,:meaning=>'Bulletin Access Type',:description=>'Bulletin Access Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_type.save
    irm_bulletin_access_typeba_company= Irm::LookupValue.new(:lookup_type=>'IRM_BULLETIN_ACCESS_TYPE',:lookup_code=>'BA_COMPANY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bulletin_access_typeba_company.lookup_values_tls.build(:lookup_value_id=>irm_bulletin_access_typeba_company.id,:meaning=>'公司',:description=>'公司',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_typeba_company.lookup_values_tls.build(:lookup_value_id=>irm_bulletin_access_typeba_company.id,:meaning=>'Company',:description=>'Company',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_typeba_company.save
    irm_bulletin_access_typeba_organization= Irm::LookupValue.new(:lookup_type=>'IRM_BULLETIN_ACCESS_TYPE',:lookup_code=>'BA_ORGANIZATION',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bulletin_access_typeba_organization.lookup_values_tls.build(:lookup_value_id=>irm_bulletin_access_typeba_organization.id,:meaning=>'组织',:description=>'组织',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_typeba_organization.lookup_values_tls.build(:lookup_value_id=>irm_bulletin_access_typeba_organization.id,:meaning=>'Organization',:description=>'Organization',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_typeba_organization.save
    irm_bulletin_access_typeba_department= Irm::LookupValue.new(:lookup_type=>'IRM_BULLETIN_ACCESS_TYPE',:lookup_code=>'BA_DEPARTMENT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bulletin_access_typeba_department.lookup_values_tls.build(:lookup_value_id=>irm_bulletin_access_typeba_department.id,:meaning=>'部门',:description=>'部门',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_typeba_department.lookup_values_tls.build(:lookup_value_id=>irm_bulletin_access_typeba_department.id,:meaning=>'Department',:description=>'Department',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_typeba_department.save
    irm_bulletin_access_typeba_role= Irm::LookupValue.new(:lookup_type=>'IRM_BULLETIN_ACCESS_TYPE',:lookup_code=>'BA_ROLE',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_bulletin_access_typeba_role.lookup_values_tls.build(:lookup_value_id=>irm_bulletin_access_typeba_role.id,:meaning=>'角色',:description=>'角色',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_typeba_role.lookup_values_tls.build(:lookup_value_id=>irm_bulletin_access_typeba_role.id,:meaning=>'Role',:description=>'Role',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_bulletin_access_typeba_role.save
  end

  def self.down
  end
end
