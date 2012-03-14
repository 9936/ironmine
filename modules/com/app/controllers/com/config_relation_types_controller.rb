class Com::ConfigRelationTypesController < ApplicationController
  # GET /config_relation_types
  # GET /config_relation_types.xml
  def index
    @config_relation_types = ConfigRelationType.multilingual.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @config_relation_types }
    end
  end

  # GET /config_relation_types/1
  # GET /config_relation_types/1.xml
  def show
    @config_relation_type = ConfigRelationType.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @config_relation_type }
    end
  end

  # GET /config_relation_types/new
  # GET /config_relation_types/new.xml
  def new
    @config_relation_type = ConfigRelationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @config_relation_type }
    end
  end

  # GET /config_relation_types/1/edit
  def edit
    @config_relation_type = ConfigRelationType.multilingual.find(params[:id])
  end

  # POST /config_relation_types
  # POST /config_relation_types.xml
  def create
    @config_relation_type = ConfigRelationType.new(params[:com_config_relation_type])

    respond_to do |format|
      if @config_relation_type.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @config_relation_type, :status => :created, :location => @config_relation_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @config_relation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /config_relation_types/1
  # PUT /config_relation_types/1.xml
  def update
    @config_relation_type = ConfigRelationType.find(params[:id])

    respond_to do |format|
      if @config_relation_type.update_attributes(params[:com_config_relation_type])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_relation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /config_relation_types/1
  # DELETE /config_relation_types/1.xml
  def destroy
    @config_relation_type = ConfigRelationType.find(params[:id])
    @config_relation_type.destroy

    respond_to do |format|
      format.html { redirect_to(config_relation_types_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @config_relation_type = ConfigRelationType.find(params[:id])
  end

  def multilingual_update
    @config_relation_type = ConfigRelationType.find(params[:id])
    @config_relation_type.not_auto_mult=true
    respond_to do |format|
      if @config_relation_type.update_attributes(params[:com_config_relation_type])
        format.html { redirect_to({:action => "show"}, :notice => 'Config relation type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_relation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    config_relation_types_scope = ConfigRelationType.multilingual
    config_relation_types_scope = config_relation_types_scope.match_value("#{Com::ConfigRelationTypesTl.table_name}.name",params[:name])
    config_relation_types_scope = config_relation_types_scope.match_value("#{Com::ConfigRelationTypesTl.table_name}.description",params[:description])
    config_relation_types_scope = config_relation_types_scope.match_value("#{Com::ConfigRelationType.table_name}.code",params[:code])
    config_relation_types,count = paginate(config_relation_types_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(config_relation_types.to_grid_json([:name,:description,:code],count))}
    end
  end
end
