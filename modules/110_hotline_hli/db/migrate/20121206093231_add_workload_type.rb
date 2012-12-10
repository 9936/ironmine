# -*- coding: utf-8 -*-
class AddWorkloadType < ActiveRecord::Migration
  def up
    workload_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'WORKLOAD_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    workload_type.lookup_types_tls.build(:lookup_type_id=>workload_type.id,:meaning=>'工时类型',:description=>'工时类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workload_type.lookup_types_tls.build(:lookup_type_id=>workload_type.id,:meaning=>'Workload Type',:description=>'Workload Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workload_type.save

    workload_typescene= Irm::LookupValue.new(:lookup_type=>'WORKLOAD_TYPE',:lookup_code=>'SCENE',:start_date_active=>'2012-09-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    workload_typescene.lookup_values_tls.build(:lookup_value_id=>workload_typescene.id,:meaning=>'现场',:description=>'现场',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workload_typescene.lookup_values_tls.build(:lookup_value_id=>workload_typescene.id,:meaning=>'Scene',:description=>'Scene',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workload_typescene.save

    workload_typeremote= Irm::LookupValue.new(:lookup_type=>'WORKLOAD_TYPE',:lookup_code=>'REMOTE',:start_date_active=>'2012-09-10',:status_code=>'ENABLED',:not_auto_mult=>true)
    workload_typeremote.lookup_values_tls.build(:lookup_value_id=>workload_typeremote.id,:meaning=>'远程',:description=>'远程',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    workload_typeremote.lookup_values_tls.build(:lookup_value_id=>workload_typeremote.id,:meaning=>'Remote',:description=>'Remote',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    workload_typeremote.save

    add_column :icm_incident_workloads, :workload_type, :string, :limit => 30, :after => :person_id
  end

  def down
    remove_column :icm_incident_workloads, :workload_type
  end
end
