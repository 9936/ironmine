class Irm::PortletConfig < ActiveRecord::Base
  set_table_name :irm_portlet_configs
   #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  scope :with_person_name,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} ON  #{Irm::Person.table_name}.id = #{table_name}.person_id").
    select(" #{Irm::Person.table_name}.full_name person_name")
  }

  scope :personal_config,lambda{|person_id|
    where(:person_id=>person_id)
  }

  def self.list_all
    select_all.with_person_name
  end
end
