class Skm::EntryHeadersController < ApplicationController
  layout "bootstrap_application_full"
  def index
      session[:skm_entry_header] = nil
      session[:skm_entry_details] = nil
      session[:skm_entry_attachments] = nil
    @entry_header = Skm::EntryHeader.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @entry_header }
    end
  end

  def show
    @entry_header = Skm::EntryHeader.list_all.with_favorite_flag(Irm::Person.current.id).find(params[:id])
    @return_url=request.env['HTTP_REFERER']

    @history = Skm::EntryOperateHistory.new({:operate_code=>"SKM_SHOW",
                                             :entry_id=>params[:id],
                                             :version_number => @entry_header.version_number})
    @history.save

    @entry_history = Skm::EntryHeader.list_all.history_entry.where(:doc_number => @entry_header[:doc_number])
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
                         :layout => 'layouts/pdf.html.erb',
                         :book => true,
                         :page_size => 'A4',
                         :toc => {
                             :depth => 3,
                             :header_text => t(:table_of_contents) }
        }
      end

    end
  end

  def new
    if session[:skm_entry_header]
      session[:skm_entry_header].merge!(params[:skm_entry_header]) if params[:skm_entry_header]
    else
      session[:skm_entry_header] = (params[:skm_entry_header]) if params[:skm_entry_header]
    end

    if session[:skm_entry_details]
      session[:skm_entry_details].merge!(params[:skm_entry_details]) if params[:skm_entry_details]
    else
      session[:skm_entry_details] = (params[:skm_entry_details]) if params[:skm_entry_details]
    end

    if !params[:step]
      session[:skm_entry_header] = nil
      session[:skm_entry_details] = nil
      session[:skm_entry_attachments] = nil
    end
    if !params[:step] || params[:step] == "1"
      respond_to do |format|
        format.html { redirect_to({:action=>"new_step_1"}) }
      end    
    elsif params[:step] == "2"
      respond_to do |format|
        format.html { redirect_to({:action=>"new_step_2"}) }
      end
    elsif params[:step] == "3"
    #获取所有附件
      respond_to do |format|
        format.html { redirect_to({:action=>"new_step_3"}) }
      end
    elsif params[:step] == "4"
      files = params[:files]
      #调用方法创建附件
      file_flag = true
      now = 0
      params[:files].each_value do |att|
        file = att["file"]
        next unless file && file.size > 0
        file_flag, now = Irm::AttachmentVersion.validates?(file, Irm::SystemParametersManager.upload_file_limit)
        break unless file_flag
      end

      if !file_flag
        flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
        respond_to do |format|
          format.html { redirect_to :action => "new_step_3" }
        end
      else
        attached = Irm::AttachmentVersion.create_verison_files(files, "Skm::EntryHeader", -1)
        t = session[:skm_entry_attachments]
        (session[:skm_entry_attachments] = (t ? t : []) + attached.collect(&:id)) if attached
        respond_to do |format|
          format.html { redirect_to({:action=>"new_step_4"}) }
        end
      end
    end
  end

  def new_step_video_upload
    @entry_header = Skm::EntryHeader.new
  end

  def new_step_1
    @entry_header = Skm::EntryHeader.new
    if session[:skm_entry_header]
      session[:skm_entry_header].each do |k, v|
        @entry_header[k.to_sym] = v
      end
    end
    @templates = Skm::EntryTemplate.enabled
  end
  
  def new_step_2
    @entry_header = Skm::EntryHeader.new
    if !session[:skm_entry_header] || !session[:skm_entry_header][:entry_template_id]
      @templates = Skm::EntryTemplate.enabled
      @entry_header.errors.add(:entry_template_id, t(:error_choice_template))
      respond_to do |format|
        format.html { render :action => "new_step_1" }
        format.xml  { render :xml => @entry_header.errors, :status => :unprocessable_entity }
      end
    else
      session[:skm_entry_header].each do |k, v|
        @entry_header[k.to_sym] = v
      end
#      @entry_header.column_ids = session[:skm_entry_header][:column_ids] if session[:skm_entry_header][:column_ids].present?
      @elements = Skm::EntryTemplateDetail.owned_elements(@entry_header.entry_template_id)
    end
  end  

  def new_step_3
    @entry_header = Skm::EntryHeader.new
    session[:skm_entry_header].each do |k, v|
      @entry_header[k.to_sym] = v
    end
    @entry_details = []
    @error_details = []

    #验证上一步的输入正确性
    content_validate_flag = true
    session[:skm_entry_details].each do |k, v|
      t = Skm::EntryDetail.new(v)
      @entry_details << t
      if !t.valid?
        (content_validate_flag = false )
        @error_details << k
      end
    end
    unless @entry_header.valid? && content_validate_flag
      @elements = Skm::EntryTemplateDetail.owned_elements(@entry_header.entry_template_id)
      respond_to do |format|
        format.html { render :action => "new_step_2" }
        format.xml  { render :xml => @entry_header.errors, :status => :unprocessable_entity }
      end
    end

    if session[:skm_entry_attachments] && session[:skm_entry_attachments].size > 0
      @attachments = Irm::Attachment.list_all.where("latest_version_id IN (?)", session[:skm_entry_attachments])
    end
