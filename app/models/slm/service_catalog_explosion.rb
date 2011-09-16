class Slm::ServiceCatalogExplosion < ActiveRecord::Base
  set_table_name :slm_service_catalog_explosions

  validates_presence_of :service_catalog_id,:parent_service_catalog_id,:direct_parent_service_catalog_id

  validates_uniqueness_of :service_catalog_id,:scope => [:parent_service_catalog_id,:direct_parent_service_catalog_id],:if=>Proc.new{|i| i.service_catalog_id.present?&&i.parent_service_catalog_id.present?&&i.direct_parent_service_catalog_id.present?}

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def self.explore_hierarchy(service_catalog_id,parent_service_catalog_id)
    # 当前服务的的父层服务没有发生变化，则不进行重新计算
    current_parent = self.where(:service_catalog_id=>service_catalog_id).first
    if (current_parent&&current_parent.direct_parent_service_catalog_id&&current_parent.direct_parent_service_catalog_id.eql?(parent_service_catalog_id))||(!parent_service_catalog_id.present?&&current_parent.nil?)
      return
    end

    # 子服务
    child_of_service_catalogs =  self.where(:parent_service_catalog_id => service_catalog_id)
    # 原来的父服务
    parent_of_service_catalogs = self.where(:service_catalog_id => service_catalog_id)

    # 如果存在父服务，则需要解除与父服务之间的关系
    # 解除子服务的子服务 与 以前父服务的关系
    parent_of_service_catalogs.each do |p_sc|
      child_of_service_catalogs.each do |c_sc|
        self.where(:service_catalog_id=>c_sc.service_catalog_id,:parent_service_catalog_id=>p_sc.parent_service_catalog_id).delete_all
      end
    end
    #解除子角色 与 以前父角色的关系
    self.where(:service_catalog_id=>service_catalog_id).delete_all

    if parent_service_catalog_id.present?
      # 现在的父角色 的 父角色
      parent_parent_service_catalog_ids = self.where(:service_catalog_id=>parent_service_catalog_id).collect{|i| i.parent_service_catalog_id}
      # 加上直接父角色
      parent_parent_service_catalog_ids << parent_service_catalog_id
      parent_parent_service_catalog_ids.each do |p_p_sc_id|
        child_of_service_catalogs.each do |c_sc|
          self.create(:service_catalog_id=>c_sc.service_catalog_id,:direct_parent_service_catalog_id=>c_sc.direct_parent_service_catalog_id,:parent_service_catalog_id=>p_p_sc_id)
        end
        self.create(:service_catalog_id=>service_catalog_id,:direct_parent_service_catalog_id=>parent_service_catalog_id,:parent_service_catalog_id=>p_p_sc_id)
      end
    end
  end
end
