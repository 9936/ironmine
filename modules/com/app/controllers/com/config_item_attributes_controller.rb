class Com::ConfigItemAttributesController < ApplicationController
  # GET /com/config_item_attributes
  # GET /com/config_item_attributes.xml
  def index
    @com_config_item_attributes = Com::ConfigItemAttribute.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @com_config_item_attributes }
    end
  end

  # GET /com/config_item_attributes/1
  # GET /com/config_item_attributes/1.xml
  def show
    @com_config_item_attribute = Com::ConfigItemAttribute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @com_config_item_attribute }
    end
  end

  # GET /com/config_item_attributes/new
  # GET /com/config_item_attributes/new.xml
  def new
    @com_config_item_attribute = Com::ConfigItemAttribute.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @com_config_item_attribute }
    end
  end

  # GET /com/config_item_attributes/1/edit
  def edit
    @com_config_item_attribute = Com::ConfigItemAttribute.find(params[:id])
  end

  # POST /com/config_item_attributes
  # POST /com/config_item_attributes.xml
  def create
    @com_config_item_attribute = Com::ConfigItemAttribute.new(params[:com_config_item_attribute])

    respond_to do |format|
      if @com_config_item_attribute.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @com_config_item_attribute, :status => :created, :location => @com_config_item_attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @com_config_item_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /com/config_item_attributes/1
  # PUT /com/config_item_attributes/1.xml
  def update
    @com_config_item_attribute = Com::ConfigItemAttribute.find(params[:id])

    respond_to do |format|
      if @com_config_item_attribute.update_attributes(params[:com_config_item_attribute])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @com_config_item_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /com/config_item_attributes/1
  # DELETE /com/config_item_attributes/1.xml
  def destroy
    @com_config_item_attribute = Com::ConfigItemAttribute.find(params[:id])
    @com_config_item_attribute.destroy

    respond_to do |format|
      format.html { redirect_to(com_config_item_attributes_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @com_config_item_attribute = Com::ConfigItemAttribute.find(params[:id])
  end

  def multilingual_update
    @com_config_item_attribute = Com::ConfigItemAttribute.find(params[:id])
    @com_config_item_attribute.not_auto_mult=true
    respond_to do |format|
      if @com_config_item_attribute.update_attributes(params[:com_config_item_attribute])
        format.html { redirect_to({:action => "show"}, :notice => 'Config item attribute was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @com_config_item_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    com_config_item_attributes_scope = Com::ConfigItemAttribute.multilingual
    com_config_item_attributes_scope = com_config_item_attributes_scope.match_value("com_config_item_attribute.name",params[:name])
    com_config_item_attributes,count = paginate(com_config_item_attributes_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(com_config_item_attributes.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
