class Isp::CheckItemsController < ApplicationController
  layout "application_full"

  def index

  end

  # GET /isp/check_items/1
  # GET /isp/check_items/1.xml
  def show
    @isp_check_item = Isp::CheckItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @isp_check_item }
    end
  end

  # GET /isp/check_items/new
  # GET /isp/check_items/new.xml
  def new
    @isp_check_item = Isp::CheckItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @isp_check_item }
    end
  end

  # GET /isp/check_items/1/edit
  def edit
    @isp_check_item = Isp::CheckItem.find(params[:id])
  end

  # POST /isp/check_items
  # POST /isp/check_items.xml
  def create
    @isp_check_item = Isp::CheckItem.new(params[:isp_check_item])

    respond_to do |format|
      if @isp_check_item.save
        format.html { redirect_to({:action => "show", :id => @isp_check_item.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @isp_check_item, :status => :created, :location => @isp_check_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @isp_check_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /isp/check_items/1
  # PUT /isp/check_items/1.xml
  def update
    @isp_check_item = Isp::CheckItem.find(params[:id])

    respond_to do |format|
      if @isp_check_item.update_attributes(params[:isp_check_item])
        format.html { redirect_to({:action => "show", :id => @isp_check_item.id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @isp_check_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /isp/check_items/1
  # DELETE /isp/check_items/1.xml
  def destroy
    @isp_check_item = Isp::CheckItem.find(params[:id])
    @isp_check_item.destroy

    respond_to do |format|
      format.html { redirect_to({:action => "index"}) }
      format.xml  { head :ok }
    end
  end

  def get_data
    isp_check_items_scope = Isp::CheckItem#.with_connection.with_program(params[:program_id])
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
