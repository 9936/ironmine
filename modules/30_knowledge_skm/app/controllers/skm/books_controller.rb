class Skm::BooksController < ApplicationController
  layout "application_full"
  # GET /skm/books
  # GET /skm/books.xml
  def index
    books = Skm::Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => books }
    end
  end

  # GET /skm/books/1
  # GET /skm/books/1.xml
  def show
    @book = Skm::Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /skm/books/new
  # GET /skm/books/new.xml
  def new
    @book = Skm::Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /skm/books/1/edit
  def edit
    @book = Skm::Book.find(params[:id])
  end

  # POST /skm/books
  # POST /skm/books.xml
  def create
    @book = Skm::Book.new(params[:skm_book])

    respond_to do |format|
      if @book.save
        format.html { redirect_to({:action => "show",:id=>@book.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /skm/books/1
  # PUT /skm/books/1.xml
  def update
    @book = Skm::Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:skm_book])
        format.html { redirect_to({:action => "show",:id=>@book.id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /skm/books/1
  # DELETE /skm/books/1.xml
  def destroy
    @book = Skm::Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(skm_books_url) }
      format.xml  { head :ok }
    end
  end



  def get_data
    skm_books_scope = Skm::Book.where("1=1")
    skm_books_scope = skm_books_scope.match_value("#{Skm::Book.table_name}.name",params[:name])
    skm_books,count = paginate(skm_books_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(irm_wikis.to_grid_json([:name,:description,:created_at], count)) }
      format.html  {
        @count = count
        @datas = skm_books
      }
    end
  end

  def publish
    @book = Skm::Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.pdf {
        pdf_path = Skm::WikiToStatic.instance.book_to_static(@book,:pdf)
        File.open(pdf_path, 'rb') do |f|
          send_data f.read, :filename=>"#{@book.name}.pdf", :type => 'application/pdf', :disposition => 'inline'
        end
      }
      #format.pdf {
      #  render :pdf => "#{@book.name}",
      #                 :print_media_type => false,
      #                 :encoding => 'utf-8',
      #                 :layout => "layouts/markdown_pdf.html.erb",
      #                 :book => true,
      #                 :page_size => 'A4',
      #                 :toc=>{:header_text=>t(:label_skm_wiki_table_of_content),:disable_back_links=>true}
      #}
    end
  end
end
