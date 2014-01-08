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

    #sales_status: "Cancel", current_possibility: "60%", current_progress: "70%"
    respond_to do |format|
      if @communicate_info.save
        #保存沟通人员信息
        #我方人员
        if cookies[:our_persons].present?&&cookies[:our_roles].present?
          our_persons = cookies[:our_persons]
          our_roles = cookies[:our_roles]
          our_persons.split(",").each_with_index do |our_person,index|
            Som::ParticipationInfo.create(:name_id=>our_person,:role_id=>our_roles.split(",")[index],:communicate_id=>@communicate_info.id)
          end
        end
        #客户人员
        if cookies[:client_persons].present?&&cookies[:client_roles].present?
          client_persons = cookies[:client_persons]
          client_roles = cookies[:client_roles]
          client_persons.split(",").each_with_index do |client_person,index|
            Som::ParticipationInfo.create(:name_id=>client_person,:role_id=>client_roles.split(",")[index],:client_flag=>"Y",:communicate_id=>@communicate_info.id)
          end
        end
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
