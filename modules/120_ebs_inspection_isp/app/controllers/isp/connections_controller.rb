class Isp::ConnectionsController < ApplicationController
  # GET /isp/connections
  # GET /isp/connections.xml
  def index
    @isp_connections = Isp::Connection.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @isp_connections }
    end
  end

  # GET /isp/connections/1
  # GET /isp/connections/1.xml
  def show
    @isp_connection = Isp::Connection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @isp_connection }
    end
  end

  # GET /isp/connections/new
  # GET /isp/connections/new.xml
  def new
    @isp_connection = Isp::Connection.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @isp_connection }
    end
  end

  # GET /isp/connections/1/edit
  def edit
    @isp_connection = Isp::Connection.find(params[:id])
  end

  # POST /isp/connections
  # POST /isp/connections.xml
  def create
    @isp_connection = Isp::Connection.new(params[:isp_connection])

    respond_to do |format|
      if @isp_connection.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @isp_connection, :status => :created, :location => @isp_connection }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @isp_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /isp/connections/1
  # PUT /isp/connections/1.xml
  def update
    @isp_connection = Isp::Connection.find(params[:id])

    respond_to do |format|
      if @isp_connection.update_attributes(params[:isp_connection])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @isp_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /isp/connections/1
  # DELETE /isp/connections/1.xml
  def destroy
    @isp_connection = Isp::Connection.find(params[:id])
    @isp_connection.destroy

    respond_to do |format|
      format.html { redirect_to(isp_connections_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @isp_connection = Isp::Connection.find(params[:id])
  end

  def multilingual_update
    @isp_connection = Isp::Connection.find(params[:id])
    @isp_connection.not_auto_mult=true
    respond_to do |format|
      if @isp_connection.update_attributes(params[:isp_connection])
        format.html { redirect_to({:action => "show"}, :notice => 'Connection was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @isp_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    isp_connections_scope = Isp::Connection.multilingual
    isp_connections_scope = isp_connections_scope.match_value("isp_connection.name",params[:name])
    isp_connections,count = paginate(isp_connections_scope)
    respond_to do |format|
      format.html  {
        @datas = isp_connections
        @count = count
      }
      format.json {render :json=>to_jsonp(isp_connections.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
