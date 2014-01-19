class Som::SalesAuthorize < ActiveRecord::Base
  set_table_name 'som_sales_authorizes'
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  belongs_to :sales_opportunity
end