#    3.times { @entry_header.entry_subjects.build }
  end

  def new_step_4
#    @entry_header = Skm::EntryHeader.new
#    session[:skm_entry_header].each do |k, v|
#      @entry_header[k.to_sym] = v
#    end
#    @entry_subject = Skm::EntrySubject.new

    @entry_header = Skm::EntryHeader.new
    session[:skm_entry_header].each do |k, v|
      @entry_header[k.to_sym] = v
    end
    @entry_details = []
    session[:skm_entry_details].each do |k, v|
      t = Skm::EntryDetail.new(v)
      @entry_details << t
    end

    content_validate_flag = true
    @entry_details.each do |ed|
      (content_validate_flag = false ) if !ed.valid?
    end
    unless @entry_header.valid? && content_validate_flag
      @elements = Skm::EntryTemplateDetail.owned_elements(@entry_header.entry_template_id)
      respond_to do |format|
        format.html { render :action => "new_step_3" }
        format.xml  { render :xml => @entry_header.errors, :status => :unprocessable_entity }
      end
    end
#    3.times { @entry_header.entry_subjects.build }
#    @entry_subject = Skm::EntrySubject.new
  end

  def edit
    @entry_header = Skm::EntryHeader.find(params[:id])
#    @entry_header.column_ids = @entry_header.get_column_ids
    @return_url=request.env['HTTP_REFERER'] if @return_url
    respond_to do |format|

      if @entry_header.type_code == "VIDEO"
        format.html { redirect_to({:action => "video_edit", :id => @entry_header})}
      else
        format.html # show.html.erb
        format.xml  { render :xml => @entry_header }
      end
    end
  end

  #新建关联知识
  def new_relation
    @entry_header = Skm::EntryHeader.find(params[:id])
    @return_url=request.env['HTTP_REFERER'] if @return_url
    respond_to do |format|
      format.html #new_relation.html.erb
    end
  end

  def create_relation
    return_url = params[:return_url]
    file_flag = true
    now = 0
    params[:files].each_value do |att|
      file = att["file"]
      next unless file && file.size > 0
      file_flag, now = Irm::AttachmentVersion.validates?(file, Irm::SystemParametersManager.upload_file_limit)
      if !file_flag
        flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
        break
      end
    end if params[:files]
    if file_flag
      #查找出原有的知识文章并将其已有的属性进行复制
      old_header = Skm::EntryHeader.find(params[:id])
      @entry_header = Skm::EntryHeader.new(old_header.attributes)
      @entry_header.history_flag = "N"
      enable_entry_audit = Irm::SystemParametersManager.enable_skm_header_audit
      if enable_entry_audit.eql? Irm::Constant::SYS_NO
        @entry_header.entry_status_code = "PUBLISHED"
      else
        approval_people = Skm::ChannelApprovalPerson.approval_people(params[:skm_entry_header][:channel_id])
        if approval_people.any?
          @entry_header.entry_status_code = "WAIT_APPROVE"
        else
          @entry_header.entry_status_code = "PUBLISHED"
        end
      end
      #更新知识库的标题和id
      @entry_header.entry_title = params[:skm_entry_header][:entry_title]
      @entry_header.id = nil
      @entry_header.entry_status_code = "DRAFT" if params[:status] && params[:status] == "DRAFT"
      @entry_header.doc_number = Skm::EntryHeader.generate_doc_number
      @entry_header.version_number = "1" #此处直接设置为1
      @entry_header.published_date = Time.now
      @entry_header.created_at = Time.now
      @entry_header.author_id = old_header.author_id
      @entry_header.source_type = old_header.source_type
      @entry_header.source_id = old_header.source_id

      respond_to do |format|
        if @entry_header.save &&  @entry_header.update_attributes(params[:skm_entry_header])
          params[:skm_entry_details].each do |k, v|
            old_detail = Skm::EntryDetail.find(k)
            detail = Skm::EntryDetail.new(old_detail.attributes)
            detail.entry_header_id = @entry_header.id
            detail.created_at = Time.now
            detail.update_attributes(v)
            @entry_header.entry_details << detail
          end
          if !approval_people.nil? && approval_people.any?
            approval_people.each do |person|
              Skm::EntryApprovalPerson.create(:entry_header_id => @entry_header.id, :person_id => person[:person_id])
            end
          end
          #创建关联关系
          params[:relation_type] ||= 'RELATION'
          Skm::EntryHeaderRelation.create(:source_id => old_header.id, :target_id => @entry_header.id, :relation_type => params[:relation_type])
          #附件内容关联知识库
          if params[:files]
            files = params[:files]
            #调用方法创建附件
            begin
              attached = Irm::AttachmentVersion.create_verison_files(files, Skm::EntryHeader.name, @entry_header.id)
            rescue
              @entry_header.errors << "FILE UPLOAD ERROR"
            end
          end
          format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
        else
          @entry_header.id = params[:id]
          format.html { render :action => "new_relation" }
        end
      end
    else
      @entry_header.id = params[:id]
      @elements = Skm::EntryTemplateDetail.owned_elements(old_header.entry_template_id)
      if session[:skm_entry_details]
        session[:skm_entry_details].merge!(params[:skm_entry_details]) if params[:skm_entry_details]
      else
        session[:skm_entry_details] = (params[:skm_entry_details]) if params[:skm_entry_details]
      end
      format.html { render :action => "new_relation"}
    end

  end

  def create
    if params[:format].eql?("json")
      session[:skm_entry_header]=params[:skm_entry_header]
      session[:skm_entry_details]=params[:skm_entry_details]
    end
    @entry_header = Skm::EntryHeader.new
    session[:skm_entry_header].each do |k, v|
      @entry_header[k.to_sym] = v
    end
    session[:skm_entry_details].each do |k, v|
      t = Skm::EntryDetail.new(v)
      @entry_header.entry_details << t
    end
    enable_entry_audit=Irm::SystemParametersManager.enable_skm_header_audit
    #读取当前系统中的审批设置
    #不许需要审批直接发布
    if enable_entry_audit.eql? Irm::Constant::SYS_NO
      @entry_header.entry_status_code = "PUBLISHED" if params[:status] && params[:status] == "PUBLISHED"
    #需要审批判断当前知识频道的审批人，如果返回false则自动发布
    else
      approval_people = Skm::ChannelApprovalPerson.approval_people(session[:skm_entry_header][:channel_id])
      if approval_people.any?
        @entry_header.entry_status_code = "WAIT_APPROVE" if params[:status] && params[:status] == "PUBLISHED"
      else
        @entry_header.entry_status_code = "PUBLISHED" if params[:status] && params[:status] == "PUBLISHED"
      end
    end

    @entry_header.entry_status_code = "DRAFT" if params[:status] && params[:status] == "DRAFT"
    @entry_header.published_date = Time.now
    @entry_header.doc_number = Skm::EntryHeader.generate_doc_number
    @entry_header.version_number = @entry_header.next_version_number
    @entry_header.author_id = Irm::Person.current.id
    @entry_header.type_code = "ARTICLE"
    respond_to do |format|
      if @entry_header.save
        if !approval_people.nil? && approval_people.any?
          approval_people.each do |person|
            Skm::EntryApprovalPerson.create(:entry_header_id => @entry_header.id, :person_id => person[:person_id])
          end
        end
        #关联创建过程中关联的文件
        if session[:skm_entry_attachments] && session[:skm_entry_attachments].size > 0
          attachments = Irm::AttachmentVersion.where("id IN (?)", session[:skm_entry_attachments])
          attachments.each do |at|
            at.update_attribute(:source_id, @entry_header.id)
          end
        end
        session[:skm_entry_header] = nil
        session[:skm_entry_details] = nil
        session[:skm_entry_attachments] = nil
        if params[:status] == "DRAFT"
          format.html { redirect_to({:action=>"my_drafts"}, :notice =>t(:successfully_created)) }
        else
          format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }

        end
        format.json { render :json=>@entry_header.attributes}
        format.xml  { render :xml => @entry_header, :status => :created, :location => @entry_header }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entry_header.errors, :status => :unprocessable_entity }
        format.json { render :json => @entry_header.errors}
      end
    end
  end

  def video_create
    @entry_header = Skm::EntryHeader.new(params[:skm_entry_header])
    @entry_header.entry_template_id = -1
    enable_entry_audit = Irm::SystemParametersManager.enable_skm_header_audit
    if enable_entry_audit.eql? Irm::Constant::SYS_NO
      @entry_header.entry_status_code = "PUBLISHED"
    else
      approval_people = Skm::ChannelApprovalPerson.approval_people(@entry_header.channel_id)
      if approval_people.any?
        @entry_header.entry_status_code = "WAIT_APPROVE"
      else
        @entry_header.entry_status_code = "PUBLISHED"
      end
    end

    @entry_header.published_date = Time.now
    @entry_header.doc_number = Skm::EntryHeader.generate_doc_number
    @entry_header.version_number = @entry_header.next_version_number
    @entry_header.author_id = Irm::Person.current.id
    @entry_header.type_code = "VIDEO"
    temp_uniq_id = UUID.generate(:compact)[0, 21]
    val, now = Irm::AttachmentVersion.validates?(params[:skm_video])
    video = nil
    if val && @entry_header.valid?
      video = Irm::AttachmentVersion.create_single_version_file(params[:skm_video],
                                                        params[:skm_video_description],
                                                        Irm::LookupValue.get_code_id("SKM_FILE_CATEGORIES", "VIDEO"),
                                                        Skm::EntryHeader.name,
                                                        temp_uniq_id) #if params[:skm_video] && params[:skm_video].present?
    elsif !val
      flash[:error] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
    elsif !params[:skm_video]
      flash[:error] = I18n.t(:label_skm_entry_video_upload_error)
    end
    respond_to do |format|
      if val && video && @entry_header.save
        @entry_header.update_attribute(:relation_id, video.attachment_id)
        video.update_attribute(:source_id, @entry_header.id)
        if !approval_people.nil? && approval_people.any?
          approval_people.each do |person|
            Skm::EntryApprovalPerson.create(:entry_header_id => @entry_header.id, :person_id => person[:person_id])
          end
        end
        format.html { redirect_to({:action => "video_show", :id => @entry_header.id})}
      else
        @video_description = params[:skm_video_description]
        video.attachment.destroy unless video.nil?
        format.html { render :action => "new_step_video_upload"}
      end
    end
  end

  def video_edit
    @entry_header = Skm::EntryHeader.list_all.with_favorite_flag(Irm::Person.current.id).find(params[:id])
    @video = Irm::Attachment.find(@entry_header.relation_id).last_version_entity
  end

  def video_update
    @entry_header = Skm::EntryHeader.find(params[:id])
    @video = Irm::Attachment.find(@entry_header.relation_id).last_version_entity

    temp_uniq_id = UUID.generate(:compact)[0, 21]
    file_succ = true
    if @entry_header.valid? &&  params[:skm_video] && !params[:skm_video].nil?
      val, now = Irm::AttachmentVersion.validates?(params[:skm_video])
      if val
        new_video = Irm::AttachmentVersion.create_single_version_file(params[:skm_video],
                                                            params[:skm_video_description],
                                                            Irm::LookupValue.get_code_id("SKM_FILE_CATEGORIES", "VIDEO"),
                                                            Skm::EntryHeader.name,
                                                            temp_uniq_id) if params[:skm_video] && params[:skm_video].present?
        unless new_video.nil?
          @video.destroy
          @video = new_video
        end
      else
        flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
        file_succ = false
      end
    else
      #只更新视频描述
      @video.update_attribute(:description, params[:skm_video_description])
      Irm::AttachmentVersion.update_attachment_by_version(@video.attachment, @video)
    end
    atts = params[:skm_entry_header].merge({:relation_id => @video.attachment_id})
    respond_to do |format|
      if file_succ && !@entry_header.errors.any? && @entry_header.update_attributes(atts)

        format.html { redirect_to({:action => "video_show", :id => params[:id]})}
      else
        format.html { render :action => "video_edit"}
      end
    end
  end

  def video_show
    @entry_header = Skm::EntryHeader.list_all.with_favorite_flag(Irm::Person.current.id).find(params[:id])
    @video = Irm::Attachment.find(@entry_header.relation_id).last_version_entity

    @history = Skm::EntryOperateHistory.new({:operate_code=>"SKM_SHOW",
                                             :entry_id=>params[:id],
                                             :version_number => @entry_header.version_number})
    @history.save
    @entry_history = Skm::EntryHeader.list_all.history_entry.where(:doc_number => @entry_header[:doc_number])
    #关联的知识文章
    @entry_relation = Skm::EntryHeaderRelation.list_all(@entry_header.id)
    respond_to do |format|
      format.html
    end
  end

  def update
    return_url = params[:return_url]
    file_flag = true
    now = 0
    params[:files].each_value do |att|
      file = att["file"]
      next unless file && file.size > 0
      file_flag, now = Irm::AttachmentVersion.validates?(file, Irm::SystemParametersManager.upload_file_limit)
      if !file_flag
        flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
        break
      end
    end if params[:files]

    if file_flag
      if params[:new]
        old_header = Skm::EntryHeader.find(params[:id])
        @entry_header = Skm::EntryHeader.new(old_header.attributes)
        old_header.history_flag = "Y"
        @entry_header.history_flag = "N"
        enable_entry_audit = Irm::SystemParametersManager.enable_skm_header_audit
        if enable_entry_audit.eql? Irm::Constant::SYS_NO
          @entry_header.entry_status_code = "PUBLISHED" if params[:status] && params[:status] == "PUBLISHED"
        else
          approval_people = Skm::ChannelApprovalPerson.approval_people(params[:skm_entry_header][:channel_id])
          if approval_people.any?
            @entry_header.entry_status_code = "WAIT_APPROVE" if params[:status] && params[:status] == "PUBLISHED"
          else
            @entry_header.entry_status_code = "PUBLISHED" if params[:status] && params[:status] == "PUBLISHED"
          end
        end

        @entry_header.entry_status_code = "DRAFT" if params[:status] && params[:status] == "DRAFT"
        @entry_header.version_number = old_header.next_version_number.to_s
        @entry_header.published_date = Time.now
        @entry_header.author_id = old_header.author_id
        @entry_header.source_type = old_header.source_type
        @entry_header.source_id = old_header.source_id
        respond_to do |format|
          if old_header.save && @entry_header.save &&  @entry_header.update_attributes(params[:skm_entry_header])
            params[:skm_entry_details].each do |k, v|
              old_detail = Skm::EntryDetail.find(k)
              detail = Skm::EntryDetail.new(old_detail.attributes)
              detail.update_attributes(v)
              @entry_header.entry_details << detail
            end
            if !approval_people.nil? && approval_people.any?
              approval_people.each do |person|
                Skm::EntryApprovalPerson.create(:entry_header_id => @entry_header.id, :person_id => person[:person_id])
              end
            end
            #更新 收藏 中的ID为最新的文章ID，保证收藏的永远是知识库文章的最新版本
            fas = Skm::EntryFavorite.where(:entry_header_id => old_header.id)
            fas.each do |fa|
              fa.update_attribute(:entry_header_id, @entry_header.id)
            end
            if params[:files]
              files = params[:files]
              #调用方法创建附件
              begin
                attached = Irm::AttachmentVersion.create_verison_files(files, Skm::EntryHeader.name, @entry_header.id)
              rescue
                @entry_header.errors << "FILE UPLOAD ERROR"
              end
            end
            if return_url.blank?
              format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
              format.xml  { render :xml => @entry_header, :status => :created, :location => @entry_header }
            else
              format.html { redirect_to(return_url, :notice =>t(:successfully_created)) }
              format.xml  { render :xml => @entry_header, :status => :created, :location => @entry_header }
            end
            format.json {render :json=>@entry_header}
          else
            if @entry_header.new_record?
              @entry_header.id = old_header.id
            else
              @entry_header.destroy
              @entry_header = old_header
            end
            format.html { render :action => "edit" }
            format.xml  { render :xml => @entry_header.errors, :status => :unprocessable_entity }
            format.json {render :json=>@entry_header.errors}
          end
        end
      else
        @entry_header = Skm::EntryHeader.find(params[:id])
  #      @entry_header.entry_status_code = "PUBLISHED" if params[:status] && params[:status] == "PUBLISHED"
  #      @entry_header.entry_status_code = "DRAFT" if params[:status] && params[:status] == "DRAFT"
        respond_to do |format|
          if @entry_header.update_attributes(params[:skm_entry_header]) &&
              @entry_header.update_attribute( :entry_status_code, params[:status])
            params[:skm_entry_details].each do |k, v|
              detail = Skm::EntryDetail.find(k)
              detail.update_attributes(v)
            end
