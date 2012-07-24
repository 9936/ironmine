class Skm::BookWiki < ActiveRecord::Base
  set_table_name :skm_book_wikis

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}

  validates_presence_of :book_id,:wiki_id
  validates_presence_of :display_sequence,:if=>Proc.new{|i| !i.new_record?}
  validates_uniqueness_of :wiki_id,:scope => [:book_id],:if=>Proc.new{|i| i.book_id.present?&&i.wiki_id.present?}

  scope :with_wiki,lambda{
    joins("JOIN #{Skm::Wiki.table_name} ON #{Skm::Wiki.table_name}.id = #{table_name}.wiki_id").
        select("#{table_name}.id,#{table_name}.display_sequence,#{table_name}.book_id,#{table_name}.wiki_id,#{Skm::Wiki.table_name}.name,#{Skm::Wiki.table_name}.description,#{Skm::Wiki.table_name}.created_at,#{Skm::Wiki.table_name}.updated_at").
        order("display_sequence")
  }

  before_create do
    num = self.class.where(:book_id=>self.book_id).select("max(display_sequence) display_sequence").first
    self.display_sequence = (num ? num.display_sequence : 0)+1
  end
end
