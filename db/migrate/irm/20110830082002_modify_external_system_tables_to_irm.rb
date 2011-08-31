class ModifyExternalSystemTablesToIrm < ActiveRecord::Migration
  def self.up
    execute("DROP VIEW irm_person_relations_v")
    execute("DROP VIEW uid_external_systems_vl")
    remove_index "uid_external_systems", :name => "UID_EXTERNAL_SYSTEMS_N1"
    remove_index :"uid_external_systems_tl", :name => "UID_EXTERNAL_SYSTEMS_TL_N1"

    rename_table :uid_external_systems, :irm_external_systems
    rename_table :uid_external_systems_tl, :irm_external_systems_tl

    add_index "irm_external_systems", ["opu_id","external_system_code"], :name => "IRM_EXTERNAL_SYSTEMS_N1"
    add_index "irm_external_systems_tl", ["external_system_id","language"], :name => "IRM_EXTERNAL_SYSTEMS_TL_N1"

    rename_table :uid_external_system_people, :irm_external_system_people

    rename_column :irm_external_system_people, :external_system_code, :external_system_id
    change_column :irm_external_system_people, :external_system_id, :string, :limit => 22

    execute('CREATE OR REPLACE VIEW irm_external_systems_vl AS SELECT t.*,tl.id lang_id,tl.system_name,tl.system_description,tl.language,tl.source_lang
                                             FROM irm_external_systems  t,irm_external_systems_tl tl
                                             WHERE t.id = tl.external_system_id')

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
               select systems.id source_id,'IRM__EXTERNAL_SYSTEM' source_type,people.person_id person_id from irm_external_system_people people,irm_external_systems systems where people.external_system_id = systems.id
    ")
  end

  def self.down
    execute("DROP VIEW irm_person_relations_v")
    execute("DROP VIEW irm_external_systems_vl")
    remove_index :irm_external_systems, :name => "IRM_EXTERNAL_SYSTEMS_N1"
    remove_index :irm_external_systems_tl, :name => "IRM_EXTERNAL_SYSTEMS_TL_N1"

    rename_table :irm_external_systems, :uid_external_systems
    rename_table :irm_external_systems_tl, :uid_external_systems_tl

    add_index "uid_external_systems", ["opu_id","external_system_code"], :name => "UID_EXTERNAL_SYSTEMS_N1"
    add_index "uid_external_systems_tl", ["external_system_id","language"], :name => "UID_EXTERNAL_SYSTEMS_TL_N1"

    rename_table :irm_external_system_people, :uid_external_system_people

    rename_column :uid_external_system_people, :external_system_id, :external_system_code
    change_column :uid_external_system_people, :external_system_code, :string, :limit => 30

    execute('CREATE OR REPLACE VIEW uid_external_systems_vl AS SELECT t.*,tl.id lang_id,tl.system_name,tl.system_description,tl.language,tl.source_lang
                                             FROM uid_external_systems  t,uid_external_systems_tl tl
                                             WHERE t.id = tl.external_system_id')

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
end
