class Skm::ApiEntryBooksController < ApplicationController
  before_filter :set_return_columns

  #获取专题列表
  #Request /api_entry_books/get_data.json
  def get_data
    entry_books_scope = Skm::EntryBook.multilingual
    entry_books_scope = entry_books_scope.match_value("#{Skm::EntryBooksTl.table_name}.name", params[:name])
    entry_books,count = paginate(entry_books_scope)


    result = {:total_rows => count}
    result[:items] = []

    entry_books.each do |eb|
      result[:items] << {:id => eb.id, :name => eb[:name], :description => eb[:description], :updated_at => eb[:updated_at]}
    end

    respond_to do |format|
      format.json {
        render json: result.to_json
      }
    end
  end


  #查看知识专题
  #Request /api_entry_books/show.json
  def show
    entry_book = Skm::EntryBook.multilingual.find(params[:id])
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

    result = {:id => entry_book.id, :name => entry_book[:name], :description => entry_book[:description], :items => [] }


    entry_book_relations.values.each do |cr|
      id = cr[:entry_header_id] || cr[:entry_book_id]
      updated_at = cr[:entry_updated_at] || cr[:updated_at]
      created_at = cr[:entry_created_at] || cr[:created_at]

      title = cr[:entry_title] || cr[:name]
      if cr[:relation_type].eql?("ENTRYHEADER")
        published_date = cr[:published_date]
        doc_number = cr[:doc_number]
        result[:items] << {:relation_type => cr[:relation_type], :id => id, :display_name => cr[:display_name], :title => title,
                           :updated_at => updated_at, :created_at => created_at, :published_date => published_date, :doc_number => doc_number }
      else
        result[:items] << {:relation_type => cr[:relation_type], :id => id, :display_name => cr[:display_name], :title => title,
                           :updated_at => updated_at, :created_at => created_at }
      end
    end

    respond_to do |format|
      format.json {
        render json: result.to_json
      }
    end

  end

  #创建知识专题
  #Request /api_entry_books/add.json
  def add
    entry_book = Skm::EntryBook.new({:name => params[:name], :description => params[:description]})
    if entry_book.save
      result = Skm::EntryBook.multilingual.find(entry_book.id)
      result = {:id => result.id, :name => result[:name], :description => result[:description]}
      respond_to do |format|
        format.json {
          render json: result.to_json(:only => @return_columns)
        }
      end
    end


  end

  #编辑知识专题
  #Request /api_entry_books/update.json
  def update
    result = Skm::EntryBook.find(params[:id])

    if result.update_attributes({:name => params[:name], :description => params[:description]})
      result = {:id => result.id, :name => params[:name], :description => params[:description]}
      respond_to do |format|
        format.json {
          render json: result.to_json(:only => @return_columns)
        }
      end
    end



  end

  private

    def set_return_columns
      @return_columns = []
      output_params = Irm::ApiParam.get_output_params(params[:controller], params[:action])
      output_params.each do |p|
        @return_columns << p.name.to_sym
      end
      @return_columns
    end
end