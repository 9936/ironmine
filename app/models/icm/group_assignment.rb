class Icm::GroupAssignment < ActiveRecord::Base
  set_table_name :icm_group_assignments
  belongs_to :support_group, :class_name => "Icm::SupportGroup"
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_service_catalog, lambda{|service_catalog_code|
    joins(",#{Slm::ServiceCatalog.table_name} sc").
        select("sc.catalog_code").
        where("sc.id = #{table_name}.source_id").
        where("sc.catalog_code = ?", service_catalog_code)
  }
end