class Com::ConfigAttributesController < ApplicationController
  # GET /config_attributes
  # GET /config_attributes.xml
  def index
    @config_attributes = Com::ConfigAttribute.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @config_attributes }
    end
  end

  # GET /config_attributes/1
  # GET /config_attributes/1.xml
  def show
    @config_attribute = Com::ConfigAttribute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @config_attribute }
    end
  end

  # GET /config_attributes/new
  # GET /config_attributes/new.xml
  def new
    #根据传递过来的config_class code 进行合法判断
    config_class = Com::ConfigClass.find(params[:class_id])
    unless config.nil?
      @config_attribute = Com::ConfigAttribute.new(:config_class_id => config_class.id)
    else
      @config_attribute = Com::ConfigAttribute.new
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @config_attribute }
    end
  end

  # GET /config_attributes/1/edit
  def edit
    @config_attribute = Com::ConfigAttribute.multilingual.find(params[:id])
  end

  # POST /config_attributes
  # POST /config_attributes.xml
  def create
    @config_attribute = Com::ConfigAttribute.new(params[:com_config_attribute])

    respond_to do |format|
      if @config_attribute.save
        format.html { redirect_to({:controller => "com/config_classes",:action => "show", :id =>@config_attribute.config_class_id }, :notice => t(:successfully_created)) }
        #format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @config_attribute, :status => :created, :location => @config_attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @config_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /config_attributes/1
  # PUT /config_attributes/1.xml
  def update
    @config_attribute = Com::ConfigAttribute.find(params[:id])

    respond_to do |format|
      if @config_attribute.update_attributes(params[:com_config_attribute])
        format.html { redirect_to({:controller => "com/config_classes",:action => "show", :id =>@config_attribute.config_class_id }, :notice => t(:successfully_updated)) }
        #format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /config_attributes/1
  # DELETE /config_attributes/1.xml
  def destroy
    @config_attribute = Com::ConfigAttribute.find(params[:id])
    @config_attribute.destroy

    respond_to do |format|
      format.html { redirect_to(config_attributes_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @config_attribute = Com::ConfigAttribute.find(params[:id])
  end

  def multilingual_update
    @config_attribute = Com::ConfigAttribute.find(params[:id])
    @config_attribute.not_auto_mult=true
    respond_to do |format|
      if @config_attribute.update_attributes(params[:com_config_attribute])
        format.html { redirect_to({:action => "show"}, :notice => 'Config attribute was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    if params[:class_id].present?
      config_attributes_scope = Com::ConfigAttribute.multilingual.query_attributes_by_class_id(params[:class_id])
    else
      config_attributes_scope = Com::ConfigAttribute
    end
    config_attributes_scope = config_attributes_scope.match_value("#{Com::ConfigAttribute.table_name}.code",params[:code])
    config_attributes_scope = config_attributes_scope.match_value("#{Com::ConfigAttribute.table_name}.input_type",params[:input_type])
    config_attributes_scope = config_attributes_scope.match_value("#{Com::ConfigAttributesTl.table_name}.name",params[:name])
    config_attributes,count = paginate(config_attributes_scope)
    respond_to do |format|
      format.html {
        @datas = config_attributes
        @count = count
        render_html_data_table
      }
      format.json {render :json=>to_jsonp(config_attributes.to_grid_json([:code,:input_type,:input_value,:name,:description,:status_meaning],count))}
    end
  end
end
