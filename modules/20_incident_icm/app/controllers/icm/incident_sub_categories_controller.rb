class Icm::IncidentSubCategoriesController < ApplicationController
  # GET /incident_sub_categories
  # GET /incident_sub_categories.xml
  def index
    @incident_sub_categories = Icm::IncidentSubCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incident_sub_categories }
    end
  end

  # GET /incident_sub_categories/1
  # GET /incident_sub_categories/1.xml
  def show
    @incident_sub_category = Icm::IncidentSubCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incident_sub_category }
    end
  end

  # GET /incident_sub_categories/new
  # GET /incident_sub_categories/new.xml
  def new
    @incident_sub_category = Icm::IncidentSubCategory.new(:incident_category_id=>params[:category_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @incident_sub_category }
    end
  end

  # GET /incident_sub_categories/1/edit
  def edit
    @incident_sub_category = Icm::IncidentSubCategory.multilingual.find(params[:id])
  end

  # POST /incident_sub_categories
  # POST /incident_sub_categories.xml
  def create
    @incident_sub_category = Icm::IncidentSubCategory.new(params[:icm_incident_sub_category])

    respond_to do |format|
      if @incident_sub_category.save
        format.html { redirect_back_or_default({:controller=>"icm/incident_categories",:id=>@incident_sub_category.incident_category_id,:action=>"index"}) }
        format.xml  { render :xml => @incident_sub_category, :status => :created, :location => @incident_sub_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @incident_sub_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /incident_sub_categories/1
  # PUT /incident_sub_categories/1.xml
  def update
    @incident_sub_category = Icm::IncidentSubCategory.find(params[:id])

    respond_to do |format|
      if @incident_sub_category.update_attributes(params[:icm_incident_sub_category])
        format.html { redirect_back_or_default({:controller=>"icm/incident_categories",:id=>@incident_sub_category.incident_category_id,:action=>"index"}) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @incident_sub_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /incident_sub_categories/1
  # DELETE /incident_sub_categories/1.xml
  def destroy
    @incident_sub_category = Icm::IncidentSubCategory.find(params[:id])
    @incident_sub_category.destroy

    respond_to do |format|
      format.html { redirect_back_or_default({:controller=>"icm/incident_categories",:id=>@incident_sub_category.incident_category_id,:action=>"index"}) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @incident_sub_category = Icm::IncidentSubCategory.find(params[:id])
  end

  def multilingual_update
    @incident_sub_category = Icm::IncidentSubCategory.find(params[:id])
    @incident_sub_category.not_auto_mult=true
    respond_to do |format|
      if @incident_sub_category.update_attributes(params[:icm_incident_sub_category])
        format.html { redirect_back_or_default({:controller=>"icm/incident_categories",:id=>@incident_sub_category.incident_category_id,:action=>"index"}) }
        format.xml  { head :ok }
      else
        format.html { render :action => "multilingual_edit" }
        format.xml  { render :xml => @incident_sub_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    incident_sub_categories_scope = Icm::IncidentSubCategory.multilingual
    incident_sub_categories_scope = incident_sub_categories_scope.match_value("incident_sub_category.name",params[:name])
    incident_sub_categories,count = paginate(incident_sub_categories_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(incident_sub_categories.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  def get_option
    incident_sub_categories_scope = Icm::IncidentSubCategory.multilingual.enabled.where(:incident_category_id=>params[:incident_category_id])
    incident_sub_categories_scope = incident_sub_categories_scope.collect{|i| {:label=>i[:name], :value=>i.id,:id=>i.id}}
    respond_to do |format|
      format.json {render :json=>incident_sub_categories_scope.to_grid_json([:label, :value],incident_sub_categories_scope.count)}
    end
  end
end
