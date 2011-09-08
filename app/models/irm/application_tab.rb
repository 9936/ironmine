class Irm::ApplicationTab < ActiveRecord::Base
  set_table_name :irm_application_tabs

  belongs_to :applicaiton
  belongs_to :tab

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu
end
