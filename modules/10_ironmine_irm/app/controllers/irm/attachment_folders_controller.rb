class Irm::AttachmentFoldersController < ApplicationController
  layout "application_full"
  # GET /irm/attachment_folders
  # GET /irm/attachment_folders.xml
  def index
    @irm_attachment_folders = Irm::AttachmentFolder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @irm_attachment_folders }
    end
  end

  # GET /irm/attachment_folders/1
  # GET /irm/attachment_folders/1.xml
  def show
    @irm_attachment_folder = Irm::AttachmentFolder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @irm_attachment_folder }
    end
  end

  # GET /irm/attachment_folders/new
  # GET /irm/attachment_folders/new.xml
  def new
    @irm_attachment_folder = Irm::AttachmentFolder.new
    @irm_attachment_folder[:created_by] = Irm::Person.current[:id]
    @irm_attachment_folder[:updated_by] = Irm::Person.current[:id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @irm_attachment_folder }
    end
  end

  # GET /irm/attachment_folders/1/edit
  def edit
    @irm_attachment_folder = Irm::AttachmentFolder.find(params[:id])
    puts '==========================================================='
    puts 'id='+params[:id]
    puts '==========================================================='
  end

  # POST /irm/attachment_folders
  # POST /irm/attachment_folders.xml
  def create
    @irm_attachment_folder = Irm::AttachmentFolder.new(params[:irm_attachment_folder])
    #@irm_available_parents = Irm::AttachmentFolder.all

    respond_to do |format|
      if @irm_attachment_folder.save
        format.html { redirect_to({:action => "index", :controller => "skm/file_managements"}, :notice => t(:successfully_created)) }
        format.xml { render :xml => @irm_attachment_folder, :status => :created, :location => @irm_attachment_folder }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @irm_attachment_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /irm/attachment_folders/1
  # PUT /irm/attachment_folders/1.xml
  def update
    @irm_attachment_folder = Irm::AttachmentFolder.find(params[:id])
    @irm_attachment_folder[:updated_by] = Irm::Person.current[:id]
    params[:parent_id]='' if @irm_attachment_folder[:parent_id]==''
    puts '*****************************************'
    puts '* Root!' if  @irm_attachment_folder[:parent_id]==''
    puts '*****************************************'
    puts '* Params:'+params.to_s
    puts '*****************************************'
    respond_to do |format|
      if @irm_attachment_folder.update_attributes(params[:irm_attachment_folder])
        format.html { redirect_to({:action => "index", :controller => "skm/file_managements"}, :notice => t(:successfully_updated)) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @irm_attachment_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /irm/attachment_folders/1
  # DELETE /irm/attachment_folders/1.xml
  def destroy
    @irm_attachment_folder = Irm::AttachmentFolder.find(params[:id])
    @irm_attachment_folder.destroy

    respond_to do |format|
      format.html { redirect_to(irm_attachment_folders_url) }
      format.xml { head :ok }
    end
  end

  def multilingual_edit
    @irm_attachment_folder = Irm::AttachmentFolder.find(params[:id])
  end

  def multilingual_update
    @irm_attachment_folder = Irm::AttachmentFolder.find(params[:id])
    @irm_attachment_folder.not_auto_mult=true
    respond_to do |format|
      if @irm_attachment_folder.update_attributes(params[:irm_attachment_folder])
        format.html { redirect_to({:action => "show"}, :notice => 'Attachment folder was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @irm_attachment_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    #irm_attachment_folders_scope = Irm::AttachmentFolder.multilingual
    irm_attachment_folders_scope = Irm::AttachmentFolder.where('1=1')
    irm_attachment_folders_scope = irm_attachment_folders_scope.match_value("irm_attachment_folders.name", params[:name])
    irm_attachment_folders, count = paginate(irm_attachment_folders_scope)
    respond_to do |format|
      format.html {
        @datas = irm_attachment_folders
        @count = count
      }
      format.json { render :json => to_jsonp(irm_attachment_folders.to_grid_json([:name, :description, :status_meaning], count)) }
    end
  end

  def get_folders_tree
    folder_tree=[]

    folders = Irm::AttachmentFolder.where("parent_id = ''")
    folders.each do |f|
      folder={:id => f[:id], :text => f[:name], :name => f[:name], :description => f[:description], :parent_id => f[:parent_id]}
      folder[:children]=api_child_nodes(folder[:id])
      #folder.delete[:children] if folder[:children].size==0
      folder_tree<<folder
    end
    puts folder_tree.to_json
    folder_top={id: '',
                  text: 'Root',
                  name: 'Root',
                  description: 'Root',
                  parent_id: '',
                  children: ''}
    puts folder_tree.to_json
    respond_to do |format|
      format.json { render :json => folder_tree.to_json }
    end
  end

  def api_child_nodes(id)
    child_nodes = []
    children = Irm::AttachmentFolder.where(:parent_id => id)

    children.each do |c|
      child_node = {:id => c[:id], :text => c[:name], :name => c[:name], :description => c[:description], :parent_id => c[:parent_id]}
      child_node[:children] = api_child_nodes(child_node[:id])
      child_node.delete(:children) if child_node[:children].size == 0
      child_nodes << child_node
    end
    child_nodes
  end

end
