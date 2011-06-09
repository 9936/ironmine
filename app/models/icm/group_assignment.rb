class Icm::GroupAssignment < ActiveRecord::Base
  set_table_name :icm_group_assignments
  belongs_to :support_group, :class => "Irm::SupportGroup"

  scope :query_service_catalog, lambda{|service_catalog_code|
    joins(",#{Slm::ServiceCatalog.table_name} sc").
        select("sc.catalog_code").
        where("sc.id = #{table_name}.source_id").
        where("sc.catalog_code = ?", service_catalog_code)
  }

  scope :query_external_system, lambda{|external_system_code|
    joins(",#{Uid::ExternalSystem.table_name} es").
        select("es.external_system_code").
        where("es.id = #{table_name}.source_id").
        where("es.external_system_code = ?", external_system_code)
  }
end