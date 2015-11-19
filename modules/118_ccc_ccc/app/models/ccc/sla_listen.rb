class Ccc::SlaListen < ActiveRecord::Base
  set_table_name :ccc_sla_listens

  #加入activerecord的通用方法和scope
  query_extend

  scope :select_all,lambda{
                     select("#{table_name}.*")
                   }

end
