class Skm::Book < ActiveRecord::Base
  set_table_name :skm_books

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}

  validates_presence_of :name,:description

  validates_uniqueness_of :name,:if=>Proc.new{|i| i.name.present?}

  has_many :book_wikis
  has_many :wikis,:through => :book_wikis

  #def wikis
  #  Skm::Wiki.by_book(self.id).select_all
  #end

  scope :by_wiki,lambda{|wiki_id|
    joins("JOIN #{Skm::BookWiki.table_name} ON #{Skm::BookWiki.table_name}.book_id = #{table_name}.id AND #{Skm::BookWiki.table_name}.wiki_id = '#{wiki_id}'")
  }

  def md5_flag
    @md5_flag ||= Digest::SHA1.hexdigest(Skm::Wiki.by_book(self.id).select("#{Skm::Wiki.table_name}.updated_at").collect{|i| i.updated_at.to_s}.join)
  end


  def self.sync_static(book_id)
    Skm::WikiToStatic.instance.sync_book_static(book_id)
  end
end
