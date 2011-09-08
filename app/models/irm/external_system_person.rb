class Irm::ExternalSystemPerson < ActiveRecord::Base
  set_table_name :irm_external_system_people

  attr_accessor :temp_id_string

  validates_uniqueness_of :person_id, :scope => :external_system_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu

end