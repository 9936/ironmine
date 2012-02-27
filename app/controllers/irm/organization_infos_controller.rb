class Irm::OrganizationInfosController < ApplicationController
  # GET /organization_infos
  # GET /organization_infos.xml
  def index
    #@organization_infos = Irm::OrganizationInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organization_infos }
    end
  end

  # GET /organization_infos/1
  # GET /organization_infos/1.xml
  def show
    @organization_info = Irm::OrganizationInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization_info }
    end
  end

  # GET /organization_infos/new
  # GET /organization_infos/new.xml
  def new
    @organization_info = Irm::OrganizationInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization_info }
    end
  end

  # GET /organization_infos/1/edit
  def edit
    @organization_info = Irm::OrganizationInfo.find(params[:id])
  end

  # POST /organization_infos
  # POST /organization_infos.xml
  def create
    @organization_info = Irm::OrganizationInfo.new(params[:irm_organization_info])

    respond_to do |format|
      if @organization_info.save
        if params[:irm_organization_info][:file] && params[:irm_organization_info][:file].present?
            file = params[:irm_organization_info][:file]
            #调用方法创建附件
            begin
              attached = Irm::AttachmentVersion.create_single_version_file(file,nil,nil, "Irm::OrganizationInfo", @organization_info.id)
              if !attached.nil? and attached.id.present?
                @organization_info.update_attribute(:attachment_id, attached.id)
              else
                @organization_info.errors.add(:file, I18n.t(:error_file_upload_limit))
                @organization_info.destroy
                format.html { render :action => "new" }
                format.xml  { render :xml => @organization_info.errors, :status => :unprocessable_entity }
              end
            rescue
              @organization_info.errors.add(:content, I18n.t(:error_file_upload_limit))
              @organization_info.destroy
              format.html { render :action => "new" }
              format.xml  { render :xml => @organization_info.errors, :status => :unprocessable_entity }
            end
        end
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @organization_info, :status => :created, :location => @organization_info }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organization_infos/1
  # PUT /organization_infos/1.xml
  def update
    @organization_info = Irm::OrganizationInfo.find(params[:id])
    if params[:irm_organization_info][:file] && params[:irm_organization_info][:file].present?
      file = params[:irm_organization_info][:file]
      #调用方法创建附件
      begin
        attached = Irm::AttachmentVersion.create_single_version_file(file,nil,nil, "Irm::OrganizationInfo", @organization_info.id)
        if !attached.nil? and attached.id.present?
          #删除原有的附件内容
          if @organization_info.attachment_id.present?
            attache = Irm::AttachmentVersion.find_by_attachment_id(@organization_info.id)
            attache.destroy unless attache.nil?
          end
          params[:irm_organization_info][:attachment_id] =  attached.id
        else
          @organization_info.errors.add(:file, I18n.t(:error_file_upload_limit))
          format.html { render :action => "edit" }
          format.xml  { render :xml => @organization_info.errors, :status => :unprocessable_entity }
        end
      rescue
        @organization_info.errors.add(:content, I18n.t(:error_file_upload_limit))
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization_info.errors, :status => :unprocessable_entity }
      end
    end
    respond_to do |format|
      if @organization_info.update_attributes(params[:irm_organization_info])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_infos/1
  # DELETE /organization_infos/1.xml
  def destroy
    @organization_info = Irm::OrganizationInfo.find(params[:id])
    @organization_info.destroy

    respond_to do |format|
      format.html { redirect_to(organization_infos_url) }
      format.xml  { head :ok }
    end
  end

  def get_data
    organization_infos_scope = Irm::OrganizationInfo.select_all
    organization_infos_scope = organization_infos_scope.match_value("#{Irm::OrganizationInfo.table_name}.name",params[:name])
    organization_infos_scope = organization_infos_scope.match_value("#{Irm::OrganizationInfo.table_name}.value",params[:value])
    organization_infos,count = paginate(organization_infos_scope)
    organization_infos =  get_attachments(organization_infos)
    respond_to do |format|
      format.json {render :json=>to_jsonp(organization_infos.to_grid_json([:name,:value,:attachment,:description],count))}
    end
  end

  private
  #获取附件链接
  def get_attachments(organization_infos)
    organization_infos.each do |o|
      if o.attachment_id.present?
        attachment = Irm::AttachmentVersion.find(o.attachment_id)
        o[:attachment] ||= []
        o[:attachment] = "<a target='_blank' href='#{attachment.data.url}'>#{attachment.data.original_filename}</a>".html_safe
      end
    end
    organization_infos
  end
end
