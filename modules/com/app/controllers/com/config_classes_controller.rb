class Com::ConfigClassesController < ApplicationController
  # GET /config_classes
  # GET /config_classes.xml
  def index
    @config_classes = Com::ConfigClass.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @config_classes }
    end
  end

  # GET /config_classes/1
  # GET /config_classes/1.xml
  def show
    @config_class = Com::ConfigClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @config_class }
    end
  end

  # GET /config_classes/new
  # GET /config_classes/new.xml
  def new
    @config_class = Com::ConfigClass.new(:leaf_flag => Irm::Constant::SYS_NO)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @config_class }
    end
  end

  # GET /config_classes/1/edit
  def edit
    @config_class = Com::ConfigClass.multilingual.find(params[:id])
  end

  # POST /config_classes
  # POST /config_classes.xml
  def create
    @config_class = Com::ConfigClass.new(params[:com_config_class])

    respond_to do |format|
      if @config_class.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @config_class, :status => :created, :location => @config_class }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @config_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /config_classes/1
  # PUT /config_classes/1.xml
  def update
    @config_class = Com::ConfigClass.find(params[:id])

    respond_to do |format|
      if @config_class.update_attributes(params[:com_config_class])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /config_classes/1
  # DELETE /config_classes/1.xml
  def destroy
    @config_class = Com::ConfigClass.find(params[:id])
    @config_class.destroy

    respond_to do |format|
      format.html { redirect_to(config_classes_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @config_class = Com::ConfigClass.find(params[:id])
  end

  def multilingual_update
    @config_class = Com::ConfigClass.find(params[:id])
    @config_class.not_auto_mult=true
    respond_to do |format|
      if @config_class.update_attributes(params[:com_config_class])
        format.html { redirect_to({:action => "show"}, :notice => 'Config class was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @config_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    config_classes_scope = Com::ConfigClass.multilingual
    config_classes_scope = config_classes_scope.match_value("#{Com::ConfigClass.table_name}.code",params[:code])
    config_classes_scope = config_classes_scope.match_value("#{Com::ConfigClassesTl.table_name}.name",params[:name])
    config_classes,count = paginate(config_classes_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(config_classes.to_grid_json([:code,:name,:description,:status_meaning],count))}
    end
  end
end
