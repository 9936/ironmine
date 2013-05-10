class Isp::ConnectionsController < ApplicationController
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
    @isp_connection = Isp::Connection.new(:program_id => params[:program_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @isp_connection }
    end
  end

  # GET /isp/connections/1/edit
  def edit
    @isp_connection = Isp::Connection.find(params[:id])
    @isp_connection.hand_host
  end

  # POST /isp/connections
  # POST /isp/connections.xml
  def create
    @isp_connection = Isp::Connection.new(params[:isp_connection])

    respond_to do |format|
      if @isp_connection.save
        format.html { redirect_to({:controller => "isp/programs", :id => @isp_connection.program_id, :action => "show"}, :notice => t(:successfully_created)) }
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
        format.html { redirect_to({:controller => "isp/programs", :id => @isp_connection.program_id, :action => "show"}, :notice => t(:successfully_updated)) }
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
      format.html { redirect_to(:controller => "isp/programs", :id => @isp_connection.program_id, :action => "show") }
      format.xml  { head :ok }
    end
  end


  def get_data
    isp_connections_scope = Isp::Connection.with_program(params[:program_id])
    isp_connections_scope = isp_connections_scope.match_value("#{Isp::Connection.table_name}.name",params[:name])
    isp_connections,count = paginate(isp_connections_scope)
    respond_to do |format|
      format.html  {
        @datas = isp_connections
        @count = count
      }
      format.json {render :json=>to_jsonp(isp_connections.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  def add_items
  end

  def remove_item
    @isp_connection_item = Isp::ConnectionItem.query_by_conn_item(params[:id], params[:check_item_id]).first
    @isp_connection_item.destroy if @isp_connection_item.present?

    respond_to do |format|
      format.html { redirect_to(:controller => "isp/programs", :id => params[:program_id], :action => "show") }
      format.xml  { head :ok }
    end
  end

  def save_items
    connection = Isp::Connection.new(params[:isp_connection])
    connection.status_code.split(",").delete_if{|i| i.blank?}.each do |check_item_id|
      Isp::ConnectionItem.create(:connection_id => params[:id], :check_item_id => check_item_id)
    end
    respond_to do |format|
      format.html { redirect_to({:controller => "isp/programs",:action => "show", :id => params[:program_id]}) }
      format.xml  { head :ok }
    end
  end

  def get_items_data
    isp_check_items_scope = Isp::CheckItem.query_available_items(params[:id])
    isp_check_items_scope = isp_check_items_scope.match_value("#{Isp::CheckItem.table_name}.name",params[:name])
    isp_check_items,count = paginate(isp_check_items_scope)
    respond_to do |format|
      format.html  {
        @datas = isp_check_items
        @count = count
      }
      format.json {render :json=>to_jsonp(isp_check_items.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