#            column_ids.each do |t|
#              Skm::EntryColumn.create(:entry_header_id => @entry_header.id, :column_id => t)
#            end
            if params[:files]
              files = params[:files]
              #调用方法创建附件
              begin
                attached = Irm::AttachmentVersion.create_verison_files(files, Skm::EntryHeader.name, @entry_header.id)
              rescue
                @entry_header.errors << "FILE UPLOAD ERROR"
              end
            end


            if return_url.blank?
              format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
              format.xml  { head :ok }
            else
              format.html { redirect_to(return_url, :notice =>t(:successfully_created)) }
              format.xml  { render :xml => @entry_header, :status => :created, :location => @entry_header }
            end
            format.json {render :json=>@entry_header}
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @entry_header.errors, :status => :unprocessable_entity }
            format.json {render :json=>@entry_header.errors}
          end
        end
      end
    else
      format.html { render :action => "edit"}
      format.xml  { render :xml => @entry_header.errors, :status => :unprocessable_entity }
      format.json {render :json=>@entry_header.errors}
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
      entry_headers_scope = Skm::EntryHeader.
        list_all.
        published.
        current_entry.
        with_favorite_flag(Irm::Person.current.id)
        entry_headers_scope = entry_headers_scope.with_columns([] << params[:column_id]) if params[:column_id] && params[:column_id].present? && params[:column_id] != "root"
        entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.doc_number",params[:doc_number]) if params[:doc_number]
        entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.keyword_tags",params[:keyword_tags]) if params[:keyword_tags]
        entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.entry_title",params[:entry_title]) if params[:entry_title]
        entry_headers,count = paginate(entry_headers_scope)
    end

    respond_to do |format|
      format.html  {
        @datas = entry_headers
        @count = entry_headers.count
      }
      format.json  {render :json => to_jsonp(entry_headers.to_grid_json([:is_favorite, :entry_status_code, :full_title,
                                                                         :entry_title, :keyword_tags,:doc_number,:version_number,
                                                                         :published_date_f, :type_code], count)) }
    end
  end

  def get_history_entries_data
    entry_histories_scope = Skm::EntryHeader.list_all.history_entry.where(:doc_number => params[:doc_number])
    entry_histories,count = paginate(entry_histories_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(entry_histories.to_grid_json(['0',:entry_status_code, :full_title, :entry_title, :keyword_tags,:doc_number,:version_number, :published_date_f], count)) }
    end    
  end

  def index_search
    @search_value = params[:search_value]
  end

  def index_search_get_data
    entry_headers_scope = Skm::EntryHeader.list_all.published.current_entry
    entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.entry_title",params[:search_value]) if params[:search_value]
    entry_headers,count = paginate(entry_headers_scope)

    if  !params[:search_value].nil? then
         @history = Skm::EntryOperateHistory.new({:operate_code=>"SKM_SEARCH",
                                                  :incident_id=>@incident_request.id ,
                                                  :search_key=>params[:search_value],
                                                  :result_count=>count});
         @history.save;
    end

    respond_to do |format|
      format.json  {render :json => to_jsonp(entry_headers.to_grid_json(['0',:entry_status_code, :full_title, :entry_title, :keyword_tags,:doc_number,:version_number, :published_date], count)) }
    end
  end

  def my_favorites_data
    entry_headers_scope = Skm::EntryHeader.list_all.my_favorites(params[:person_id]).published.current_entry
    entry_headers_scope = entry_headers_scope.with_columns(([] << params[:column_id]) & Skm::Column.current_person_accessible_columns) if params[:column_id] && params[:column_id].present? && params[:column_id] != "root"
    entry_headers,count = paginate(entry_headers_scope)
    respond_to do |format|
      format.html  {
        @datas = entry_headers
        @count = count
      }
      format.json  {render :json => to_jsonp(entry_headers.to_grid_json(['0',:entry_status_code, :type_code, :full_title, :entry_title, :keyword_tags,:doc_number,:version_number, :published_date_f], count)) }
    end    
  end

  def my_favorites

  end

  def add_favorites
    favorite = Skm::EntryFavorite.new({:person_id => params[:person_id], :entry_header_id => params[:id]})
    respond_to do |format|
      if favorite.save
        format.html { redirect_to(:action => "my_favorites") }
        format.xml  { head :ok }
      else
        format.html { redirect_to(:action => "index") }
      end
    end
  end

  def data_grid
    render :layout => nil
  end

  def remove_favorite
    favorite = Skm::EntryFavorite.where(:person_id => params[:person_id], :entry_header_id => params[:entry_header_id]).first
    favorite.destroy
    respond_to do |format|
      format.html { redirect_to(:action => "my_favorites") }
      format.xml  { head :ok }
    end
  end

  def my_drafts

  end

  def my_drafts_data
    entry_headers_scope = Skm::EntryHeader.list_all.my_drafts(params[:person_id])
    entry_headers,count = paginate(entry_headers_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(entry_headers.to_grid_json(['0',:entry_status_code, :full_title, :entry_title, :keyword_tags,:doc_number,:version_number, :published_date], count)) }
    end        
  end

  def my_unpublished

  end
  def my_unpublished_data
    entry_headers_scope = Skm::EntryHeader.list_all.with_entry_status.current_entry.my_unpublished(params[:person_id])
    entry_headers_scope = entry_headers_scope.with_columns(([] << params[:column_id]) & Skm::Column.current_person_accessible_columns) if params[:column_id] && params[:column_id].present? && params[:column_id] != "root"
    entry_headers,count = paginate(entry_headers_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(entry_headers.to_grid_json(['0',:entry_status_code,:entry_status_name, :full_title, :entry_title, :keyword_tags,:doc_number,:version_number, :published_date], count)) }
      format.html  {
        @datas = entry_headers
        @count = entry_headers.count
      }
    end
  end

  def wait_my_approve

  end
  def wait_my_approve_data
    entry_headers_scope = Skm::EntryHeader.list_all.with_author.current_entry.with_entry_status.wait_my_approve
    entry_headers_scope = entry_headers_scope.with_columns(([] << params[:column_id]) & Skm::Column.current_person_accessible_columns) if params[:column_id] && params[:column_id].present? && params[:column_id] != "root"
    entry_headers,count = paginate(entry_headers_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(entry_headers.to_grid_json(['0',:author_name,:entry_status_code,:entry_status_name, :full_title, :entry_title, :keyword_tags,:doc_number,:version_number, :published_date], count)) }
      format.html  {
        @datas = entry_headers
        @count = entry_headers.count
      }
    end
  end

  def approve_knowledge

     entry_header_ids=params[:entry_header_ids].split(",")   #将隐藏域传入进来ID转换成数组
     entry_header_ids.compact                     #去掉nil
     if(entry_header_ids.size>0)
        if(params[:commit].eql?(I18n.t(:label_action_approve)))    #如果通过
          #检查该知识是否还有人未审核
          entry_header_ids.each do |entry_header_id|
            entry_approval_person = Skm::EntryApprovalPerson.where("person_id=? AND entry_header_id=?", Irm::Person.current.id, entry_header_id)
            entry_approval_person.update_all("approval_flag" => Irm::Constant::SYS_YES)
            unless Skm::EntryApprovalPerson.has_unaudited_person?(entry_header_id)
              Skm::EntryHeader.where("id=?", entry_header_id).update_all(:entry_status_code=>"PUBLISHED") #更新为发布状态
            end
          end
        elsif(params[:commit].eql?(I18n.t(:label_action_reject)))    #如果拒绝
          Skm::EntryHeader.where(:id=>entry_header_ids).update_all(:entry_status_code=>"APPROVE_DENY")   #更新为审核拒绝状态
        end
     end
     respond_to do |format|
       format.js
     end

  end

  def new_from_icm_request
    incident_request = Icm::IncidentRequest.list_all.where("#{Icm::IncidentRequest.table_name}.id = ?", params[:request_id]).first()
    template = Skm::EntryTemplate.where(:entry_template_code => "ENTRY_FROM_ICM_REQUEST_" + I18n.locale.to_s.upcase).first()
    elements = Skm::EntryTemplateDetail.owned_elements(template.id)

    session[:skm_entry_header] = {:entry_title => incident_request.title,
                                  :doc_number => Skm::EntryHeader.generate_doc_number,
                                  :entry_template_id => template.id,
                                  :history_flag => "N",
                                  :entry_status_code => "DRAFT",
                                  :published_date => Time.now,
                                  :author_id => Irm::Person.current.id,
                                  :version_number => 1,
                                  :source_type=> Icm::IncidentRequest.name,
                                  :source_id => incident_request.id}

    @entry_header = Skm::EntryHeader.new
    if session[:skm_entry_header]
      session[:skm_entry_header].each do |k, v|
        @entry_header[k.to_sym] = v
      end
    end
    session[:skm_entry_details] = {}
    elements.each do |e|
      if e.entry_template_element_code.include?("INCIDENT_REQUEST_INFO_")
        session[:skm_entry_details].merge!({e.id.to_sym =>
            {:entry_content =>Irm::Sanitize.sanitize(incident_request.summary.gsub(/<(br)(| [^>]*)>/i, "\n"),""),
             :default_rows => e.default_rows,
             :entry_template_element_id => e.id,
             :element_name => e.element_name,
             :required_flag=> e.required_flag,
             :line_num=>e.line_num,
             :status_code=>"ENABLED"}}
        )
      elsif e.entry_template_element_code.include?("INCIDENT_REQUEST_INSTANCE_")
        session[:skm_entry_details].merge!({e.id.to_sym =>{
            :entry_content => I18n::t(:label_incident_request) + ": " + incident_request.request_number + " ; " + I18n::t(:label_icm_incident_request_title) + ": " + incident_request.title,
             :default_rows => e.default_rows,
             :entry_template_element_id => e.id,
             :element_name => e.element_name,
             :required_flag=> e.required_flag,
             :line_num=>e.line_num,
             :status_code=>"ENABLED"}
        })
      elsif e.entry_template_element_code.include?("INCIDENT_REQUEST_SOLUTION_")
        session[:skm_entry_details].merge!({e.id.to_sym => {
            :entry_content => incident_request.concat_journals,
             :default_rows => e.default_rows,
             :entry_template_element_id => e.id,
             :element_name => e.element_name,
             :required_flag=> e.required_flag,
             :line_num=>e.line_num,
             :status_code=>"ENABLED"}
        })
      end
    end

    @entry_details = []
    @error_details = []
    @elements = Skm::EntryTemplateDetail.owned_elements(@entry_header.entry_template_id)
    session[:skm_entry_details].each do |k, v|
      t = Skm::EntryDetail.new(v)
      @entry_details << t
    end

  end

  def create_from_icm_request
    @entry_header = Skm::EntryHeader.new(params[:skm_entry_header])
    params[:skm_entry_details].each do |k, v|
      t = Skm::EntryDetail.new(v)
      @entry_header.entry_details << t
    end
    @entry_header.entry_status_code = "PUBLISHED"
    @entry_header.published_date = Time.now
    @entry_header.doc_number = Skm::EntryHeader.generate_doc_number
    @entry_header.version_number = @entry_header.next_version_number
    @entry_header.author_id = Irm::Person.current.id
