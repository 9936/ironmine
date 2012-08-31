# -*- coding: utf-8 -*-
class AddChangeRequstTypeLookup < ActiveRecord::Migration
  def up
    change_request_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'CHANGE_REQUEST_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    change_request_type.lookup_types_tls.build(:lookup_type_id=>change_request_type.id,:meaning=>'变更类型',:description=>'变更类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    change_request_type.lookup_types_tls.build(:lookup_type_id=>change_request_type.id,:meaning=>'Change Request',:description=>'Change Request',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    change_request_type.save

    change_request_typenormal= Irm::LookupValue.new(:lookup_type=>'CHANGE_REQUEST_TYPE',:lookup_code=>'NORMAL',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    change_request_typenormal.lookup_values_tls.build(:lookup_value_id=>change_request_typenormal.id,:meaning=>'正常',:description=>'正常',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    change_request_typenormal.lookup_values_tls.build(:lookup_value_id=>change_request_typenormal.id,:meaning=>'Normal',:description=>'Normal',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    change_request_typenormal.save
    change_request_typestandard= Irm::LookupValue.new(:lookup_type=>'CHANGE_REQUEST_TYPE',:lookup_code=>'STANDARD',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    change_request_typestandard.lookup_values_tls.build(:lookup_value_id=>change_request_typestandard.id,:meaning=>'标准',:description=>'标准',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    change_request_typestandard.lookup_values_tls.build(:lookup_value_id=>change_request_typestandard.id,:meaning=>'Standard',:description=>'Standard',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    change_request_typestandard.save
    change_request_typeemergency= Irm::LookupValue.new(:lookup_type=>'CHANGE_REQUEST_TYPE',:lookup_code=>'EMERGENCY',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    change_request_typeemergency.lookup_values_tls.build(:lookup_value_id=>change_request_typeemergency.id,:meaning=>'紧急',:description=>'紧急',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    change_request_typeemergency.lookup_values_tls.build(:lookup_value_id=>change_request_typeemergency.id,:meaning=>'Emergency',:description=>'Emergency',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    change_request_typeemergency.save
  end

  def down
  end
end
