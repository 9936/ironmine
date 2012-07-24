class Skm::Book < ActiveRecord::Base
  set_table_name :skm_books

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}

  validates_presence_of :name,:description

  validates_uniqueness_of :name,:if=>Proc.new{|i| i.name.present?}

  has_many :book_wikis
end
