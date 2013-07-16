class Skm::ApiEntryBooksController < ApiController
  #获取专题列表
  #Request /api_entry_books/get_data.json
  def get_data
    entry_books_scope = Skm::EntryBook.multilingual.with_person
    entry_books_scope = entry_books_scope.with_author(params[:author_id]) if params[:author_id].present?
    entry_books_scope = entry_books_scope.with_login_name(params[:author_login_name]) if params[:author_login_name].present?
    entry_books_scope = entry_books_scope.with_project(params[:project_id]) if params[:project_id].present?

    #根据分类进行查找
    if params[:column_id].present?
      entry_books_scope = entry_books_scope.within_accessible_columns(params[:column_id])
    end

    #根据名称和项目名称进行模糊查找
    entry_books_scope = entry_books_scope.match_value("#{Skm::EntryBooksTl.table_name}.name", params[:name])
    entry_books_scope = entry_books_scope.match_value("#{Skm::EntryBook.table_name}.project_name", params[:project_name])

    entry_books, count = paginate(entry_books_scope)

    result = {:total_rows => count}
    result[:items] = []

    entry_books.each do |eb|
      result[:items] << {:id => eb.id, :name => eb[:name], :description => eb[:description], :updated_at => eb[:updated_at], :author_name => eb[:author_name]}
    end

    respond_to do |format|
      format.json {
        render json: result.to_json
      }
    end
  end

  #获取模板专题关系数据
  #Request /api_entry_books/get_relations.json
  def get_relations
    relations = ActiveRecord::Base.connection.select_all("select ebr.*, sh.doc_number, sh.published_date, p.full_name author_name from skm_entry_books_relations ebr
      JOIN skm_entry_headers sh on ebr.target_id = sh.id and ebr.relation_type = 'ENTRYHEADER'
      JOIN irm_people p on p.id = sh.author_id
      JOIN skm_entry_books eb on ebr.book_id = eb.id
      WHERE eb.project_id = '-1'
      UNION
      SELECT ebr.*, '-1' doc_number, b.created_at published_date, p.full_name author_name from skm_entry_books_relations ebr
      JOIN skm_entry_books b ON ebr.target_id = b.id and ebr.relation_type = 'ENTRYBOOK'
      JOIN skm_entry_books eb on ebr.book_id = eb.id
      JOIN irm_people p on p.id = b.created_by
      WHERE eb.project_id = '-1'")

    result = []
    relations.each do |r|
      result << {:id => r["id"], :book_id => r["book_id"], :target_id => r["target_id"], :display_name => r["display_name"], :status_code => r["status_code"],
                 :display_sequence => r["display_sequence"], :doc_number => r['doc_number'], :published_date => r['published_date'], :author_name => r['author_name'] }
    end

    respond_to do |format|
      format.json {
        render json: result.to_json#(:only => @return_columns)
      }
    end
  end


  ##获取模板专题列表
  ##Request /api_entry_books/get_data.json
  #def get_template_data
  #  entry_books_scope = Skm::EntryBook.multilingual.with_person
  #  entry_books_scope = entry_books_scope.with_author(params[:author_id]) if params[:author_id].present?
  #  entry_books_scope = entry_books_scope.with_login_name(params[:author_login_name]) if params[:author_login_name].present?
  #  entry_books_scope = entry_books_scope.where("project_id is null")
  #
  #  #根据分类进行查找
  #  if params[:column_id].present?
  #    entry_books_scope = entry_books_scope.within_accessible_columns(params[:column_id])
  #  end
  #
  #  #根据名称和项目名称进行模糊查找
  #  entry_books_scope = entry_books_scope.match_value("#{Skm::EntryBooksTl.table_name}.name", params[:name])
  #
  #  entry_books, count = paginate(entry_books_scope)
  #
  #  result = {:total_rows => count}
  #  result[:items] = []
  #
  #  entry_books.each do |eb|
  #    result[:items] << {:id => eb.id, :name => eb[:name], :description => eb[:description], :updated_at => eb[:updated_at], :author_name => eb[:author_name]}
  #  end
  #
  #  respond_to do |format|
  #    format.json {
  #      render json: result.to_json
  #    }
  #  end
  #end


  #查看知识专题
  #Request /api_entry_books/show.json
  def show
    result = entry_book_details(params[:id])

    respond_to do |format|
      format.json {
        render json: result.to_json
      }
    end

  end

  #创建知识专题
  #Request /api_entry_books/add.json
  def add
    entry_book = Skm::EntryBook.new({:name => params[:name],
                                     :description => params[:description],
                                     :project_id => params[:project_id],
                                     :project_name => params[:project_name],
                                     :channel_id => params[:channel_id]})
    if entry_book.save
      result = entry_book_details(entry_book.id)
      respond_to do |format|
        format.json {
          render json: result.to_json
        }
      end
    else
      raise entry_book.errors.full_messages.to_s
    end


  end

  #编辑知识专题
  #Request /api_entry_books/update.json
  def update
    result = Skm::EntryBook.find(params[:id])

    if result.update_attributes({:name => params[:name],
                                 :description => params[:description],
                                 :project_id => params[:project_id],
                                 :project_name => params[:project_name],
                                 :channel_id => params[:channel_id]})

      if params[:items].present?
        items = ActiveSupport::JSON.decode(params[:items])
        #查找目前专题中的专题和子专题
        old_relations = Skm::EntryBookRelation.targets(result.id)
        sequence = 1
        items.each do |item|
          if item["id"].present? && item["display_name"].present?
            old_relations.delete_if{|r| r.id.eql?(item[:id])}

            relation = Skm::EntryBookRelation.where(:id => item["id"]).first
            if relation.present?
              relation.display_sequence = sequence
              relation.display_name = item["display_name"]

            elsif item["relation_type"].present?
              relation = Skm::EntryBookRelation.new(:book_id => result.id,
                                                    :target_id => item["id"],
                                                    :relation_type => item["relation_type"],
                                                    :display_name => item["display_name"])

            end
            relation.save
            sequence = relation.display_sequence
            sequence += 1
          end
          old_relations.map(&:destroy)
        end
      end

      result = entry_book_details(result.id)
      respond_to do |format|
        format.json {
          render json: result
        }
      end
    else
      raise result.errors.full_messages.to_s
    end
  end


  private
    def entry_book_details(book_id)
      entry_book = Skm::EntryBook.multilingual.with_person.find(book_id)
      entry_book_relations = Skm::EntryBookRelation.order_by_sequence.targets(book_id).index_by(&:target_id)
      relation_headers = Skm::EntryBookRelation.query_headers_by_book(book_id)
      relation_books = Skm::EntryBook.multilingual.with_person.query_books_by_relations(book_id)

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

      result = {:id => entry_book.id,
                :name => entry_book[:name],
                :author_id => entry_book[:created_by],
                :author_name => entry_book[:author_name],
                :author_login_name => entry_book[:author_login_name],
                :project_id => entry_book[:project_id],
                :project_name => entry_book[:project_name],
                :channel_id => entry_book[:channel_id],
                :description => entry_book[:description],
                :updated_at => entry_book[:updated_at],
                :items => []}


      entry_book_relations.values.each do |cr|
        id = cr[:entry_header_id] || cr[:entry_book_id]
        updated_at = cr[:entry_updated_at] || cr[:updated_at]
        created_at = cr[:entry_created_at] || cr[:created_at]

        title = cr[:entry_title] || cr[:name]
        if cr[:relation_type].eql?("ENTRYHEADER")
          published_date = cr[:published_date]
          doc_number = cr[:doc_number]
          result[:items] << {:relation_type => cr[:relation_type], :id => id, :display_name => cr[:display_name], :title => title, :author_name => cr[:author_name],
                             :updated_at => updated_at, :created_at => created_at, :published_date => published_date, :doc_number => doc_number}
        else
          result[:items] << {:relation_type => cr[:relation_type], :id => id, :display_name => cr[:display_name], :title => title, :author_name => cr[:author_name],
                             :updated_at => updated_at, :created_at => created_at}
        end
      end
      result
    end

end