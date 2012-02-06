class Irm::PortletConfigsController < ApplicationController
  # GET /portlet_configs
  # GET /portlet_configs.xml
  def index
    @portlet_configs = Irm::PortletConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @portlet_configs }
    end
  end

  # GET /portlet_configs/1
  # GET /portlet_configs/1.xml
  def show
    @portlet_config = Irm::PortletConfig.list_all.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @portlet_config }
    end
  end

  # GET /portlet_configs/new
  # GET /portlet_configs/new.xml
  def new
    @portlet_config = Irm::PortletConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @portlet_config }
    end
  end

  # GET /portlet_configs/1/edit
  def edit
    @portlet_config = Irm::PortletConfig.find(params[:id])
  end

  # POST /portlet_configs
  # POST /portlet_configs.xml
  def create
    @portlet_config = Irm::PortletConfig.new(params[:irm_portlet_config])

    respond_to do |format|
      if @portlet_config.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @portlet_config, :status => :created, :location => @portlet_config }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @portlet_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /portlet_configs/1
  # PUT /portlet_configs/1.xml
  def update
    @portlet_config = Irm::PortletConfig.find(params[:id])

    respond_to do |format|
      if @portlet_config.update_attributes(params[:irm_portlet_config])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @portlet_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /portlet_configs/1
  # DELETE /portlet_configs/1.xml
  def destroy
    @portlet_config = Irm::PortletConfig.find(params[:id])
    @portlet_config.destroy

    respond_to do |format|
      format.html { redirect_to({:controller => "irm/portlet_configs"}) }
      format.xml  { head :ok }
    end
  end

  def get_data
    portlet_configs_scope = Irm::PortletConfig.list_all
    portlet_configs_scope = portlet_configs_scope.match_value(" #{Irm::Person.table_name}.full_name",params[:person_name])
    portlet_configs,count = paginate(portlet_configs_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(portlet_configs.to_grid_json([:portal_code,:person_name,:config],count))}
    end
  end
end
