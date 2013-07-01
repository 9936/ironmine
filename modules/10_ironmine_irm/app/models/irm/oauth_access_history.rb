class Irm::OauthAccessHistory < ActiveRecord::Base
  set_table_name :irm_oauth_access_histories

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}


  scope :with_client, lambda {|client_id|
    where("#{table_name}.client_id=?", client_id)
  }

  scope :with_person, lambda {
    joins("JOIN #{Irm::Person.table_name} p ON #{table_name}.access_by=p.id").
        select("p.full_name").
        order("#{table_name}.accessed_at desc")
  }

end
