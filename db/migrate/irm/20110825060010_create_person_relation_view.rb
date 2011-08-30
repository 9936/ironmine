class CreatePersonRelationView < ActiveRecord::Migration
  def self.up
    execute("CREATE OR REPLACE VIEW irm_person_relations_v AS
               select people.id source_id,'IRM__PERSON' source_type,people.id person_id from irm_people people
               union
               select people.organization_id source_id,'IRM__ORGANIZATION' source_type,people.id person_id from irm_people people where people.organization_id IS NOT NULL
               union
               select people.organization_id source_id,'IRM__ORGANIZATION_EXPLOSION' source_type,people.id person_id from irm_people people where people.organization_id IS NOT NULL
               union
               select explosions.parent_org_id source_id,'IRM__ORGANIZATION_EXPLOSION' source_type,people.id person_id from irm_people people,irm_organization_explosions explosions where people.organization_id = explosions.organization_id AND  people.organization_id IS NOT NULL
               union
               select people.role_id source_id,'IRM__ROLE' source_type,people.id person_id from irm_people people where people.role_id IS NOT NULL
               union
               select people.role_id source_id,'IRM__ROLE_EXPLOSION' source_type,people.id person_id from irm_people people where people.role_id IS NOT NULL
               union
               select explosions.parent_role_id source_id,'IRM__ROLE_EXPLOSION' source_type,people.id person_id from irm_people people,irm_role_explosions explosions where people.role_id = explosions.role_id AND people.role_id IS NOT NULL
               union
               select people.group_id source_id,'IRM__GROUP' source_type,people.person_id person_id from irm_group_members people
               union
               select people.group_id source_id,'IRM__GROUP_EXPLOSION' source_type,people.person_id person_id from irm_group_members people
               union
               select explosions.parent_group_id source_id,'IRM__GROUP_EXPLOSION' source_type,people.person_id person_id from irm_group_members people,irm_group_explosions explosions where people.group_id = explosions.group_id AND people.group_id IS NOT NULL
               union
               select systems.id source_id,'UID__EXTERNAL_SYSTEM' source_type,people.person_id person_id from uid_external_system_people people,uid_external_systems systems where people.external_system_code = systems.external_system_code
    ")
  end

  def self.down
    execute("drop view irm_person_relations_v")
  end
end
