# -*- coding: utf-8 -*-
class RelationTypeOption < ActiveRecord::Migration
  def up
    icm_incident_request_rel_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'ICM_INCIDENT_REQUEST_REL_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_rel_type.lookup_types_tls.build(:lookup_type_id=>icm_incident_request_rel_type.id,:meaning=>'事故单关联类型',:description=>'事故单关联类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_type.lookup_types_tls.build(:lookup_type_id=>icm_incident_request_rel_type.id,:meaning=>'IR Relation Type',:description=>'IR Relation Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_type.save

    icm_incident_request_rel_typeparent= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_REL_TYPE',:lookup_code=>'PARENT',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_rel_typeparent.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_rel_typeparent.id,:meaning=>'父事故单',:description=>'父事故单',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_typeparent.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_rel_typeparent.id,:meaning=>'Parent Request',:description=>'Parent Request',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_typeparent.save

    icm_incident_request_rel_typechild= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_REL_TYPE',:lookup_code=>'CHILD',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_rel_typechild.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_rel_typechild.id,:meaning=>'子事故单',:description=>'子事故单',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_typechild.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_rel_typechild.id,:meaning=>'Children Request',:description=>'Children Request',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_typechild.save

    icm_incident_request_rel_typesame= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_REL_TYPE',:lookup_code=>'SAME',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_rel_typesame.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_rel_typesame.id,:meaning=>'近似事故单',:description=>'近似事故单',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_typesame.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_rel_typesame.id,:meaning=>'Same Request',:description=>'Same Request',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_typesame.save

    icm_incident_request_rel_typerelation= Irm::LookupValue.new(:lookup_type=>'ICM_INCIDENT_REQUEST_REL_TYPE',:lookup_code=>'RELATION',:start_date_active=>'2011-05-11',:status_code=>'ENABLED',:not_auto_mult=>true)
    icm_incident_request_rel_typerelation.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_rel_typerelation.id,:meaning=>'相关事故单',:description=>'相关事故单',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_typerelation.lookup_values_tls.build(:lookup_value_id=>icm_incident_request_rel_typerelation.id,:meaning=>'Related Request',:description=>'Related Request',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    icm_incident_request_rel_typerelation.save
  end

  def down
  end
end
