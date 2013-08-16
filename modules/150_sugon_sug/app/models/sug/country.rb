class Sug::Country < ActiveRecord::Base
  set_table_name :sug_countries

  has_many :provinces, :foreign_key => :country_id, :dependent => :destroy

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  #default_scope { default_filter }

end