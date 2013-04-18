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
        entry_book_id = @entry_book.id
        if params[:entry_book_id].present?
          Skm::EntryBookRelation.create(:book_id => params[:entry_book_id], :target_id => @entry_book.id, :relation_type => "ENTRYBOOK")
          entry_book_id = params[:entry_book_id]
        end
        #处理参考专题
        if params[:skm_entry_book][:preference_book_id].present?
          #获取参考专题下的所有知识
          entry_header_ids = Skm::EntryBookRelation.where(:book_id => @entry_book.preference_book_id, :relation_type => "ENTRYHEADER").collect{|i| i.target_id}
          if entry_header_ids.any?
            entry_header_ids.each do |entry_header_id|
              Skm::EntryBookRelation.create(:book_id => @entry_book.id, :target_id => entry_header_id, :relation_type => "ENTRYHEADER", :reference_flag => "Y")
            end


            #entry_headers = Skm::EntryHeader.where(:id => entry_header_ids, :type_code => 'ARTICLE')
            #entry_headers.each do |entry_header|
            #  new_entry_header = Skm::EntryHeader.new(entry_header.attributes)
            #  new_entry_header.entry_status_code = "PUBLISHED"
            #  new_entry_header.published_date = Time.now
            #  new_entry_header.doc_number = Skm::EntryHeader.generate_doc_number
            #  new_entry_header.version_number = "1"
            #  new_entry_header.author_id = Irm::Person.current.id
            #  new_entry_header.source_type = entry_header.source_type
            #  new_entry_header.source_id = entry_header.source_id
            #
            #  if new_entry_header.save
            #    entry_details = Skm::EntryDetail.where(:entry_header_id => entry_header.id)
            #    entry_details.each do |entry_detail|
            #      detail = Skm::EntryDetail.new(entry_detail.attributes)
            #      new_entry_header.entry_details << detail
            #    end
            #    #创建新旧知识关联
            #    params[:relation_type] ||= 'RELATION'
            #    Skm::EntryHeaderRelation.create(:source_id => entry_header.id, :target_id => new_entry_header.id, :relation_type => params[:relation_type])
            #    #同步附件
            #    entry_header.attachments.each do |at|
            #      begin
            #        Irm::AttachmentVersion.create_single_version_file(at.last_version_entity.data, at.last_version_entity.description, at.last_version_entity.category_id, Skm::EntryHeader.name, new_entry_header.id)
            #      rescue
            #      end
            #    end
            #    Skm::EntryBookRelation.create(:book_id => entry_book_id, :target_id => new_entry_header.id, :relation_type => "ENTRYHEADER")
            #
            #  end
            #end
          end
        end
        format.html { redirect_to({:action => "show",:id => entry_book_id }, :notice => t(:successfully_created)) }
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
        if params[:entry_book_id].present?
          entry_book_id = params[:entry_book_id]
        else
          entry_book_id = @entry_book.id
        end
        format.html { redirect_to({:action => "show", :id => entry_book_id }, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_display_name
    book_relation = Skm::EntryBookRelation.where(:book_id => params[:id] ,:target_id => params[:target_id]).first
    book_relation.display_name = params[:display_name] if params[:display_name]
    book_relation.save

    respond_to do |format|
      format.json { render :json => {:success => true}}
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
          if entry_book_relations[header.entry_header_id.to_s][:display_name].present?
            header[:display_name] = entry_book_relations[header.entry_header_id.to_s][:display_name]
          else
            header[:display_name] = header[:entry_title]
          end

          entry_book_relations[header.entry_header_id.to_s] = header
        end
      end

      relation_books.each do |book|
        if entry_book_relations[book.entry_book_id.to_s].present?
          if entry_book_relations[book.entry_book_id.to_s][:display_name].present?
            book[:display_name] = entry_book_relations[book.entry_book_id.to_s][:display_name]
          else
            book[:display_name] = book[:name]
          end

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
                       #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
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
