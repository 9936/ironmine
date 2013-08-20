class Sug::Contact < ActiveRecord::Base
  set_table_name :sug_contacts

  has_many :addresses, :foreign_key => :source_id, :dependent => :destroy

  validates_presence_of :first_name

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  accepts_nested_attributes_for :addresses
end
