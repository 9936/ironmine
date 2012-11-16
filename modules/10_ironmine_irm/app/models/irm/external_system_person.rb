class Irm::ExternalSystemPerson < ActiveRecord::Base
  set_table_name :irm_external_system_people

  attr_accessor :temp_id_string

  validates_uniqueness_of :person_id, :scope => [:external_system_id]
  validates_presence_of :system_profile_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  scope :function_ids_by_person,lambda{|person_id |
    select("#{self.table_name}.external_system_id,#{Irm::ProfileFunction.table_name}.function_id").
     joins("JOIN #{Irm::ProfileFunction.table_name} ON #{Irm::ProfileFunction.table_name}.profile_id = #{self.table_name}.system_profile_id").
        joins("JOIN #{Irm::LicenseFunction.table_name} ON #{Irm::ProfileFunction.table_name}.function_id = #{Irm::LicenseFunction.table_name}.function_id").
         where("#{self.table_name}.person_id = ? AND #{self.table_name}.system_profile_id IS NOT NULL",person_id)
  }

end