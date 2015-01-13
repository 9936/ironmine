class InitImp < ActiveRecord::Migration
  def up
    execute("CREATE TABLE imp_incident_requests LIKE icm_incident_requests") unless table_exists?(:imp_incident_requests)
    execute("CREATE TABLE imp_incident_journals LIKE icm_incident_journals") unless table_exists?(:imp_incident_journals)
    execute("CREATE TABLE imp_people LIKE irm_people") unless table_exists?(:imp_people)
    execute("CREATE TABLE imp_external_systems LIKE irm_external_systems") unless table_exists?(:imp_external_systems)
    execute("CREATE TABLE imp_external_system_people LIKE irm_external_system_people") unless table_exists?(:imp_external_system_people)
    execute("CREATE TABLE imp_groups LIKE icm_support_groups") unless table_exists?(:imp_groups)
    execute("CREATE TABLE imp_system_groups LIKE icm_external_system_groups") unless table_exists?(:imp_system_groups)
    execute("CREATE TABLE imp_organizations LIKE irm_organizations") unless table_exists?(:imp_organizations)
  end

  def down
  end
end
