class Skm::BookWikisController < ApplicationController


  # POST /skm/book_wikis
  # POST /skm/book_wikis.xml
  def create
    book_wiki = Skm::BookWiki.new(:book_id=>params[:book_id],:wiki_id=>params[:wiki_id])
    @book = Skm::Book.find(params[:book_id])


    respond_to do |format|
      if book_wiki.save
        format.js
      else
        format.js
      end
    end
  end

  # DELETE /skm/book_wikis/1
  # DELETE /skm/book_wikis/1.xml
  def destroy
    book_wiki = Skm::BookWiki.find(params[:id])
    book_wiki.destroy
    @book = Skm::Book.find(@book_wiki.book_id)

    respond_to do |format|
      format.js
    end
  end

  def order
    @book = Skm::Book.find(params[:book_id])
    params[:orders].each do |key,value|
      if value[:id].present?&&value[:display_sequence].present?
        Skm::BookWiki.find(value[:id]).update_attribute(:display_sequence,value[:display_sequence])
      end
    end
    respond_to do |format|
      format.js {render "create"}
    end
  end

end
