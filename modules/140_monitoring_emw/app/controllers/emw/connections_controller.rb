class Emw::ConnectionsController < ApplicationController
  layout "application_full"
  
  def index
    
  end

  # GET /isp/connections/1
  # GET /isp/connections/1.xml
  def show
    @emw_connection = Emw::Connection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @emw_connection }
    end
  end

  # GET /isp/connections/new
  # GET /isp/connections/new.xml
  def new
    @emw_connection = Emw::Connection.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @emw_connection }
    end
  end

  # GET /isp/connections/1/edit
  def edit
    @emw_connection = Emw::Connection.find(params[:id])
  end

  # POST /isp/connections
  # POST /isp/connections.xml
  def create
    @emw_connection = Emw::Connection.new(params[:emw_connection])

    respond_to do |format|
      if @emw_connection.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @emw_connection, :status => :created, :location => @emw_connection }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @emw_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /isp/connections/1
  # PUT /isp/connections/1.xml
  def update
    @emw_connection = Emw::Connection.find(params[:id])

    respond_to do |format|
      if @emw_connection.update_attributes(params[:emw_connection])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @emw_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /isp/connections/1
  # DELETE /isp/connections/1.xml
  def destroy
    @emw_connection = Emw::Connection.find(params[:id])
    @emw_connection.destroy

    respond_to do |format|
      format.html { redirect_to(:action => "index") }
      format.xml  { head :ok }
    end
  end


  def get_data
    emw_connections_scope = Emw::Connection
    emw_connections_scope = emw_connections_scope.match_value("#{Emw::Connection.table_name}.name", params[:name])
    emw_connections,count = paginate(emw_connections_scope)
    respond_to do |format|
      format.html  {
        @datas = emw_connections
        @count = count
      }
      format.json {render :json=>to_jsonp(emw_connections.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

end
