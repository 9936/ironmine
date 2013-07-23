class Emw::InterfaceColumn < ActiveRecord::Base
  set_table_name :emw_interface_columns

  belongs_to :interface_table, :foreign_key => :interface_table_id

  validates_presence_of :name, :data_type, :data_length

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

end
