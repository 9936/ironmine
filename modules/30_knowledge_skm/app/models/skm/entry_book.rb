class Skm::EntryBook < ActiveRecord::Base
  set_table_name :skm_entry_books

  #多语言关系
  attr_accessor :name,:description
  has_many :entry_books_tls, :foreign_key => "book_id",  :dependent => :destroy
  has_many :entry_book_relations, :foreign_key => "book_id",  :dependent => :destroy

  acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_books_by_relations, lambda{|book_id|
    joins("JOIN #{Skm::EntryBookRelation.table_name} sebr ON #{table_name}.id=sebr.target_id").
        where("sebr.book_id=? AND sebr.relation_type=?", book_id, "ENTRYBOOK").
        select("sebr.relation_type, sebr.id, #{table_name}.id entry_book_id")
  }

  def entry_books
    Skm::EntryBook.joins("JOIN #{Skm::EntryBookRelation.table_name} sebr ON #{table_name}.id=sebr.target_id").
        where("sebr.book_id=? AND sebr.relation_type=?", self.id, "ENTRYBOOK")
  end

  def entry_headers
    Skm::EntryHeader.joins("JOIN #{Skm::EntryBookRelation.table_name} sebr ON #{Skm::EntryHeader.table_name}.id = sebr.target_id").
        where("sebr.book_id=? AND sebr.relation_type=?", self.id, "ENTRYHEADER")
  end


end
