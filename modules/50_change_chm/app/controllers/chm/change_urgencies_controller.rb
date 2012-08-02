class Chm::ChangeUrgenciesController < ApplicationController
  # GET /statuses
  # GET /statuses.xml
  def index
    @change_urgencies = Chm::ChangeUrgency.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @change_urgencies }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @change_urgency = Chm::ChangeUrgency.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @change_urgency }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @change_urgency = Chm::ChangeUrgency.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_urgency }
    end
  end

  # GET /statuses/1/edit
  def edit
    @change_urgency = Chm::ChangeUrgency.multilingual.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_urgency = Chm::ChangeUrgency.new(params[:chm_change_urgency])

    respond_to do |format|
      if @change_urgency.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @change_urgency, :status => :created, :location => @change_urgency }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @change_urgency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_urgency = Chm::ChangeUrgency.find(params[:id])

    respond_to do |format|
      if @change_urgency.update_attributes(params[:chm_change_urgency])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_urgency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_urgency = Chm::ChangeUrgency.find(params[:id])
    @change_urgency.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @change_urgency = Chm::ChangeUrgency.find(params[:id])
  end

  def multilingual_update
    @change_urgency = Chm::ChangeUrgency.find(params[:id])
    @change_urgency.not_auto_mult=true
    respond_to do |format|
      if @change_urgency.update_attributes(params[:chm_change_urgency])
        format.html { redirect_to({:action => "show"}, :notice => 'Status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_urgency.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    change_urgencies_scope = Chm::ChangeUrgency.multilingual.order("#{Chm::ChangeUrgency.table_name}.display_sequence")
    change_urgencies_scope = change_urgencies_scope.match_value("#{Chm::ChangeUrgency.table_name}.name",params[:name])
    change_urgencies_scope = change_urgencies_scope.match_value("#{Chm::ChangeUrgency.table_name}.code",params[:code])
    change_urgencies,count = paginate(change_urgencies_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(change_urgencies.to_grid_json([:name,:code,:display_sequence,:weight_values,:default_flag,:description,:status_meaning],count))}
      format.html  {
        @count = count
        @datas = change_urgencies
      }
    end
  end
end
