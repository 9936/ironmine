class Slm::ServiceMember < ActiveRecord::Base
  set_table_name :slm_service_members
  query_extend


  scope :query_wrap_info,lambda{|language| select("v1.meaning status_meaning, v2.name service_company_name,CONCAT(ip1.last_name,ip1.first_name) service_person_name," +
                                                  "CONCAT(ip2.last_name,ip2.first_name) service_contract_name," +
                                                  "iov.name service_organization_name,idv.name service_department_name,#{table_name}.*" ).
                                                   joins("left outer join irm_organizations_vl iov on #{table_name}.service_organization_id=iov.id AND iov.language = v2.language").
                                                   joins("left outer join irm_departments_vl idv on #{table_name}.service_department_id=idv.id AND idv.language = v2.language").
                                                   joins("left outer join irm_people ip1 on #{table_name}.service_person_id=ip1.id").
                                                   joins("left outer join irm_people ip2 on #{table_name}.service_contract_id=ip2.id").
                                                   joins("INNER JOIN irm_lookup_values_vl v1").
                                                   where("v1.lookup_type='SYSTEM_STATUS_CODE' AND v1.lookup_code = #{table_name}.status_code AND "+
                                                         "v1.language=?",language)}


  scope :query_by_service_company, lambda{|service_company_id| where("#{table_name}.service_company_id = ?", service_company_id) }
  scope :query_by_service_organization, lambda{|service_organization_id| where("#{table_name}.service_organization_id = ?", service_organization_id)}
  scope :query_by_service_department, lambda{|service_department_id| where("#{table_name}.service_department_id = ?", service_department_id)}
  scope :query_by_service_person, lambda{|service_person_id| where("#{table_name}.service_person_id = ?", service_person_id)}

  scope :with_service_catalog, lambda{
    joins(",#{Slm::ServiceCatalog.table_name} sc").
      where("sc.id = #{table_name}.service_catalog_id").
        select("sc.catalog_code catalog_code")
  }
end