class Skm::EntryBook < ActiveRecord::Base
  set_table_name :skm_entry_books

  #多语言关系
  attr_accessor :name,:description
  has_many :entry_books_tls, :foreign_key => "book_id",  :dependent => :destroy

  acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


end
