class Skm::EntryBookRelation < ActiveRecord::Base
  set_table_name :skm_entry_books_relations

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  belongs_to :entry_book, :foreign_key => "book_id"

  validates_presence_of :target_id, :scope => [:book_id]



  before_create :build_sequence






  scope :order_by_sequence,lambda{
    self.order("display_sequence ASC")
  }

  scope :targets, lambda{|book_id|
    where("#{table_name}.book_id=?", book_id)
  }

  #scope :template_entry_book, lambda {
  #  joins("JOIN #{Skm::EntryBook.table_name} tb ON tb.id=#{table_name}.book_id").
  #      where("tb.project_id='-1'")
  #}

  scope :with_entry_books, lambda {
    select("#{table_name}.*, b.doc_number").
        joins("JOIN #{Skm::EntryBook.table_name} b ON b.id = #{table_name}.target_id").
        where("#{table_name}.relation_type")
  }


  #scope :with_person, lambda {
  #  joins("JOIN #{Irm::Person.table_name} p on p.id=#{table_name}.created_by").
  #      select("#{table_name}.*, p.full_name author_name, p.login_name author_login_name")
  #}


  scope :query_headers_by_book, lambda{|book_id|
    joins("JOIN #{Skm::EntryHeader.table_name} seh ON #{table_name}.target_id=seh.id").
        joins("JOIN #{Irm::Person.table_name} p ON p.id=seh.author_id").
        where("#{table_name}.book_id=? AND #{table_name}.relation_type=?", book_id, "ENTRYHEADER").
        select("#{table_name}.*, p.full_name author_name,seh.entry_title, seh.doc_number, seh.id entry_header_id, seh.type_code, seh.published_date, seh.created_at entry_created_at, seh.updated_at entry_updated_at")
  }

  def self.merge_headers(old_header_id, new_header_id)
    self. update_all({:target_id => new_header_id }, {:target_id => old_header_id, :relation_type => "ENTRYHEADER"})
  end

  def doc_number
    self.attributes['doc_number']
  end

  private
    #构建sequence
    def build_sequence
      current_sequence = Skm::EntryBookRelation.targets(self.book_id).select("display_sequence").order("display_sequence DESC").first
      if current_sequence.present?
        self.display_sequence = current_sequence[:display_sequence] + 1
      else
        self.display_sequence = 1
      end
    end

end