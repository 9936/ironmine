class Com::ConfigItemStatusesController < ApplicationController
  # GET /com/config_item_statuses
  # GET /com/config_item_statuses.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  {
        @config_item_statuses = Com::ConfigItemStatus.all
        render :xml => @config_item_statuses
      }
    end
  end

  # GET /com/config_item_statuses/1
  # GET /com/config_item_statuses/1.xml
  def show
    @config_item_status = Com::ConfigItemStatus.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @config_item_status }
    end
  end

  # GET /com/config_item_statuses/new
  # GET /com/config_item_statuses/new.xml
  def new
    @config_item_status = Com::ConfigItemStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @config_item_status }
    end
  end

  # GET /com/config_item_statuses/1/edit
  def edit
    @config_item_status = Com::ConfigItemStatus.multilingual.find(params[:id])
  end

  # POST /com/config_item_statuses
  # POST /com/config_item_statuses.xml
  def create
    @config_item_status = Com::ConfigItemStatus.new(params[:com_config_item_status])

    respond_to do |format|
      if @config_item_status.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @config_item_status, :status => :created, :location => @config_item_status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @config_item_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /com/config_item_statuses/1
  # PUT /com/config_item_statuses/1.xml
  def update
    @config_item_status = Com::ConfigItemStatus.find(params[:id])

    respond_to do |format|
      if @config_item_status.update_attributes(params[:com_config_item_status])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_item_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /com/config_item_statuses/1
  # DELETE /com/config_item_statuses/1.xml
  def destroy
    @config_item_status = Com::ConfigItemStatus.find(params[:id])
    @config_item_status.destroy

    respond_to do |format|
      format.html { redirect_to(com_config_item_statuses_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @config_item_status = Com::ConfigItemStatus.find(params[:id])
  end

  def multilingual_update
    @config_item_status = Com::ConfigItemStatus.find(params[:id])
    @config_item_status.not_auto_mult=true
    respond_to do |format|
      if @config_item_status.update_attributes(params[:com_config_item_status])
        format.html { redirect_to({:action => "show"}, :notice => 'Config item status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_item_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    com_config_item_statuses_scope = Com::ConfigItemStatus.multilingual
    com_config_item_statuses_scope = com_config_item_statuses_scope.match_value("com_config_item_status.name",params[:name])
    com_config_item_statuses,count = paginate(com_config_item_statuses_scope)
    respond_to do |format|
      format.html {
        @datas = com_config_item_statuses
        @count = count
      }
      format.json {render :json=>to_jsonp(com_config_item_statuses.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
