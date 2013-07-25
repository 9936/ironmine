class Emw::DatabaseItemsController < ApplicationController
  layout "application_full"
  # GET /emw/database_items
  # GET /emw/database_items.xml
  def index
    @emw_database_items = Emw::DatabaseItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emw_database_items }
    end
  end

  # GET /emw/database_items/1
  # GET /emw/database_items/1.xml
  def show
    @emw_database_item = Emw::DatabaseItem.find(params[:id])

    respond_to do |format|

      format.html # show.html.erb
      format.xml  { render :xml => @emw_database_item }
    end
  end

  # GET /emw/database_items/new
  # GET /emw/database_items/new.xml
  def new
    @emw_database_item = Emw::DatabaseItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @emw_database_item }
    end
  end

  # GET /emw/database_items/1/edit
  def edit
    @emw_database_item = Emw::DatabaseItem.find(params[:id])
  end

  # POST /emw/database_items
  # POST /emw/database_items.xml
  def create
    @emw_database_item = Emw::DatabaseItem.new(params[:emw_database_item])
    @emw_database_item.database_id=params[:database_id]
    respond_to do |format|
      if @emw_database_item.save
        format.js
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @emw_database_item, :status => :created, :location => @emw_database_item }
      else
        format.js
        format.html { render :action => "new" }
        format.xml  { render :xml => @emw_database_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emw/database_items/1
  # PUT /emw/database_items/1.xml
  def update
    @emw_database_item = Emw::DatabaseItem.find(params[:id])

    respond_to do |format|
      if @emw_database_item.update_attributes(params[:emw_database_item])
        format.js
        format.html { redirect_to({:controller=>"emw/databases",:action => "show",:id=>@emw_database_item.database_id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.js
        format.html { render :action => "edit" }
        format.xml  { render :xml => @emw_database_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /emw/database_items/1
  # DELETE /emw/database_items/1.xml
  def destroy
    @emw_database_item = Emw::DatabaseItem.find(params[:id])
    @emw_database_item.destroy
    respond_to do |format|
      format.js
    end
  end


  def get_data
    database_items = Emw::DatabaseItem.query_by_database(params[:database_id])
    respond_to do |format|
      format.html  {
        @datas = database_items
        @count = database_items.count
      }
      format.json {render :json=>to_jsonp(database_items.to_grid_json([:name,:description,:script_type,:script],count))}
    end
  end

end
