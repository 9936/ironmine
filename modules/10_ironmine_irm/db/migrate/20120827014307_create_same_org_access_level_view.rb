class CreateSameOrgAccessLevelView < ActiveRecord::Migration
  def up
    execute(%Q(
      CREATE OR REPLACE VIEW irm_same_org_access_level AS
          SELECT
              irm_organizations.id,
              da1.business_object_id,
              (CASE
                  WHEN
                      (da2.access_level IS NULL
                          OR da2.access_level = '')
                  THEN
                      da1.access_level
                  ELSE da2.access_level
              END) AS access_level
          FROM
              irm_data_accesses da1
                  JOIN
              irm_organizations
                  LEFT JOIN
              irm_data_accesses da2 ON irm_organizations.id = da2.organization_id
                  AND da2.business_object_id = da1.business_object_id
          WHERE
              da1.organization_id IS NULL

            ))

  end

  def down
    execute("DROP VIEW irm_same_org_access_level")
  end
end
