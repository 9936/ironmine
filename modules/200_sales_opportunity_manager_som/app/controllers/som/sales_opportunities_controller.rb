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
    if(current_person?(@sales_opportunity.created_by)||current_person?(@sales_opportunity.charge_person))
      @sales_opportunity.destroy
    end

    respond_to do |format|
      format.html { redirect_to(:action=>"index") }
      format.xml { head :ok }
    end
  end


  def get_data
    if cookies[:sales_role].present?
      params[:sales_role] = cookies[:sales_role]
      cookies[:sales_role]=nil
    end

    if cookies[:sales_status].present?
      params[:sales_status] = cookies[:sales_status]
      cookies[:sales_status]=nil
    end
    sales_role=""
    sales_opportunities_scope = Som::SalesOpportunity.list_all
    sales_opportunities_scope = sales_opportunities_scope.match_value("#{Som::SalesOpportunity.table_name}.name", params[:name])

    unless params[:sales_role].nil?
      #对人员进行过滤
      params[:sales_role]||=[]
      unless params[:sales_role].include?("all")
        role_filters=params[:sales_role].split(",")
        sales_opportunities_scope = sales_opportunities_scope.as_person_role(role_filters,Irm::Person.current.id)
      end

      #对状态进行过滤
      if params[:sales_status] && !params[:sales_status].include?("ALL")
        status_filters=params[:sales_status]
        sales_opportunities_scope = sales_opportunities_scope.as_status(status_filters)
      end
    end

    if params[:order_name]&&params[:order_value]
      case params[:order_name]
        when "start_at"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.start_at #{params[:order_value]}")
        when "end_at"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.end_at #{params[:order_value]}")
        when "sales_status"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.sales_status #{params[:order_value]}")
        when "price"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.price #{params[:order_value]}")
        when "second_price"
          sales_opportunities_scope = sales_opportunities_scope.order("#{Som::SalesOpportunity.table_name}.second_price  #{params[:order_value]}")
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


  def edit_reason
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])

  end

  def update_reason
    @sales_opportunity = Som::SalesOpportunity.find(params[:id])
    @sales_opportunity.update_attributes(params[:som_sales_opportunity])
  end
end
