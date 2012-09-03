class CreateIrmDataAccessesModelV < ActiveRecord::Migration
  def up

    irm_data_accesses_v = %Q{
    CREATE OR REPLACE VIEW irm_data_accesses_v AS
    SELECT irm_data_accesses_person_v.opu_id,irm_data_accesses_person_v.business_object_id,irm_business_objects.bo_model_name,irm_data_accesses_person_v.source_person_id,irm_data_accesses_person_v.target_person_id,max(irm_data_accesses_person_v.access_level) access_level FROM  irm_data_accesses_person_v,irm_business_objects where irm_data_accesses_person_v.business_object_id = irm_business_objects.id group by  irm_data_accesses_person_v.opu_id,irm_data_accesses_person_v.business_object_id,irm_business_objects.bo_model_name,irm_data_accesses_person_v.source_person_id,irm_data_accesses_person_v.target_person_id
    }

    execute(irm_data_accesses_v)
  end

  def down
  end
end