#    column_ids = params[:skm_entry_header][:column_ids].split(",")
    incident_request = Icm::IncidentRequest.find(@entry_header.source_id)
    respond_to do |format|
      if @entry_header.save
        incident_request.process_knowledge(@entry_header.id)
#        column_ids.each do |c|
#          Skm::EntryColumn.create(:entry_header_id => @entry_header.id, :column_id => c)
#        end
        if params[:files]
          files = params[:files]
          #调用方法创建附件
          begin
            attached = Irm::AttachmentVersion.create_verison_files(files, Skm::EntryHeader.name, @entry_header.id)
          rescue
            @entry_header.errors << "FILE UPLOAD ERROR"
          end
        end

        session[:skm_entry_header] = nil
        session[:skm_entry_details] = nil

        format.html { redirect_to({:action=>"show", :id => @entry_header}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @entry_header, :status => :created, :location => @entry_header }
      else
        format.html { render :action => "new_from_icm_request" }
        format.xml  { render :xml => @entry_header.errors, :status => :unprocessable_entity }
      end
    end
  end


  def remove_exits_attachment_during_create
    @file = Irm::Attachment.where(:latest_version_id => params[:att_id]).first
    session[:skm_entry_attachments].delete_if{|i| i==params[:att_id]}
    @attachments = Irm::Attachment.list_all.where("latest_version_id IN (?)", session[:skm_entry_attachments])
    respond_to do |format|
      if @file.destroy
          format.js { render :remove_exits_attachment_during_create }
      end
    end
  end

  def remove_exits_attachment
    @file = Irm::Attachment.where(:latest_version_id => params[:att_id]).first
    @attachments = Irm::Attachment.list_all.query_by_source(Skm::EntryHeader.name, params[:entry_header_id])
    respond_to do |format|
      if @file.destroy
          format.js { render :remove_exits_attachment}
      end
    end
  end

  #创建知识库关联
  def add_relation
    existed_relation =  Skm::EntryHeaderRelation.existed_relation(params[:source_id], params[:skm_relation])

    unless existed_relation.any? || !params[:skm_relation].present? || params[:source_id].eql?(params[:skm_relation])
      params[:relation_type] ||= 'RELATION'
      entry_header_relation = Skm::EntryHeaderRelation.create(:source_id => params[:source_id], :target_id => params[:skm_relation], :relation_type => params[:relation_type])
      @entry_header_id = entry_header_relation.source_id
    end
    @entry_header_id ||= params[:source_id]
    @entry_relation = Skm::EntryHeaderRelation.list_all(@entry_header_id)
    respond_to do |format|
      format.js {render :add_relation}
    end
  end
  #解除关联关系
  def remove_relation
    relation = Skm::EntryHeaderRelation.find(params[:id])
    relation.destroy
    @entry_header_id = params[:source_id]
    @entry_relation = Skm::EntryHeaderRelation.list_all(@entry_header_id)
    respond_to do |format|
      format.js {render :add_relation}
    end
  end

  def portlet
      session[:skm_entry_header] = nil
      session[:skm_entry_details] = nil
      session[:skm_entry_attachments] = nil
    @entry_header = Skm::EntryHeader.new

    respond_to do |format|
      format.html { render :layout => "portlet" } # index.html.erb
      format.xml { render :xml => @entry_header }
    end
  end
end