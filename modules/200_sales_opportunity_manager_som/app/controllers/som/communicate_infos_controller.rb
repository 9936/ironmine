class Som::CommunicateInfosController < ApplicationController
  # GET /som/communicate_infos
  # GET /som/communicate_infos.xml
  def index
    @communicate_infos = Som::CommunicateInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @communicate_infos }
    end
  end

  # GET /som/communicate_infos/1
  # GET /som/communicate_infos/1.xml
  def show
    @communicate_info = Som::CommunicateInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @communicate_info }
    end
  end

  # GET /som/communicate_infos/new
  # GET /som/communicate_infos/new.xml
  def new
    @communicate_info = Som::CommunicateInfo.new
    sales_opportunity=Som::SalesOpportunity.find(params[:id])
    @communicate_info.sales_status=sales_opportunity.sales_status
    @communicate_info.current_possibility=sales_opportunity.possibility
    @communicate_info.current_progress=sales_opportunity.progress

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @communicate_info }
    end
  end

  # GET /som/communicate_infos/1/edit
  def edit
    @communicate_info = Som::CommunicateInfo.find(params[:id])
  end

  # POST /som/communicate_infos
  # POST /som/communicate_infos.xml
  def create
    @communicate_info = Som::CommunicateInfo.new(params[:som_communicate_info])
    #同步预销售表的状态,进度,可能性
    #if cookies[:our_persons].present?
    #  params[:our_persons] = cookies[:our_persons]
    #end

    respond_to do |format|
      if @som_communicate_info.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @communicate_info, :status => :created, :location => @communicate_info }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @som_communicate_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /som/communicate_infos/1
  # PUT /som/communicate_infos/1.xml
  def update
    @communicate_info = Som::CommunicateInfo.find(params[:id])

    respond_to do |format|
      if @som_communicate_info.update_attributes(params[:communicate_info])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @som_communicate_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /som/communicate_infos/1
  # DELETE /som/communicate_infos/1.xml
  def destroy
    @communicate_info = Som::CommunicateInfo.find(params[:id])
    @som_communicate_info.destroy

    respond_to do |format|
      format.html { redirect_to(som_communicate_infos_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    communicate_infos_scope = Som::CommunicateInfo.multilingual
    communicate_infos_scope = communicate_infos_scope.match_value("\#{Rails::Generators::ActiveModel.table_name}.name",params[:name])
    communicate_infos,count = paginate(communicate_infos_scope)
    respond_to do |format|
      format.html  {
        @datas = communicate_infos
        @count = count
      }
      format.json {render :json=>to_jsonp(communicate_infos.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
