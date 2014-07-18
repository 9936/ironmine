class AddTmpTables < ActiveRecord::Migration
  def up
    #icm
    execute("CREATE TABLE tmp_icm_incident_requests LIKE icm_incident_requests")
    execute("CREATE TABLE tmp_icm_incident_workloads LIKE icm_incident_workloads")
    #category
    execute("CREATE TABLE tmp_icm_incident_categories LIKE icm_incident_categories")
    execute("CREATE TABLE tmp_icm_incident_categories_tl LIKE icm_incident_categories_tl")
    execute("CREATE TABLE tmp_icm_incident_category_systems LIKE icm_incident_category_systems")
    #journal
    execute("CREATE TABLE tmp_icm_incident_journals LIKE icm_incident_journals")
    execute("CREATE TABLE tmp_icm_incident_journal_elapses LIKE icm_incident_journal_elapses")
    execute("CREATE TABLE tmp_icm_incident_histories LIKE icm_incident_histories")
    execute("CREATE TABLE tmp_icm_incident_request_relations LIKE icm_incident_request_relations")
    execute("CREATE TABLE tmp_irm_watchers LIKE irm_watchers")
    #attachment
    execute("CREATE TABLE tmp_irm_attachment_versions LIKE irm_attachment_versions")
    execute("CREATE TABLE tmp_irm_attachments LIKE irm_attachments")

    #people
    execute("CREATE TABLE tmp_irm_people LIKE irm_people")

    #organization
    execute("CREATE TABLE tmp_irm_organizations LIKE irm_organizations")
    execute("CREATE TABLE tmp_irm_organizations_tl LIKE irm_organizations_tl")

    #external system
    execute("CREATE TABLE tmp_irm_external_systems LIKE irm_external_systems")
    execute("CREATE TABLE tmp_irm_external_systems_tl LIKE irm_external_systems_tl")
    execute("CREATE TABLE tmp_irm_external_system_people LIKE irm_external_system_people")
    execute("CREATE TABLE tmp_icm_external_system_groups LIKE icm_external_system_groups")

    #group
    execute("CREATE TABLE tmp_irm_groups LIKE irm_groups")
    execute("CREATE TABLE tmp_irm_groups_tl LIKE irm_groups_tl")
    execute("CREATE TABLE tmp_irm_group_members LIKE irm_group_members")
    execute("CREATE TABLE tmp_icm_support_groups LIKE icm_support_groups")
    #object_attribute
    execute("CREATE TABLE tmp_irm_object_attributes LIKE irm_object_attributes")
    execute("CREATE TABLE tmp_irm_object_attributes_tl LIKE irm_object_attributes_tl")
    execute("CREATE TABLE tmp_irm_object_attribute_systems LIKE irm_object_attribute_systems")
  end

  def down
  end
end
