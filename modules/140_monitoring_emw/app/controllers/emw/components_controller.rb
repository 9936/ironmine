class Emw::ComponentsController < ApplicationController
  layout "application_full"
  # GET /emw/components
  # GET /emw/components.xml
  def index
    @components = Emw::Component.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @components }
    end
  end

  # GET /emw/components/1
  # GET /emw/components/1.xml
  def show
    @component = Emw::Component.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @component }
    end
  end

  # GET /emw/components/new
  # GET /emw/components/new.xml
  def new
    @component = Emw::Component.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @component }
    end
  end

  # GET /emw/components/1/edit
  def edit
    @component = Emw::Component.find(params[:id])
  end

  # POST /emw/components
  # POST /emw/components.xml
  def create
    @component = Emw::Component.new(params[:emw_component])
    respond_to do |format|
      if @component.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @component, :status => :created, :location => @component }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @component.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emw/components/1
  # PUT /emw/components/1.xml
  def update
    @component = Emw::Component.find(params[:id])

    respond_to do |format|
      if @component.update_attributes(params[:emw_component])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @component.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    components_scope = Emw::Component
    components_scope = components_scope.match_value("#{Emw::Component.table_name}.name",params[:name])
    components,count = paginate(components_scope)
    respond_to do |format|
      format.html  {
        @datas = components
        @count = count
      }
      format.json {render :json=>to_jsonp(components.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
