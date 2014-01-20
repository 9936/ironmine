class Som::PotentialCustomersController < ApplicationController
  layout "application_full"
  # GET /som/potential_customers
  # GET /som/potential_customers.xml
  def index
    @potential_customers = Som::PotentialCustomer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @potential_customers }
    end
  end

  # GET /som/potential_customers/1
  # GET /som/potential_customers/1.xml
  def show
    @potential_customer = Som::PotentialCustomer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @potential_customer }
    end
  end

  # GET /som/potential_customers/new
  # GET /som/potential_customers/new.xml
  def new
    @potential_customer = Som::PotentialCustomer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @potential_customer }
    end
  end

  # GET /som/potential_customers/1/edit
  def edit
    @potential_customer = Som::PotentialCustomer.find(params[:id])
  end

  # POST /som/potential_customers
  # POST /som/potential_customers.xml
  def create
    @potential_customer = Som::PotentialCustomer.new(params[:som_potential_customer])
    respond_to do |format|
      if @potential_customer.save

        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @potential_customer, :status => :created, :location => @potential_customer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @potential_customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /som/potential_customers/1
  # PUT /som/potential_customers/1.xml
  def update
    @potential_customer = Som::PotentialCustomer.find(params[:id])

    respond_to do |format|
      if @potential_customer.update_attributes(params[:som_potential_customer])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @potential_customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /som/potential_customers/1
  # DELETE /som/potential_customers/1.xml
  def destroy
    @potential_customer = Som::PotentialCustomer.find(params[:id])
    @som_potential_customer.destroy

    respond_to do |format|
      format.html { redirect_to(som_potential_customers_url) }
      format.xml  { head :ok }
    end
  end



  def get_data
    potential_customers_scope = Som::PotentialCustomer
    potential_customers_scope = potential_customers_scope.match_value("#{Som::PotentialCustomer.table_name}.name",params[:name])
    potential_customers,count = paginate(potential_customers_scope)
    respond_to do |format|
      format.html  {
        @datas = potential_customers
        @count = count
      }
      format.json {render :json=>to_jsonp(potential_customers.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  def new_modal
    @potential_customer = Som::PotentialCustomer.new
  end

  def create_modal
    @potential_customer = Som::PotentialCustomer.new(params[:som_potential_customer])
    @potential_customer.save
  end

  def get_options
    @potential_customers = Som::PotentialCustomer.all
    @potential_customers = @potential_customers.collect{|i| {:label=>i.full_name,:value=>i.id}}
    respond_to do |format|
      format.json {render :json=>@potential_customers.to_grid_json([:label,:value],@potential_customers.length)}
    end
  end
end
