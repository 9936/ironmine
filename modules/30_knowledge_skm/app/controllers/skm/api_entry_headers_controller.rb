class Skm::ApiEntryHeadersController < ApplicationController
  before_filter :set_return_columns

  #获取知识库列表
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
          published.
          current_entry.
          with_favorite_flag(Irm::Person.current.id)

      entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.doc_number", params[:doc_number]) if params[:doc_number]
      entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.keyword_tags", params[:keyword_tags]) if params[:keyword_tags]
      entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.entry_title", params[:entry_title]) if params[:entry_title]
      entry_headers,count = paginate(entry_headers_scope)
    end

    result = {:total_rows => count}
    result[:items] = []

    entry_headers.each do |h|
      result[:items] << {:id => h.id, :is_favorite => h[:is_favorite], :entry_status_code => h[:entry_status_code],
                                :full_title => h[:full_title], :entry_title => h[:entry_title], :keyword_tags => h[:keyword_tags],
                                :doc_number => h[:doc_number], :version_number => h[:version_number] , :published_date => h[:published_date], :type_code => h[:type_code]}
    end

    respond_to do |format|
      format.json {
        render json: result.to_json
      }
    end

  end

  #获取模板
  def get_template_data
    entry_templates_scope = Skm::EntryTemplate.enabled
    entry_templates,count = paginate(entry_templates_scope)

    result = {:total_rows => count}
    result[:items] = []

    entry_templates.each do |et|
      result[:items] << {:id => et.id, :name => et[:name], :description => et[:description]}
    end

    #根据输出参数进行显示
    respond_to do |format|
      format.json {
        render json: result.to_json
      }
    end
  end

  #创建知识
  def add

  end

  #根据知识id获取知识
  def show
    entry_header = Skm::EntryHeader.list_all.find(params[:id])
    entry_header[:details]= entry_header.entry_details.collect {|i| {:element_id => i.id, :element_name => i.element_name, :entry_content => i.entry_content }}


    #根据输出参数进行显示
    respond_to do |format|
      format.json {
        render json: entry_header.to_json(:only => @return_columns)
      }
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
