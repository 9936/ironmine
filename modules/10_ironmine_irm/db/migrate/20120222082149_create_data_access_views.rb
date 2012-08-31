class CreateDataAccessViews < ActiveRecord::Migration
  def up
    irm_data_accesses_same_peo_v = %Q{
    CREATE OR REPLACE VIEW irm_data_accesses_same_peo_v AS
    SELECT irm_people.opu_id,irm_business_objects.id business_object_id,irm_people.id source_person_id,irm_people.id target_person_id,'9' access_level
    FROM irm_people,irm_business_objects
    WHERE irm_business_objects.data_access_flag = 'Y'
    }

    execute(irm_data_accesses_same_peo_v)

    irm_data_accesses_tmp1_v = %Q{
    CREATE OR REPLACE VIEW irm_data_accesses_tmp1_v  AS
    SELECT irm_organizations.opu_id,irm_organizations.id organization_id,irm_business_objects.id business_object_id
    FROM irm_organizations,irm_business_objects
    WHERE irm_business_objects.data_access_flag = 'Y'
    }

    execute(irm_data_accesses_tmp1_v)

    irm_data_accesses_tmp2_v = %Q{
    CREATE OR REPLACE VIEW irm_data_accesses_tmp2_v AS
    SELECT irm_data_accesses_tmp1_v.*, irm_data_accesses.access_level FROM  irm_data_accesses_tmp1_v
    LEFT OUTER JOIN irm_data_accesses
    ON irm_data_accesses_tmp1_v.business_object_id = irm_data_accesses.business_object_id
    AND irm_data_accesses.organization_id = irm_data_accesses_tmp1_v.organization_id
    }

    execute(irm_data_accesses_tmp2_v)

    irm_data_accesses_same_org_v = %Q{
    CREATE OR REPLACE VIEW irm_data_accesses_same_org_v AS
    SELECT irm_data_accesses_tmp2_v.opu_id,irm_data_accesses_tmp2_v.business_object_id ,'SAME_ORG' access_type,'IRM__ORGANIZATION' source_type,
    irm_data_accesses_tmp2_v.organization_id source_id,'IRM__ORGANIZATION' target_type,irm_data_accesses_tmp2_v.organization_id target_id,
    CASE WHEN irm_data_accesses_tmp2_v.access_level IS NULL THEN irm_data_accesses.access_level
    WHEN irm_data_accesses_tmp2_v.access_level="" THEN irm_data_accesses.access_level
    ELSE irm_data_accesses_tmp2_v.access_level  END access_level
    FROM irm_data_accesses_tmp2_v
    LEFT OUTER JOIN irm_data_accesses
               ON irm_data_accesses_tmp2_v.opu_id = irm_data_accesses.opu_id
               AND irm_data_accesses.business_object_id = irm_data_accesses_tmp2_v.business_object_id
               AND irm_data_accesses.organization_id IS NULL
    }

    execute(irm_data_accesses_same_org_v)

    irm_data_accesses_parent_org_v = %Q{
    CREATE OR REPLACE VIEW irm_data_accesses_parent_org_v AS
    SELECT irm_data_accesses_same_org_v.opu_id, irm_data_accesses_same_org_v.business_object_id,'HIERARCHY_ORG' access_type,'IRM__ORGANIZATION' source_type,
     irm_data_accesses_same_org_v.source_id,'IRM__ORGANIZATION' target_type,irm_organization_explosions.parent_org_id target_id,irm_data_accesses_same_org_v.access_level
    FROM irm_data_accesses_same_org_v,irm_data_accesses,irm_organization_explosions
    WHERE irm_data_accesses_same_org_v.opu_id = irm_data_accesses.opu_id
    AND irm_data_accesses_same_org_v.business_object_id = irm_data_accesses.business_object_id
    AND irm_data_accesses.hierarchy_access_flag='Y'
    AND irm_data_accesses.`organization_id` IS NULL
    AND irm_organization_explosions.organization_id = irm_data_accesses_same_org_v.source_id
    }

    execute(irm_data_accesses_parent_org_v)

    irm_data_accesses_top_org_v = %Q{
    CREATE OR REPLACE VIEW irm_data_accesses_top_org_v AS
    SELECT opu_id,business_object_id,'SHARE_RULE' access_type,source_type,source_id,target_type,target_id,access_level from irm_data_share_rules
    UNION
    SELECT * FROM irm_data_accesses_parent_org_v
    UNION
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
    UNION
    SELECT irm_people.opu_id,irm_business_objects.id business_object_id,'SAME_PERSON' access_type,irm_people.id source_person_id,irm_people.id target_person_id,'9' access_level
    FROM irm_people,irm_business_objects
    WHERE irm_business_objects.data_access_flag = 'Y'
    }

    execute(irm_data_accesses_person_v)

    irm_data_accesses_v = %Q{
    CREATE OR REPLACE VIEW irm_data_accesses_v AS
    SELECT opu_id,business_object_id,source_person_id,target_person_id,max(access_level) access_level FROM  irm_data_accesses_person_v group by  opu_id,business_object_id,source_person_id,target_person_id
    }

    execute(irm_data_accesses_v)

  end

  def down
    execute("drop view irm_data_accesses_same_peo_v")
    execute("drop view irm_data_accesses_tmp1_v")
    execute("drop view irm_data_accesses_tmp2_v")
    execute("drop view irm_data_accesses_same_org_v")
    execute("drop view irm_data_accesses_parent_org_v")
    execute("drop view irm_data_accesses_top_org_v")
    execute("drop view irm_data_accesses_person_v")
    execute("drop view irm_data_accesses_v")

  end
end
