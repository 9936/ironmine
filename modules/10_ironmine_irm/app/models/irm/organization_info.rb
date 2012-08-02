class Irm::OrganizationInfo < ActiveRecord::Base
  set_table_name :irm_organization_infos

  validates_presence_of :name, :value

  attr_accessor :file

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

   scope :default,lambda{
    where(:default_flag=>Irm::Constant::SYS_YES)
   }

   def url_options
    {:controller=>self.controller,:action=>self.action}
   end
end
