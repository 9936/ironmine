class Chm::ChangePlanTypesController < ApplicationController
  # GET /statuses
  # GET /statuses.xml
  def index
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { @change_plan_types = Chm::ChangePlanType.all
                    render :xml => @change_plan_types 
      }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @change_plan_type = Chm::ChangePlanType.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @change_plan_type }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @change_plan_type = Chm::ChangePlanType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_plan_type }
    end
  end

  # GET /statuses/1/edit
  def edit
    @change_plan_type = Chm::ChangePlanType.multilingual.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_plan_type = Chm::ChangePlanType.new(params[:chm_change_plan_type])

    respond_to do |format|
      if @change_plan_type.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @change_plan_type, :status => :created, :location => @change_plan_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @change_plan_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_plan_type = Chm::ChangePlanType.find(params[:id])

    respond_to do |format|
      if @change_plan_type.update_attributes(params[:chm_change_plan_type])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_plan_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_plan_type = Chm::ChangePlanType.find(params[:id])
    @change_plan_type.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @change_plan_type = Chm::ChangePlanType.find(params[:id])
  end

  def multilingual_update
    @change_plan_type = Chm::ChangePlanType.find(params[:id])
    @change_plan_type.not_auto_mult=true
    respond_to do |format|
      if @change_plan_type.update_attributes(params[:chm_change_plan_type])
        format.html { redirect_to({:action => "show"}, :notice => 'Status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_plan_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    change_plan_types_scope = Chm::ChangePlanType.multilingual.order("#{Chm::ChangePlanType.table_name}.display_sequence")
    change_plan_types_scope = change_plan_types_scope.match_value("#{Chm::ChangePlanType.table_name}.name",params[:name])
    change_plan_types_scope = change_plan_types_scope.match_value("#{Chm::ChangePlanType.table_name}.code",params[:code])
    change_plan_types,count = paginate(change_plan_types_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(change_plan_types.to_grid_json([:name,:code,:display_sequence,:description,:status_meaning],count))}
    end
  end
end
