class Emw::InterfaceTable < ActiveRecord::Base
  set_table_name :emw_interface_tables

  belongs_to :interface, :foreign_key => :interface_id
  has_many :interface_columns, :foreign_key => :interface_table_id, :dependent => :destroy

  validates_presence_of :name, :table_name, :interface_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

end
