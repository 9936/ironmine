class Skm::FileManagementsController < ApplicationController
  layout "application_full"
  def index
    respond_to do |format|
      format.html
      format.xml { render :xml => @files}
    end
  end

  def new

  end

  def batch_new
    
  end

  def create
    file_flag = true
    files = params[:file]

    if request.post?
      params[:file].each_value do |att|
        file = att["file"]
        next unless file && file.size > 0
        flag, now = Irm::AttachmentVersion.validates?(file)
        if !flag
          file_flag = false
          flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
          break
        end
      end
    end

    respond_to do |format|
      if file_flag && Irm::AttachmentVersion.create_verison_files(files,0,0)
        if params[:act] == "next"
          format.html {redirect_to :action => 'new'}
        else
          format.html {redirect_to :action => 'index'}
        end
        format.html { redirect_to({:action=>"index"}) }
      else
        format.html { render :action => "new" }
      end
    end

  end

  def batch_create
    files = params[:file]
    file_flag = true
    if request.post?
      params[:file].each_value do |att|
        file = att["file"]
        next unless file && file.size > 0
        flag, now = Irm::AttachmentVersion.validates?(file)
        if !flag
          file_flag = false
          flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
          break
        end
      end
    end

    respond_to do |format|
      if file_flag && Irm::AttachmentVersion.create_verison_files(files,0,0)
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
      else
        format.html { render :action => "batch_new" }
      end
    end
  end
  
  def edit
    @file = Irm::Attachment.accessible(Irm::Person.current.id).where("#{Irm::Attachment.table_name}.id = ?", params[:id]).first
  end

  def update
    file_flag = true
    @file = Irm::Attachment.find(params[:id])
    infile = {}
    params[:file].each_value do |p|
      infile = p
    end
    if infile[:file]
      file = params[:file]

      if request.post?
        params[:file].each_value do |att|
          fi = att["file"]
          next unless fi && fi.size > 0
          flag, now = Irm::AttachmentVersion.validates?(fi)
          if !flag
            file_flag = false
            flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
            break
          end
        end
      end
      Irm::AttachmentVersion.update_version_files(@file, file, 0, 0) if file_flag
    else
      @file.update_attribute(:description, infile[:description])
      @file.update_attribute(:file_category, infile[:file_category])
      @file.update_attribute(:folder_id, infile[:folder_id])
      #@file.update_attribute(:private_flag, infile[:private_flag])
      file = Irm::AttachmentVersion.where(:id => @file.latest_version_id)
      if file.any?
        file.first().update_attributes(#:private_flag => @file.private_flag,
                               :description => @file.description,
                               :category_id => @file.file_category)
      end
    end
    #更新访问权限
    @file.update_attribute(:access_type, params[:access_type])
    @file.create_member_from_str(params[:member_str])
    respond_to do |format|
      if file_flag && @file.save
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @file, :status => :created, :location => @file }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @file.errors, :status => :unprocessable_entity }
      end
    end    
  end

  def download
    version = Irm::AttachmentVersion.find(params[:version_id])
    if version.present?
      Irm::AttachmentCounter.create(:version_id => version.id, :download_by => Irm::Person.current.id)
      send_data File.open(version.data.path,"r").read, :filename=>version.data.original_filename,:type => version.data.content_type
    end
  end

  def show
    @history = Skm::FileOperateHistory.new({:operate_code=>"TEST_SHOW",
                                             :attachment_id=>params[:id],
                                             :version_id =>params[:version_id],
                                             :file_name=>params[:data_file_name]})
    @history.save


    redirect_to  "/upload/irm/attachment_versions/#{params[:version_id]}/original/#{params[:data_file_name]}"
  end
  
  def get_data
    files_scope = Irm::Attachment.accessible(Irm::Person.current.id)
    files_scope = files_scope.match_value("av.data_file_name",params[:data_file_name])
    files_scope = files_scope.match_value("p.full_name",params[:full_name])
    files_scope = files_scope.match_value("#{Irm::Attachment.table_name}.description",params[:description])
    files_scope = files_scope.where("#{Irm::Attachment.table_name}.folder_id = ?",params[:folder_id]) if params[:folder_id].present?

    files,count = paginate(files_scope)
    respond_to do |format|
      format.html{
        @datas = files
        @count = count
      }
      format.json  {render :json => to_jsonp(files.to_grid_json(['0', :category_id,:description, :data_file_name, :data_content_type, :data_file_size, :data_updated_at, :status_code, :category_name, :version_id], count)) }
    end
  end

  def destroy
    @file = Irm::Attachment.find(params[:id])
    respond_to do |format|
      if @file.destroy
          format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
          format.xml  { render :xml => @flex_value, :status => :created, :location => @file }
      else
         @error = @file
         format.html { render "error_message" }
      end
    end
  end

  def version_details
    @version = Irm::AttachmentVersion.find(params[:id])
  end

  def download_data
    @version = Irm::AttachmentVersion.find(params[:id])
    download_people_scope = Irm::AttachmentCounter.download_people(@version.id)
    @datas,@count = paginate(download_people_scope)
  end

  def get_version_files
    attachment = Irm::Attachment.find(params[:id])
    @history_versions = Irm::AttachmentVersion.history_versions(attachment.id, attachment.latest_version_id)
  end
  
  def remove_version_file
    @file_version = Irm::AttachmentVersion.find(params[:id])
    @file_version.destroy
    respond_to do |format|
        format.html { redirect_to({:action=>"get_version_files", :id =>  @file_version.attachment_id }, :notice =>t(:successfully_created)) }
    end
  end

end