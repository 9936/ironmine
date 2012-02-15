class Irm::DataAccess < ActiveRecord::Base
  set_table_name :irm_data_accesses


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_business_object,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::BusinessObject.view_name} ON #{table_name}.business_object_id = #{Irm::BusinessObject.view_name}.id AND #{Irm::BusinessObject.view_name}.language = '#{language}'").
        select("#{Irm::BusinessObject.view_name}.name business_object_name")
  }

  scope :opu_data_access,lambda{where(:organization_id=>nil)}

  scope :org_data_access,lambda{|org_id|
    where(:organization_id=>org_id)
  }

  # 数据访问级别
  scope :with_access_level,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} access_level ON access_level.lookup_type='IRM_DATA_ACCESS_LEVEL' AND access_level.lookup_code = #{table_name}.access_level AND access_level.language= '#{language}'").
    select(" access_level.meaning access_level_name")
  }

  def self.prepare_for_opu
    access_objects = Irm::BusinessObject.joins("LEFT JOIN #{table_name} ON #{table_name}.business_object_id = #{Irm::BusinessObject.table_name}.id").
        where(:data_access_flag=>Irm::Constant::SYS_YES).
        select("#{Irm::BusinessObject.table_name}.id business_object_id,#{table_name}.id access_id")

    access_objects.select{|i| i.access_id.nil? }.each do |ao|
      self.create(:business_object_id=>ao[:business_object_id],:access_level=>"PUBLIC_READ_WRITE")
    end
  end

  def self.list_all
    self.select_all.with_business_object(I18n.locale).with_access_level(I18n.locale)
  end
end
