module Yan::EntryHeadersControllerEx
  def self.included(base)
    base.class_eval do
        def show
          @entry_header = Skm::EntryHeader.list_all.with_favorite_flag(Irm::Person.current.id).find(params[:id])
          @return_url=request.env['HTTP_REFERER']

          @history = Skm::EntryOperateHistory.new({:operate_code=>"SKM_SHOW",
                                                   :entry_id=>params[:id],
                                                   :version_number => @entry_header.version_number})
          @history.save

          @entry_history = Skm::EntryHeader.list_all.where(:doc_number => @entry_header[:doc_number])
          #关联的知识文章
          @entry_relation = Skm::EntryHeaderRelation.list_all(@entry_header.id)

          respond_to do |format|

            if @entry_header.type_code == "VIDEO"
              format.html { redirect_to({:action => "video_show", :id => @entry_header})}
              format.json {render :json=>@entry_header.attributes}
            else
              format.html # show.html.erb
              format.xml  { render :xml => @entry_header }
              format.json {
                @entry_header[:entry_details]=@entry_header.entry_details.collect {|i| i.attributes}

                render :json=>@entry_header.attributes
              }
              format.pdf {
                render :pdf => "[#{@entry_header.doc_number}]#{@entry_header.entry_title}",
                       :print_media_type => true,
                       :encoding => 'utf-8',
                       :layout => "layouts/markdown_pdf.html.erb",
                       :book => true,
                       #:show_as_html => true,
                       :page_size => 'A4',
                       :toc => {
                           :header_text => t(:table_of_contents),
                           :disable_back_links=>true
                       }
              }
            end

          end
        end

        def get_data
          if params[:full_search] && params[:full_search].present?
            #全文检索
            entry_headers = Sunspot.search Skm::EntryHeader do
              keywords params[:full_search]
              with(:entry_status_code, "PUBLISHED")
              with(:history_flag, Irm::Constant::SYS_NO)
              paginate(:page => params[:page] ? params[:page] : 1, :per_page => params[:limit] ? params[:limit] : 10)
            end.results
            count = entry_headers.size
          else
            entry_headers_scope = Skm::EntryHeader.within_accessible_columns(params[:column_id]).
                list_all.
                with_author.
                with_channel.
                published.
                current_entry.
                with_read_num.
                with_favorite_flag(Irm::Person.current.id)
            #entry_headers_scope = entry_headers_scope.with_columns([] << params[:column_id]) if params[:column_id] && params[:column_id].present? && params[:column_id] != "root"
            entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.doc_number",params[:doc_number]) if params[:doc_number]
            entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.keyword_tags",params[:keyword_tags]) if params[:keyword_tags]
            entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.entry_title",params[:entry_title]) if params[:entry_title]
            entry_headers,count = paginate(entry_headers_scope)
          end

          respond_to do |format|
            format.html  {
              @datas = entry_headers
              @count = count
            }
            format.json  {render :json => to_jsonp(entry_headers.to_grid_json([:is_favorite, :entry_status_code, :full_title,
                                                                               :entry_title, :keyword_tags,:doc_number,:version_number,
                                                                               :published_date_f, :type_code], count)) }
          end
        end
    end
  end
end