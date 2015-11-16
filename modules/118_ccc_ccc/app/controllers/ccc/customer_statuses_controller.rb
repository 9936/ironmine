class Ccc::CustomerStatusesController < ApplicationController
  layout "uid"
  # GET /industries
  # GET /industries.xml
  def index
    @customerStatuses = Ccc::CustomerStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customerStatuses }
    end
  end

  def show

    @customerStatus = Ccc::CustomerStatus.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customerStatus }
    end
  end

  # GET /industries/new
  # GET /industries/new.xml
  def new
    @customerStatus = Ccc::CustomerStatus.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customerStatus }
    end
  end

  # GET /industries/1/edit
  def edit
    @customerStatus = Ccc::CustomerStatus.multilingual.find(params[:id])
  end

  # POST /industries
  # POST /industries.xml
  def create
    @customerStatus = Ccc::CustomerStatus.new(params[:ccc_customer_status])
    respond_to do |format|
      if @customerStatus.valid? && @customerStatus.save
        format.html { redirect_to({:action => "show", :id => @customerStatus}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @customerStatus, :status => :created, :location => @customerStatus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customerStatus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /industries/1
  # PUT /industries/1.xml
  def update
    @customerStatus = Ccc::CustomerStatus.find(params[:id])

    respond_to do |format|
      if @customerStatus.update_attributes(params[:ccc_customer_status])
        format.html { redirect_to({:action=>"show", :id=>@customerStatus.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@customerStatus}
      else
        @error = @customerStatus
        format.html { render "edit" }
        format.xml  { render :xml => @customerStatus.errors, :status => :unprocessable_entity }
        format.json  { render :json => @customerStatus.errors}
      end
    end
  end


  def get_data
    industries_scope = Ccc::CustomerStatus.multilingual
    industries_scope = industries_scope.match_value("#{Ccc::CustomerStatus.table_name}.code",params[:code])
    industries_scope = industries_scope.match_value("#{Ccc::CustomerStatusesTl.table_name}.name",params[:name])
    industries_scope = industries_scope.match_value("#{Ccc::CustomerStatusesTl.table_name}.description",params[:description])
    industries,count = paginate(industries_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(industries.to_grid_json([:name,:description,:code],count))}
      format.html  {
        @count = count
        @datas = industries
      }
    end
  end

  def multilingual_edit
    @customerStatus = Ccc::CustomerStatus.find(params[:id])
  end

  def multilingual_update
    @customerStatus = Ccc::CustomerStatus.find(params[:id])
    @customerStatus.not_auto_mult=true
    respond_to do |format|
      if @customerStatus.update_attributes(params[:ccc_customer_status])
        format.html { redirect_to({:action => "show"}, :notice => 'ConnType was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customerStatus.errors, :status => :unprocessable_entity }
      end
    end
  end
end
