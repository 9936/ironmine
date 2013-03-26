class Skm::EntryBooksController < ApplicationController
  layout "application_full"

  # GET /entry_books
  # GET /entry_books.xml
  def index
    @entry_books = Skm::EntryBook.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entry_books }
    end
  end

  # GET /entry_books/1
  # GET /entry_books/1.xml
  def show
    @entry_book = Skm::EntryBook.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry_book }
    end
  end

  # GET /entry_books/new
  # GET /entry_books/new.xml
  def new
    @entry_book = Skm::EntryBook.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entry_book }
    end
  end

  # GET /entry_books/1/edit
  def edit
    @entry_book = Skm::EntryBook.multilingual.find(params[:id])
  end

  # POST /entry_books
  # POST /entry_books.xml
  def create
    @entry_book = Skm::EntryBook.new(params[:skm_entry_book])

    respond_to do |format|
      if @entry_book.save
        format.html { redirect_to({:action => "show",:id => @entry_book.id }, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @entry_book, :status => :created, :location => @entry_book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entry_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entry_books/1
  # PUT /entry_books/1.xml
  def update
    @entry_book = Skm::EntryBook.multilingual.find(params[:id])

    respond_to do |format|
      if @entry_book.update_attributes(params[:skm_entry_book])
        format.html { redirect_to({:action => "show", :id => @entry_book.id }, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entry_books/1
  # DELETE /entry_books/1.xml
  def destroy
    @entry_book = Skm::EntryBook.find(params[:id])
    @entry_book.destroy

    respond_to do |format|
      format.html { redirect_to(entry_books_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @entry_book = Skm::EntryBook.find(params[:id])
  end

  def multilingual_update
    @entry_book = Skm::EntryBook.find(params[:id])
    @entry_book.not_auto_mult=true
    respond_to do |format|
      if @entry_book.update_attributes(params[:skm_entry_book])
        format.html { redirect_to({:action => "show"}, :notice => 'Entry book was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    entry_books_scope = Skm::EntryBook.multilingual
    entry_books_scope = entry_books_scope.match_value("#{Skm::EntryBooksTl.table_name}.name", params[:name])
    entry_books,count = paginate(entry_books_scope)
    respond_to do |format|
      format.html  {
        @datas = entry_books
        @count = count
      }
      format.json {render :json=>to_jsonp(entry_books.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  #添加知识
  def add_entry
    @entry_book = Skm::EntryBook.find(params[:id])

    if @entry_book && params[:relation_type]
      relation_type = params[:relation_type]
      target_id = nil
      if relation_type.eql?("ENTRYHEADER")
        target_id = params[:entry_header_id]
      elsif relation_type.eql?("ENTRYBOOK")
        target_id =  params[:entry_book_id]
      end
      if relation_type && target_id && !target_id.eql?(@entry_book.id)
        relation = Skm::EntryBookRelation.new(:book_id => @entry_book.id, :target_id => target_id, :relation_type => relation_type)
        relation.save
      end

    end
    respond_to do |format|
      format.html { redirect_to({:controller => "skm/entry_books", :action => "show", :id => params[:id]}, :notice => t(:successfully_created)) }
      format.js
    end
  end

  #移除知识
  def remove_entry
    entry_book_relation = Skm::EntryBookRelation.where(:book_id => params[:id], :target_id => params[:target_id]).first
    entry_book_relation.destroy
    respond_to do |format|
      format.js
    end
  end

  def switch_sequence
    sequence_str = params[:ordered_ids]
    if sequence_str.present?
      sequence = 1
      ids = sequence_str.split(",")
      relations = Skm::EntryBookRelation.where(:id => ids).index_by(&:id)
      ids.each do |id|
        relation = relations[id]
        relation.display_sequence = sequence
        relation.save
        sequence += 1
      end
    end
    respond_to do |format|
      format.json  {render :json => {:success => true}}
    end
  end

  def get_owner_entry_data
    entry_book_relations = Skm::EntryBookRelation.order_by_sequence.targets(params[:id]).index_by(&:target_id)
    relation_headers = Skm::EntryBookRelation.query_headers_by_book(params[:id])
    relation_books = Skm::EntryBook.multilingual.query_books_by_relations(params[:id])


    if entry_book_relations.any?
      relation_headers.each do |header|
        if entry_book_relations[header.entry_header_id.to_s].present?
          entry_book_relations[header.entry_header_id.to_s] = header
        end
      end

      relation_books.each do |book|
        if entry_book_relations[book.entry_book_id.to_s].present?
          entry_book_relations[book.entry_book_id.to_s] = book
        end
      end
    end

    respond_to do |format|
      format.html  {
        @datas = entry_book_relations.values
        @count = entry_book_relations.values.count
      }
    end
  end

  def preview
    @entry_book = Skm::EntryBook.multilingual.find(params[:id])
  end

  def export
    @entry_book = Skm::EntryBook.multilingual.find(params[:id])
    respond_to do |format|
      format.pdf {
        render :pdf => "#{@entry_book[:name]}",
                       :print_media_type => false,
                       :encoding => 'utf-8',
                       :layout => "layouts/markdown_pdf.html.erb",
                       :wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
                       :book => true,
                       #:show_background_images => true,
                       #:show_as_html => true,
                       #:no_background => false,
                       :page_size => 'A4',
                       :toc=>{:header_text=>t(:label_skm_wiki_table_of_content),:disable_back_links=>true}
      }
    end
  end
end
