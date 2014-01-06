class Som::SalesOpportunity < ActiveRecord::Base
   set_table_name 'som_sales_opportunities'
   validates_presence_of :charge_person,:name,:potential_customer,:sales_status,:sales_person
   validates_numericality_of :price

   has_many :communicate_infos
   #加入activerecord的通用方法和scope
   query_extend
   # 对运维中心数据进行隔离
   default_scope { default_filter }

  scope :as_charge_preson,lambda{
    where("#{table_name}.charge_person=?",Irm::Person.current.id)
  }

   scope :as_quote_status,lambda{
     where("#{table_name}.sales_status='QUOTE'")
   }

   scope :as_project_status,lambda{
     where("#{table_name}.sales_status='PROJECT'")
   }

   scope :as_bid_status,lambda{
     where("#{table_name}.sales_status='BID'")
   }

   scope :as_business_status,lambda{
     where("#{table_name}.sales_status='BUSINESS'")
   }

   scope :as_cancel_status,lambda{
     where("#{table_name}.sales_status='CANCEL'")
   }

end
