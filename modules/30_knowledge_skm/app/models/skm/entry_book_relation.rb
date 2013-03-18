class Skm::EntryBookRelation < ActiveRecord::Base
  set_table_name :skm_entry_books_relations

  validates_presence_of :entry_header_id, :scope => [:book_id]

  before_create :build_sequence


  scope :order_by_sequence,lambda{
    self.order("display_sequence ASC")
  }

  scope :query_by_book, lambda{|book_id|
    joins("JOIN #{Skm::EntryHeader.table_name} seh ON #{table_name}.entry_header_id=seh.id").
        where("#{table_name}.book_id=?", book_id).
        select("#{table_name}.*, seh.entry_title, seh.doc_number, seh.id entry_header_id, seh.type_code, seh.published_date, seh.created_at entry_created_at, seh.updated_at entry_updated_at")
  }

  private
    #构建sequence
    def build_sequence
      current_sequence = Skm::EntryBookRelation.select("display_sequence").order("display_sequence DESC").first
      if current_sequence.present?
        self.display_sequence = current_sequence[:display_sequence] + 1
      else
        self.display_sequence = 1
      end
    end

end