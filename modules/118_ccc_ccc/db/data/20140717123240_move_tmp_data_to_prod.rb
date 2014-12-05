class MoveTmpDataToProd < ActiveRecord::Migration
  def up

    #icm
    execute("INSERT INTO icm_incident_requests SELECT * FROM tmp_icm_incident_requests")
    execute("INSERT INTO icm_incident_workloads SELECT * FROM tmp_icm_incident_workloads")
    #category
    execute("INSERT INTO icm_incident_categories SELECT * FROM tmp_icm_incident_categories")
    execute("INSERT INTO icm_incident_categories_tl SELECT * FROM tmp_icm_incident_categories_tl")
    execute("INSERT INTO icm_incident_category_systems SELECT * FROM tmp_icm_incident_category_systems")
    #journal
    execute("INSERT INTO icm_incident_journals SELECT * FROM tmp_icm_incident_journals")
    execute("INSERT INTO icm_incident_journal_elapses SELECT * FROM tmp_icm_incident_journal_elapses")
    execute("INSERT INTO icm_incident_histories SELECT * FROM tmp_icm_incident_histories")
    execute("INSERT INTO icm_incident_request_relations SELECT * FROM tmp_icm_incident_request_relations")
    execute("INSERT INTO irm_watchers SELECT * FROM tmp_irm_watchers")
    #organization
    execute("INSERT INTO irm_organizations SELECT * FROM tmp_irm_organizations")
    execute("INSERT INTO irm_organizations_tl SELECT * FROM tmp_irm_organizations_tl")

    #external system
    execute("INSERT INTO irm_external_systems SELECT * FROM tmp_irm_external_systems")
    execute("INSERT INTO irm_external_systems_tl SELECT * FROM tmp_irm_external_systems_tl")
    execute("INSERT INTO irm_external_system_people SELECT * FROM tmp_irm_external_system_people")
    execute("INSERT INTO icm_external_system_groups SELECT * FROM tmp_icm_external_system_groups")

    #people
    execute("INSERT INTO irm_people SELECT * FROM tmp_irm_people")

    execute("INSERT INTO irm_groups SELECT * FROM tmp_irm_groups")
    execute("INSERT INTO irm_groups_tl SELECT * FROM tmp_irm_groups_tl")
    execute("INSERT INTO irm_group_members SELECT * FROM tmp_irm_group_members")
    execute("INSERT INTO icm_support_groups SELECT * FROM tmp_icm_support_groups")

    #object_attribute
    execute("INSERT INTO irm_object_attributes SELECT * FROM tmp_irm_object_attributes")
    execute("INSERT INTO irm_object_attributes_tl SELECT * FROM tmp_irm_object_attributes_tl")
    execute("INSERT INTO irm_object_attribute_systems SELECT * FROM tmp_irm_object_attribute_systems")
  end

  def down
  end
end
