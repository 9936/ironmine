class Skm::WikiTemplate < ActiveRecord::Base
  set_table_name :skm_wiki_templates
  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}

  scope :by_person,lambda{|person_id|
    where("#{table_name}.private_flag=? OR #{table_name}.created_by = ?",Irm::Constant::SYS_YES,person_id)
  }
end
