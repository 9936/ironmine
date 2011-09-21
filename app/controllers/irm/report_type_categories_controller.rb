class Irm::ReportTypeCategoriesController < ApplicationController
  # GET /report_type_categories
  # GET /report_type_categories.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @report_type_categories }
    end
  end

  # GET /report_type_categories/1
  # GET /report_type_categories/1.xml
  def show
    @report_type_category = Irm::ReportTypeCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report_type_category }
    end
  end

  # GET /report_type_categories/new
  # GET /report_type_categories/new.xml
  def new
    @report_type_category = Irm::ReportTypeCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report_type_category }
    end
  end

  # GET /report_type_categories/1/edit
  def edit
    @report_type_category = Irm::ReportTypeCategory.multilingual.find(params[:id])
  end

  # POST /report_type_categories
  # POST /report_type_categories.xml
  def create
    @report_type_category = Irm::ReportTypeCategory.new(params[:irm_report_type_category])

    respond_to do |format|
      if @report_type_category.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report_type_category, :status => :created, :location => @report_type_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report_type_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /report_type_categories/1
  # PUT /report_type_categories/1.xml
  def update
    @report_type_category = Irm::ReportTypeCategory.find(params[:id])

    respond_to do |format|
      if @report_type_category.update_attributes(params[:irm_report_type_category])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_type_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /report_type_categories/1
  # DELETE /report_type_categories/1.xml
  def destroy
    @report_type_category = Irm::ReportTypeCategory.find(params[:id])
    @report_type_category.destroy

    respond_to do |format|
      format.html { redirect_to(report_type_categories_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @report_type_category = Irm::ReportTypeCategory.find(params[:id])
  end

  def multilingual_update
    @report_type_category = Irm::ReportTypeCategory.find(params[:id])
    @report_type_category.not_auto_mult=true
    respond_to do |format|
      if @report_type_category.update_attributes(params[:irm_report_type_category])
        format.html { redirect_to({:action => "show"}, :notice => t(:successfully_created)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_type_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    report_type_categories_scope = Irm::ReportTypeCategory.multilingual
    report_type_categories_scope = report_type_categories_scope.match_value("#{Irm::ReportTypeCategoriesTl.table_name}.name",params[:name])
    report_type_categories_scope = report_type_categories_scope.match_value("#{Irm::ReportTypeCategory.table_name}.code",params[:code])
    report_type_categories,count = paginate(report_type_categories_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(report_type_categories.to_grid_json([:name,:description,:code],count))}
    end
  end
end
