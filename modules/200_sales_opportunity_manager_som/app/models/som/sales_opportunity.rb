class Som::SalesOpportunity < ActiveRecord::Base
   set_table_name 'som_sales_opportunities'
   validates_presence_of :charge_person,:name,:potential_customer,:sales_status,:sales_person

   #加入activerecord的通用方法和scope
   query_extend
   # 对运维中心数据进行隔离
   default_scope { default_filter }
end
