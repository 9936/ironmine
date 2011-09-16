class Slm::ServiceCatalog < ActiveRecord::Base
  set_table_name :slm_service_catalogs

  #多语言关系
  attr_accessor :name,:description
  has_many :service_catalogs_tls,:dependent => :destroy,:foreign_key=>"service_catalog_id"
  acts_as_multilingual

  attr_accessor :external_system_str
  has_many :service_members

  attr_accessor :level

  query_extend

  after_save :explore_service_catalog_hierarchy

  validates_presence_of :catalog_code
  validates_uniqueness_of :catalog_code,:scope=>[:opu_id], :if => Proc.new { |i| !i.catalog_code.blank? }


  scope :with_category ,lambda{|language|
    joins("LEFT OUTER JOIN #{Slm::ServiceCategory.view_name} ON #{Slm::ServiceCategory.view_name}.id = #{table_name}.service_category_id AND #{Slm::ServiceCategory.view_name}.language = '#{language}'").
    select("#{Slm::ServiceCategory.view_name}.name category_name")
  }

  scope :with_slm_agreement, lambda{|language|
    joins(" LEFT OUTER JOIN #{Slm::ServiceAgreement.view_name} ON #{Slm::ServiceAgreement.view_name}.id = #{table_name}.slm_id AND #{Slm::ServiceAgreement.view_name}.language = '#{language}'").
    select("#{Slm::ServiceAgreement.view_name}.name service_agreement_name")
  }

  scope :with_parent,lambda{|language|
    joins(" LEFT OUTER JOIN #{view_name} parent ON parent.id = #{table_name}.parent_catalog_id AND parent.language = '#{language}'").
    select("parent.name parent_catalog_name")
  }

  scope :query_by_external_system,lambda{|external_system_id|
    where("EXISTS(SELECT 1 FROM #{Slm::ServiceMember.table_name} WHERE #{Slm::ServiceMember.table_name}.external_system_id=? AND #{table_name}.id =  #{Slm::ServiceMember.table_name}.service_catalog_id)",external_system_id)
  }

  scope :parentable,lambda{|catalog_id|
    where("#{table_name}.id!=? AND NOT EXISTS(SELECT 1 FROM #{Slm::ServiceCatalogExplosion.table_name} WHERE #{Slm::ServiceCatalogExplosion.table_name}.parent_service_catalog_id = ? AND #{Slm::ServiceCatalogExplosion.table_name}.service_catalog_id = #{table_name}.id)",service_catalog_id,service_catalog_id)
  }

  #创建 更新报表列
  def create_external_system_from_str
    value_str = self.external_system_str
    return unless value_str
    str_values = value_str.split(",").delete_if{|i| !i.present?}
    exists_values = Slm::ServiceMember.where(:service_catalog_id=>self.id)
    exists_values.each do |e_value|
      if str_values.include?(e_value.external_system_id)
        str_values.delete(e_value.external_system_id)
      else
        e_value.destroy
      end

    end

    str_values.each do |value_id|
      next unless value_id.strip.present?
      self.service_members.build({:external_system_id=>value_id})
    end if str_values.any?
  end

  def get_external_system_str
    return @get_external_system_str if @get_external_system_str
    @get_external_system_str = Slm::ServiceMember.where(:service_catalog_id=>self.id).collect{|value| value.external_system_id}.join(",")
  end
  private
  def explore_service_catalog_hierarchy
    Slm::ServiceCatalogExplosion.explore_hierarchy(self.id,self.parent_catalog_id)
  end

end
