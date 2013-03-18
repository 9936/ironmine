class Skm::EntryBooksTl < ActiveRecord::Base
  set_table_name :skm_entry_books_tl

  belongs_to :entry_book, :foreign_key => "book_id"
end