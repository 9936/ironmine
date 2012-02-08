class Irm::PortletsController < ApplicationController
  # GET /portlets
  # GET /portlets.xml
  def index
    @portlets = Irm::Portlet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @portlets }
    end
  end

  # GET /portlets/1
  # GET /portlets/1.xml
  def show
    @portlet = Irm::Portlet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @portlet }
    end
  end

  # GET /portlets/new
  # GET /portlets/new.xml
  def new
    @portlet = Irm::Portlet.new(:default_flag => Irm::Constant::SYS_YES)
    #默认加载controllers
    #@controllers = init_controllers
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @portlet }
    end
  end

  # GET /portlets/1/edit
  def edit
    @portlet = Irm::Portlet.multilingual.find(params[:id])
  end

  # POST /portlets
  # POST /portlets.xml
  def create
    @portlet = Irm::Portlet.new(params[:irm_portlet])

    respond_to do |format|
      if @portlet.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @portlet, :status => :created, :location => @portlet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @portlet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /portlets/1
  # PUT /portlets/1.xml
  def update
    @portlet = Irm::Portlet.find(params[:id])
    @portlet.attributes = params[:irm_portlet]

    respond_to do |format|
      if @portlet.valid?
        @portlet.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @portlet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /portlets/1
  # DELETE /portlets/1.xml
  def destroy
    @portlet = Irm::Portlet.find(params[:id])
    @portlet.destroy

    respond_to do |format|
      format.html { redirect_to(portlets_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @portlet = Irm::Portlet.find(params[:id])
  end

  def multilingual_update
    @portlet = Irm::Portlet.find(params[:id])
    @portlet.not_auto_mult=true
    respond_to do |format|
      if @portlet.update_attributes(params[:portlet])
        format.html { redirect_to({:action => "show"}, :notice => 'Portlet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @portlet.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    portlets_scope = Irm::Portlet.multilingual.select("controller page_controller, action page_action")
    portlets_scope = portlets_scope.match_value("#{Irm::PortletsTl.table_name}.name",params[:name])
    portlets_scope = portlets_scope.match_value("#{Irm::Portlet.table_name}.controller",params[:page_controller])
    portlets_scope = portlets_scope.match_value("#{Irm::Portlet.table_name}.action",params[:page_action])
    portlets_scope = portlets_scope.match_value("#{Irm::PortletsTl.table_name}.description",params[:description])
    portlets_scope = portlets_scope.match_value("#{Irm::Portlet.table_name}.code",params[:code])
    portlets,count = paginate(portlets_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(portlets.to_grid_json([:code,:name,:page_controller, :page_action, :description,:status_meaning],count))}
    end
  end

  #定义获取actions_options 的Action
  def get_actions_options
    actions_scope =  Irm::Permission.select("action").group(:action).where("#{Irm::Permission.table_name}.params_count = ? AND #{Irm::Permission.table_name}.controller = ? AND #{Irm::Permission.table_name}.direct_get_flag = ?",0,params[:controllers],Irm::Constant::SYS_YES)
    #actions_scope =  Irm::Permission.select("action").group(:action).where(:controller =>params[:controllers], :direct_get_flag => Irm::Constant::SYS_YES)
    actions = actions_scope.collect {|p| {:label=>p[:action],:value=>p[:action]}}
    respond_to do |format|
      format.json {render :json=>actions.to_grid_json([:label,:value],actions.count)}
    end
  end
end
