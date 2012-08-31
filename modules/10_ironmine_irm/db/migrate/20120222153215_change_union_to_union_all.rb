class ChangeUnionToUnionAll < ActiveRecord::Migration
  def up
      execute("CREATE OR REPLACE VIEW irm_person_relations_v AS
             select people.id source_id,'IRM__PERSON' source_type,people.id person_id from irm_people people
             union all
             select people.organization_id source_id,'IRM__ORGANIZATION' source_type,people.id person_id from irm_people people where people.organization_id IS NOT NULL
             union all
             select people.organization_id source_id,'IRM__ORGANIZATION_EXPLOSION' source_type,people.id person_id from irm_people people where people.organization_id IS NOT NULL
             union all
             select explosions.parent_org_id source_id,'IRM__ORGANIZATION_EXPLOSION' source_type,people.id person_id from irm_people people,irm_organization_explosions explosions where people.organization_id = explosions.organization_id AND  people.organization_id IS NOT NULL
             union all
             select people.role_id source_id,'IRM__ROLE' source_type,people.id person_id from irm_people people where people.role_id IS NOT NULL
             union all
             select people.role_id source_id,'IRM__ROLE_EXPLOSION' source_type,people.id person_id from irm_people people where people.role_id IS NOT NULL
             union all
             select explosions.parent_role_id source_id,'IRM__ROLE_EXPLOSION' source_type,people.id person_id from irm_people people,irm_role_explosions explosions where people.role_id = explosions.role_id AND people.role_id IS NOT NULL
             union all
             select people.group_id source_id,'IRM__GROUP' source_type,people.person_id person_id from irm_group_members people
             union all
             select people.group_id source_id,'IRM__GROUP_EXPLOSION' source_type,people.person_id person_id from irm_group_members people
             union all
             select explosions.parent_group_id source_id,'IRM__GROUP_EXPLOSION' source_type,people.person_id person_id from irm_group_members people,irm_group_explosions explosions where people.group_id = explosions.group_id AND people.group_id IS NOT NULL
             union all
             select systems.id source_id,'IRM__EXTERNAL_SYSTEM' source_type,people.person_id person_id from irm_external_system_people people,irm_external_systems systems where people.external_system_id = systems.id
  ")

      irm_data_accesses_top_org_v = %Q{
      CREATE OR REPLACE VIEW irm_data_accesses_top_org_v AS
      SELECT opu_id,business_object_id,'SHARE_RULE' access_type,source_type,source_id,target_type,target_id,access_level from irm_data_share_rules
      UNION ALL
      SELECT * FROM irm_data_accesses_parent_org_v
      UNION ALL
      SELECT * FROM irm_data_accesses_same_org_v
      }

      execute(irm_data_accesses_top_org_v)


      irm_data_accesses_person_v = %Q{
      CREATE OR REPLACE VIEW irm_data_accesses_person_v AS
      SELECT irm_data_accesses_top_org_v.opu_id,irm_data_accesses_top_org_v.business_object_id,irm_data_accesses_top_org_v.access_type,pva.person_id source_person_id,pvb.person_id target_person_id,irm_data_accesses_top_org_v.access_level
      FROM irm_data_accesses_top_org_v,irm_person_relations_v pva,irm_person_relations_v pvb
      WHERE irm_data_accesses_top_org_v.source_type = pva.source_type
      AND irm_data_accesses_top_org_v.source_id = pva.source_id
      AND irm_data_accesses_top_org_v.target_type = pvb.source_type
      AND irm_data_accesses_top_org_v.target_id = pvb.source_id
      AND pva.person_id != pvb.person_id
      UNION ALL
      SELECT irm_people.opu_id,irm_business_objects.id business_object_id,'SAME_PERSON' access_type,irm_people.id source_person_id,irm_people.id target_person_id,'9' access_level
      FROM irm_people,irm_business_objects
      WHERE irm_business_objects.data_access_flag = 'Y'
      }

      execute(irm_data_accesses_person_v)

  end

  def down
  end
end
