class Irm::PortalLayoutsController < ApplicationController
  # GET /irm/portal_layouts
  # GET /irm/portal_layouts.xml

  def index
    @irm_portal_layouts = Irm::PortalLayout.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @irm_portal_layouts }
    end
  end

  # GET /irm/portal_layouts/1
  # GET /irm/portal_layouts/1.xml
  def show
    @irm_portal_layout = Irm::PortalLayout.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @irm_portal_layout }
    end
  end

  # GET /irm/portal_layouts/new
  # GET /irm/portal_layouts/new.xml
  def new
    @irm_portal_layout = Irm::PortalLayout.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @irm_portal_layout }
    end
  end

  # GET /irm/portal_layouts/1/edit
  def edit
    @irm_portal_layout = Irm::PortalLayout.multilingual.find(params[:id])
  end

  # POST /irm/portal_layouts
  # POST /irm/portal_layouts.xml
  def create
    @irm_portal_layout = Irm::PortalLayout.new(params[:irm_portal_layout])
    respond_to do |format|
      if @irm_portal_layout.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @irm_portal_layout, :status => :created, :location => @irm_portal_layout }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @irm_portal_layout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /irm/portal_layouts/1
  # PUT /irm/portal_layouts/1.xml
  def update
    @irm_portal_layout = Irm::PortalLayout.find(params[:id])
    respond_to do |format|
      if @irm_portal_layout.update_attributes(params[:irm_portal_layout])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @irm_portal_layout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /irm/portal_layouts/1
  # DELETE /irm/portal_layouts/1.xml
  def destroy
    @irm_portal_layout = Irm::PortalLayout.find(params[:id])
    @irm_portal_layout.destroy

    respond_to do |format|
      format.html { redirect_to(irm_portal_layouts_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @irm_portal_layout = Irm::PortalLayout.find(params[:id])
  end

  def multilingual_update
    @irm_portal_layout = Irm::PortalLayout.find(params[:id])
    @irm_portal_layout.not_auto_mult=true
    respond_to do |format|
      if @irm_portal_layout.update_attributes(params[:irm_portal_layout])
        format.html { redirect_to({:action => "show"}, :notice => 'Portal layout was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @irm_portal_layout.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    irm_portal_layouts_scope = Irm::PortalLayout.multilingual
    irm_portal_layouts_scope = irm_portal_layouts_scope.match_value("#{Irm::PortalLayoutsTl.table_name}.name",params[:name])
    irm_portal_layouts,count = paginate(irm_portal_layouts_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(irm_portal_layouts.to_grid_json([:name,:description,:layout,:default_flag],count))}
      format.html {
        @datas =  irm_portal_layouts
        @count = count
      }
    end
  end

end
