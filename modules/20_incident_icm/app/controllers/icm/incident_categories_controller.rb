class Icm::IncidentCategoriesController < ApplicationController
  # GET /incident_categories
  # GET /incident_categories.xml
  def index
    @incident_categories = Icm::IncidentCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incident_categories }
    end
  end

  # GET /incident_categories/1
  # GET /incident_categories/1.xml
  def show
    @incident_category = Icm::IncidentCategory.list_all.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incident_category }
    end
  end

  # GET /incident_categories/new
  # GET /incident_categories/new.xml
  def new
    @incident_category = Icm::IncidentCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @incident_category }
    end
  end

  # GET /incident_categories/1/edit
  def edit
    @incident_category = Icm::IncidentCategory.multilingual.find(params[:id])
  end

  # POST /incident_categories
  # POST /incident_categories.xml
  def create
    @incident_category = Icm::IncidentCategory.new(params[:icm_incident_category])

    respond_to do |format|
      if @incident_category.valid?
        @incident_category.create_system_from_str
        @incident_category.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @incident_category, :status => :created, :location => @incident_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @incident_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /incident_categories/1
  # PUT /incident_categories/1.xml
  def update
    @incident_category = Icm::IncidentCategory.find(params[:id])
    @incident_category.attributes = params[:icm_incident_category]
    respond_to do |format|
      if @incident_category.valid?
        @incident_category.create_system_from_str
        @incident_category.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @incident_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /incident_categories/1
  # DELETE /incident_categories/1.xml
  def destroy
    @incident_category = Icm::IncidentCategory.find(params[:id])
    @incident_category.destroy

    respond_to do |format|
      format.html { redirect_to(incident_categories_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @incident_category = Icm::IncidentCategory.find(params[:id])
  end

  def multilingual_update
    @incident_category = Icm::IncidentCategory.find(params[:id])
    @incident_category.not_auto_mult=true
    respond_to do |format|
      if @incident_category.update_attributes(params[:icm_incident_category])
        format.html { redirect_to({:action => "show"}, :notice => 'Incident category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @incident_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    if Irm::Person.current.login_name.eql?("ironmine")
        incident_categories_scope = Icm::IncidentCategory.list_all.order_with_name
    elsif params[:external_system_name].blank?
      incident_categories_scope = Icm::IncidentCategory.list_all.order_with_name.
          query_with_system_ids_and_self(Irm::Person.current.system_ids, Irm::Person.current.id)
    else
      incident_categories_scope = Icm::IncidentCategory.list_all.order_with_name.
          query_with_system_ids_and_self_and_name(Irm::Person.current.system_ids, Irm::Person.current.id, params[:external_system_name])
    end
    incident_categories_scope = incident_categories_scope.match_value("#{Icm::IncidentCategoriesTl.table_name}.name",params[:name])
    incident_categories,count = paginate(incident_categories_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(incident_categories.to_grid_json([:code,:name,:description,:external_system_name,:status_meaning],count))}
      format.html  {
        @count = count
        @datas = incident_categories
      }
    end
  end

  def get_option
    incident_categories_scope = Icm::IncidentCategory.multilingual.enabled.query_by_system(params[:external_system_id])
    incident_categories_scope = incident_categories_scope.collect{|i| {:label=>i[:name], :value=>i.id,:id=>i.id}}
    respond_to do |format|
      format.json {render :json=>incident_categories_scope.to_grid_json([:label, :value],incident_categories_scope.count)}
    end
  end
end
