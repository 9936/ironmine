class Som::SalesOpportunitiesController < ApplicationController
  layout "application_full"
  # GET /som/sales_opportunities
  # GET /som/sales_opportunities.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /som/sales_opportunities/1
  # GET /som/sales_opportunities/1.xml
  def show
    @sales_opportunity = Som::SalesOpportunity.query(params[:id]).list_all.first

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @sales_opportunity }
    end
  end

  # GET /som/sales_opportunities/new
  # GET /som/sales_opportunities/new.xml
  def new
    @sales_opportunity = Som::SalesOpportunity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @sales_opportunity }
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
    respond_to do |format|
      if @sales_opportunity.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml { render :xml => @sales_opportunity, :status => :created, :location => @sales_opportunity }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @som_sales_opportunity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /som/sales_opportunities/1
  # PUT /som/sales_opportunities/1.xml
  def update
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
    respond_to do |format|
      if @sales_opportunity.update_attributes(params[:som_sales_opportunity])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @sales_opportunity.errors, :status => :unprocessable_entity }
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
      format.xml { head :ok }
    end
  end


  def get_data
    if cookies[:sales_role].present?
      params[:sales_role] = cookies[:sales_role]
    end

    if cookies[:sales_status].present?
      params[:sales_status] = cookies[:sales_status]
    end

    sales_opportunities_scope = Som::SalesOpportunity.list_all
    sales_opportunities_scope = sales_opportunities_scope.match_value("#{Som::SalesOpportunity.table_name}.name", params[:name])

    unless params[:sales_role].nil?
    #对人员进行过滤
    unless params[:sales_role].include?("all")
      if params[:sales_role].include?("charge")
          sales_opportunities_scope = sales_opportunities_scope.as_charge_preson
      end
    end

    #对状态进行过滤
    if params[:sales_status] && !params[:sales_status].include?("all")
      if params[:sales_status].include?("quote") #报价
        sales_opportunities_scope = sales_opportunities_scope.as_quote_status
      elsif params[:sales_status].include?("project") #方案
        sales_opportunities_scope = sales_opportunities_scope.as_project_status
      elsif params[:sales_status].include?("bid") #投标
        sales_opportunities_scope = sales_opportunities_scope.as_bid_status
      elsif params[:sales_status].include?("business") #商务
        sales_opportunities_scope = sales_opportunities_scope.as_business_status
      elsif params[:sales_status].include?("cancel") #取消
        sales_opportunities_scope = sales_opportunities_scope.as_cancel_status
      end
    end
    end
    sales_opportunities, count = paginate(sales_opportunities_scope)
    respond_to do |format|
      format.html {
        @datas = sales_opportunities
        @count = count
      }
      format.json { render :json => to_jsonp(sales_opportunities.to_grid_json([:name, :description, :status_meaning], count)) }
    end
  end
end
