class Skm::Jobs::StaticBookJob<Struct.new(:book_id)
  def perform
    book = Skm::Book.query(book_id).first
    Skm::WikiToStatic.instance.book_to_static(book)  if book.present?
  end
end