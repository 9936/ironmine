class Emw::ComponentItemsController < ApplicationController
  # GET /emw/component_items
  # GET /emw/component_items.xml
  def index
    @component_items = Emw::ComponentItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @component_items }
    end
  end

  # GET /emw/component_items/1
  # GET /emw/component_items/1.xml
  def show
    @component_item = Emw::ComponentItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @component_item }
    end
  end

  # GET /emw/component_items/new
  # GET /emw/component_items/new.xml
  def new
    @component_item = Emw::ComponentItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @component_item }
    end
  end

  # GET /emw/component_items/1/edit
  def edit
    @component_item = Emw::ComponentItem.find(params[:id])
  end

  # POST /emw/component_items
  # POST /emw/component_items.xml
  def create
    @component_item = Emw::ComponentItem.new(params[:emw_component_item])
    @component_item.component_id=params[:component_id]

    respond_to do |format|
      if @component_item.save
        format.js
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @component_item, :status => :created, :location => @component_item }
      else
        format.js
        format.html { render :action => "new" }
        format.xml  { render :xml => @component_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emw/component_items/1
  # PUT /emw/component_items/1.xml
  def update
    @component_item = Emw::ComponentItem.find(params[:id])

    respond_to do |format|
      if @component_item.update_attributes(params[:emw_component_item])
        format.js
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.js
        format.html { render :action => "edit" }
        format.xml  { render :xml => @component_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /emw/component_items/1
  # DELETE /emw/component_items/1.xml
  def destroy
    @component_item = Emw::ComponentItem.find(params[:id])
    @component_item.destroy

    respond_to do |format|
      format.js
    end
  end


  def get_data
    component_items = Emw::ComponentItem.query_by_component(params[:component_id])
    respond_to do |format|
      format.html  {
        @datas = component_items
        @count = component_items.count
      }
      format.json {render :json=>to_jsonp(component_items.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
