class ResetIrmPersonRelationsV < ActiveRecord::Migration
  def up
    execute(%Q(CREATE OR REPLACE VIEW irm_person_relations_v2 AS select
       `people`.`id` AS `source_id`,_utf8'IRM__PERSON' AS `source_type`,
       `people`.`id` AS `person_id`
    from `irm_people` `people` union all select `people`.`organization_id` AS `source_id`,_utf8'IRM__ORGANIZATION' AS `source_type`,`people`.`id` AS `person_id` from `irm_people` `people`
    where (`people`.`organization_id` is not null) union all select `people`.`organization_id` AS `source_id`,_utf8'IRM__ORGANIZATION_EXPLOSION' AS `source_type`,`people`.`id` AS `person_id` from `irm_people` `people`
    where (`people`.`organization_id` is not null) union all select `explosions`.`parent_org_id` AS `source_id`,_utf8'IRM__ORGANIZATION_EXPLOSION' AS `source_type`,`people`.`id` AS `person_id` from (`irm_people` `people` join `irm_organization_explosions` `explosions`)
    where ((`people`.`organization_id` = `explosions`.`organization_id`) and (`people`.`organization_id` is not null)) union all select `people`.`role_id` AS `source_id`,_utf8'IRM__ROLE' AS `source_type`,`people`.`id` AS `person_id` from `irm_people` `people`
    where (`people`.`role_id` is not null) union all select `people`.`role_id` AS `source_id`,_utf8'IRM__ROLE_EXPLOSION' AS `source_type`,`people`.`id` AS `person_id` from `irm_people` `people`
    where (`people`.`role_id` is not null) union all select `explosions`.`parent_role_id` AS `source_id`,_utf8'IRM__ROLE_EXPLOSION' AS `source_type`,`people`.`id` AS `person_id` from (`irm_people` `people` join `irm_role_explosions` `explosions`)
    where ((`people`.`role_id` = `explosions`.`role_id`) and (`people`.`role_id` is not null)) union all select `people`.`group_id` AS `source_id`,_utf8'IRM__GROUP' AS `source_type`,`people`.`person_id` AS `person_id` from `irm_group_members` `people` union all select `people`.`group_id` AS `source_id`,_utf8'IRM__GROUP_EXPLOSION' AS `source_type`,`people`.`person_id` AS `person_id` from `irm_group_members` `people` union all select `explosions`.`parent_group_id` AS `source_id`,_utf8'IRM__GROUP_EXPLOSION' AS `source_type`,`people`.`person_id` AS `person_id` from (`irm_group_members` `people` join `irm_group_explosions` `explosions`)
    where ((`people`.`group_id` = `explosions`.`group_id`) and (`people`.`group_id` is not null)) union all select `systems`.`id` AS `source_id`,_utf8'IRM__EXTERNAL_SYSTEM' AS `source_type`,`people`.`person_id` AS `person_id` from (`irm_external_system_people` `people` join `irm_external_systems` `systems`)
    where (`people`.`external_system_id` = `systems`.`id`)))
    execute(%Q(DROP VIEW irm_person_relations_v))
    execute(%Q(CREATE TABLE irm_person_relations_tmp AS SELECT * FROM irm_person_relations_v2))
    execute(%Q(CREATE OR REPLACE VIEW irm_person_relations_v AS SELECT * FROM irm_person_relations_tmp))
  end

  def down
  end
end
