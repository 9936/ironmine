class Irm::BulletinColumn < ActiveRecord::Base
  set_table_name :irm_bulletin_columns

  belongs_to :bulletin
  belongs_to :bu_column

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu
end