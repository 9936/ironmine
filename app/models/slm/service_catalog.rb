class Slm::ServiceCatalog < ActiveRecord::Base
  set_table_name :slm_service_catalogs

  #多语言关系
  attr_accessor :name,:description
  has_many :service_catalogs_tls,:dependent => :destroy,:foreign_key=>"service_catalog_id"
  acts_as_multilingual


  query_extend

  validates_presence_of :catalog_code
  validates_uniqueness_of :catalog_code,:scope=>[:opu_id], :if => Proc.new { |i| !i.catalog_code.blank? }


  scope :query_by_category_code ,lambda{|language| select("v1.name category_name").
                                                        joins(",#{Slm::ServiceCategory.view_name} v1").
                                                        where("v1.category_code = #{table_name}.service_category_code and "+
                                                              "v1.language = ?",language)

  }

  scope :query_by_owner_id,lambda{
    joins(",#{Irm::Person.table_name}").
    where("#{table_name}.service_owner_id = #{Irm::Person.table_name}.id").
    select("#{Irm::Person.name_to_sql(nil,Irm::Person.table_name,'person_name')}")
  }

  scope :query_by_priority_code,lambda{|language| select("priority_vl.meaning priority_meaning").
          joins(",irm_lookup_values_vl priority_vl").
          where("priority_vl.lookup_type='SLM_CATALOG_PRIORITY' AND priority_vl.lookup_code = #{table_name}.priority_code AND "+
               "priority_vl.language = ?",language)
           }

  scope :with_external_system, lambda{
    joins(" LEFT OUTER JOIN #{Irm::ExternalSystem.table_name} es ON es.id = #{table_name}.external_system_id").
      joins(" LEFT OUTER JOIN #{Irm::ExternalSystemsTl.table_name} est ON es.id = est.external_system_id AND est.language = '#{I18n.locale}'").
      select("est.system_name external_system_name")

  }

  scope :with_slm_agreement, lambda{
    joins(" LEFT OUTER JOIN #{Slm::ServiceAgreement.table_name} sa ON sa.agreement_code = #{table_name}.slm_code").
        joins(" LEFT OUTER JOIN #{Slm::ServiceAgreementsTl.table_name} sat ON sat.service_agreement_id = sa.id AND sat.language = '#{I18n.locale}'").
        select("sat.name service_agreement_name")
  }

end
