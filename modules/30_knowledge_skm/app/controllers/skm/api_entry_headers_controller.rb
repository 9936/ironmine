class Skm::ApiEntryHeadersController < ApplicationController
  before_filter :set_return_columns

  #获取知识库列表
  # Request: /api_entry_headers/get_data.json
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
  # Request : /api_entry_headers/get_template_data.json
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

  #获取模板元素
  #Request: /api_entry_headers/get_elements.json
  def get_elements
    entry_elements = Skm::EntryTemplateElement.with_template(params[:template_id])

    result = []
    entry_elements.each do |e|
      result << {:id => e[:detail_id], :name => e[:name], :description => e[:description], :required => e[:detail_required_flag], :rows_num => e[:detail_rows] }
    end
    #根据输出参数进行显示
    respond_to do |format|
      format.json {
        render json: result.to_json(:only => @return_columns)
      }
    end

  end

  #获取知识类别
  #Request: /api_entry_headers/get_columns.json
  def get_columns
    tree_nodes = []
    column_ids = Skm::Column.current_person_accessible_columns
    skm_columns = Skm::Column.multilingual.where("parent_column_id IS NULL OR LENGTH(parent_column_id) = 0")
    skm_columns.each do |sc|
      sc_node = {:id => sc.id, :name => sc[:name], :description => sc[:description], :code => sc.column_code, :children=>[] }

      sc_node[:children] = sc.api_child_nodes(column_ids)
      sc_node.delete(:children) if sc_node[:children].size == 0

      tree_nodes << sc_node
    end
    #根据输出参数进行显示
    respond_to do |format|
      format.json {
        render json: tree_nodes.to_json#(:only => @return_columns)
      }
    end

  end

  #获取知识库频道
  #Request
  def get_channels
    channel_scope = Skm::Channel.query_by_person(Irm::Person.current.id)
    channels,count = paginate(channel_scope)

    result = {:total_rows => count}
    result[:items] = []
    channels.each do |c|
      result[:items] << {:id => c.id, :code => c[:channel_code], :name => c[:name], :description => c[:description]}
    end

    #根据输出参数进行显示
    respond_to do |format|
      format.json {
        render json: result.to_json
      }
    end
  end

  #创建知识
  #Request: /api_entry_headers/add.json
  #"entry_template_id"=>"", "entry_title"=>"", "keyword_tags"=>"", "channel_id"=>"", "content"=>"[\r\n{\"模板元素ID\"=>\"模板元素内容\"}, \r\n{\"模板元素ID\"=>\"模板元素内容\"},\r\n{ \"模板元素ID\"=>模板元素内容\"}\r\n]"}
  def add
    entry_header = Skm::EntryHeader.new(:entry_template_id => params[:entry_template_id],
                                        :entry_title => params[:entry_title],
                                        :keyword_tags => params[:keyword_tags],
                                        :channel_id => params[:channel_id])
    puts "==============#{params[:content]}==================="
    if params[:content].present?
      content_obj = eval(params[:content])
      entry_elements = Skm::EntryTemplateElement.with_template(params[:template_id]).index_by(&:detail_id)
      puts "==================#{entry_elements}===================="
      content_obj.each do |d|
        entry_header.entry_details.build
      end

    end

  end

  #根据知识id获取知识
  #Request: /api_entry_headers/show.json
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
