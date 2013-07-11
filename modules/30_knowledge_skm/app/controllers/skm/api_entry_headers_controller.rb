class Skm::ApiEntryHeadersController < ApiController
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


      entry_headers_scope = entry_headers_scope.with_login_name(params[:author_login_name])  if params[:author_login_name].present?
      entry_headers_scope = entry_headers_scope.with_author_id(params[:author_id]) if params[:author_id].present?
      entry_headers_scope = entry_headers_scope.with_project(params[:project_id]) if params[:project_id].present?


      entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.doc_number", params[:doc_number]) if params[:doc_number]
      entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.keyword_tags", params[:keyword_tags]) if params[:keyword_tags]
      entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.entry_title", params[:entry_title]) if params[:entry_title]
      entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.project_name", params[:project_name]) if params[:project_name]


      entry_headers,count = paginate(entry_headers_scope)
    end

    result = {:total_rows => count}
    result[:items] = []

    entry_headers.each do |h|
      result[:items] << {:id => h.id, :is_favorite => h[:is_favorite], :entry_status_code => h[:entry_status_code],
                                :full_title => h[:full_title], :entry_title => h[:entry_title], :keyword_tags => h[:keyword_tags],
                                :doc_number => h[:doc_number], :version_number => h[:version_number] , :published_date => h[:published_date],
                                :type_code => h[:type_code], :author_name => h[:author_name]}
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
                                        :channel_id => params[:channel_id],
                                        :source_id => params[:project_id])

    enable_entry_audit=Irm::SystemParametersManager.enable_skm_header_audit
    #读取当前系统中的审批设置
    #不需要审批直接发布
    if enable_entry_audit.eql? Irm::Constant::SYS_NO
      entry_header.entry_status_code = "PUBLISHED" if params[:status] && params[:status] == "PUBLISHED"
      #需要审批判断当前知识频道的审批人，如果返回false则自动发布
    else
      approval_people = Skm::ChannelApprovalPerson.approval_people(params[:channel_id])
      approval_people.delete_if{|i| i[:person_id] == Irm::Person.current.id }
      if approval_people.any?
        entry_header.entry_status_code = "WAIT_APPROVE" if params[:status] && params[:status] == "PUBLISHED"
      else
        entry_header.entry_status_code = "PUBLISHED" if params[:status] && params[:status] == "PUBLISHED"
      end
    end

    entry_header.entry_status_code = "DRAFT" if params[:status] && params[:status] == "DRAFT"
    entry_header.published_date = Time.now
    entry_header.doc_number = Skm::EntryHeader.generate_doc_number
    entry_header.version_number = entry_header.next_version_number
    entry_header.author_id = Irm::Person.current.id
    entry_header.type_code = "ARTICLE"

    details = get_details

    if details.present? && details.any?
      details.each do |d|
        entry_header.entry_details.build({:element_name => d["element_name"],
                                          :entry_template_element_id => d["entry_template_element_id"],
                                          :entry_content => d["entry_content"]})
      end
      if entry_header.save
        entry_header[:project_id] = entry_header.source_id
        entry_header[:details]= entry_header.entry_details.collect {|i| {:element_id => i.id, :element_name => i.element_name, :entry_content => i.entry_content }}
        #根据输出参数进行显示
        respond_to do |format|
          format.json {
            render json: entry_header.to_json(:only => @return_columns)
          }
        end
      else
        raise entry_header.errors.full_messages.to_s
      end
    else
      raise "details can't be blank."
    end

  end

  #编辑知识
  #Request: /api_entry_headers/update.json
  def update
    if params[:new_version_flag].present? && params[:new_version_flag].eql?('Y')
      old_header = Skm::EntryHeader.find(params[:id])
      entry_header = Skm::EntryHeader.new(old_header.attributes)
      old_header.history_flag = "Y"
      entry_header.history_flag = "N"
      enable_entry_audit = Irm::SystemParametersManager.enable_skm_header_audit
      if enable_entry_audit.eql? Irm::Constant::SYS_NO
        entry_header.entry_status_code = "PUBLISHED" if params[:status] && params[:status] == "PUBLISHED"
      else
        approval_people = Skm::ChannelApprovalPerson.approval_people(params[:channel_id])
        approval_people.delete_if{|i| i[:person_id] == Irm::Person.current.id }
        if approval_people.any?
          entry_header.entry_status_code = "WAIT_APPROVE" if params[:status] && params[:status] == "PUBLISHED"
        else
          entry_header.entry_status_code = "PUBLISHED" if params[:status] && params[:status] == "PUBLISHED"
        end
      end
      entry_header.entry_status_code = "DRAFT" if params[:status] && params[:status] == "DRAFT"
      entry_header.version_number = old_header.next_version_number.to_s
      entry_header.published_date = Time.now
      entry_header.author_id = old_header.author_id
      entry_header.source_type = old_header.source_type
      entry_header.source_id = old_header.source_id

      if old_header.save && entry_header.save
        entry_header.source_id = params[:project_id]
        entry_header.entry_title = params[:entry_title]
        entry_header.keyword_tags = params[:keyword_tags]
        entry_header.channel_id = params[:channel_id]

        details = get_details
        if details.present? && details.any?
          details.each do |d|
            id = d["element_id"] || d["entry_template_element_id"]
            detail = Skm::EntryDetail.where("entry_header_id=? AND id=?", entry_header.id ,id).first
            detail.update_attributes({:element_name => d["element_name"], :entry_content => d["entry_content"]}) if detail
          end
        end
        #更新 收藏 中的ID为最新的文章ID，保证收藏的永远是知识库文章的最新版本
        fas = Skm::EntryFavorite.where(:entry_header_id => old_header.id)
        fas.each do |fa|
          fa.update_attribute(:entry_header_id, @entry_header.id)
        end
        #同步专题中的知识到最新版本
        Skm::EntryBookRelation.merge_headers(old_header.id, entry_header.id)
        #同步关联的知识
        header_relations = Skm::EntryHeaderRelation.with_created_by.list_all(old_header.id)
        header_relations.each do |hr|
          target_id = (hr.source_id == old_header.id)? hr.target_id : hr.source_id
          Skm::EntryHeaderRelation.create(:source_id => entry_header.id, :target_id => target_id, :relation_type => hr.relation_type, :created_by => hr.created_by)
        end
        unless entry_header.save
          raise entry_header.errors.full_messages.to_s
        end

      end

    else
      #直接更新原有知识
      entry_header = Skm::EntryHeader.find(params[:id])
      entry_header.source_id = params[:project_id]
      entry_header.entry_title = params[:entry_title]
      entry_header.keyword_tags = params[:keyword_tags]
      entry_header.channel_id = params[:channel_id]

      details = get_details
      if details.present? && details.any?
        details.each do |d|
          id = d["element_id"] || d["entry_template_element_id"]
          detail = Skm::EntryDetail.where("entry_header_id=? AND id=?", entry_header.id ,id).first
          detail.update_attributes({:element_name => d["element_name"], :entry_content => d["entry_content"]}) if detail
        end
      end
      unless entry_header.save
        raise entry_header.errors.full_messages.to_s
      end

    end


    entry_header[:project_id] = entry_header.source_id
    entry_header[:details]= entry_header.entry_details.collect {|i| {:element_id => i.id, :element_name => i.element_name, :entry_content => i.entry_content }}
    #根据输出参数进行显示
    respond_to do |format|
      format.json {
        render json: entry_header.to_json(:only => @return_columns)
      }
    end

  end

  #根据知识id获取知识
  #Request: /api_entry_headers/show.json
  def show
    entry_header = Skm::EntryHeader.list_all.find(params[:id])
    entry_header[:project_id] = entry_header.source_id

    entry_header[:details]= entry_header.entry_details.collect {|i| {:element_id => i.id, :element_name => i.element_name, :entry_content => i.entry_content }}

    #根据输出参数进行显示
    respond_to do |format|
      format.json {
        render json: entry_header.to_json(:only => @return_columns)
      }
    end
  end


  private

    def get_details
      if params[:details].present?
        begin
          details = ActiveSupport::JSON.decode(params[:details])
        rescue
          details = nil
        end
      else
        details = nil
      end
      details
    end
end
