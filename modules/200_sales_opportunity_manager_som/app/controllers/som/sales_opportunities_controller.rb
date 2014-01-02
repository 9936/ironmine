class Som::SalesOpportunitiesController < ApplicationController
  layout "application_full"
  # GET /som/sales_opportunities
  # GET /som/sales_opportunities.xml
  def index
    @sales_opportunities = Som::SalesOpportunity.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sales_opportunities }
    end
  end

  # GET /som/sales_opportunities/1
  # GET /som/sales_opportunities/1.xml
  def show
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sales_opportunity }
    end
  end

  # GET /som/sales_opportunities/new
  # GET /som/sales_opportunities/new.xml
  def new
    @sales_opportunity = Som::SalesOpportunity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sales_opportunity }
    end
  end

  # GET /som/sales_opportunities/1/edit
  def edit
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
  end

  # POST /som/sales_opportunities
  # POST /som/sales_opportunities.xml
  def create
    @sales_opportunity = Som::SalesOpportunity.new(params[:som_sales_opportunity])
    binding.pry
    respond_to do |format|
      if @sales_opportunity.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @sales_opportunity, :status => :created, :location => @sales_opportunity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @som_sales_opportunity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /som/sales_opportunities/1
  # PUT /som/sales_opportunities/1.xml
  def update
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])

    respond_to do |format|
      if @som_sales_opportunity.update_attributes(params[:sales_opportunity])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @som_sales_opportunity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /som/sales_opportunities/1
  # DELETE /som/sales_opportunities/1.xml
  def destroy
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
    @som_sales_opportunity.destroy

    respond_to do |format|
      format.html { redirect_to(som_sales_opportunities_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
  end

  def multilingual_update
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
    @sales_opportunity.not_auto_mult=true
    respond_to do |format|
      if @som_sales_opportunity.update_attributes(params[:sales_opportunity])
        format.html { redirect_to({:action => "show"}, :notice => 'Sales opportunity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @som_sales_opportunity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    sales_opportunities_scope = Som::SalesOpportunity.multilingual
    sales_opportunities_scope = sales_opportunities_scope.match_value("\#{Rails::Generators::ActiveModel.table_name}.name",params[:name])
    sales_opportunities,count = paginate(sales_opportunities_scope)
    respond_to do |format|
      format.html  {
        @datas = sales_opportunities
        @count = count
      }
      format.json {render :json=>to_jsonp(sales_opportunities.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
