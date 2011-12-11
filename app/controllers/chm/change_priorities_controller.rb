class Chm::ChangePrioritiesController < ApplicationController
  # GET /statuses
  # GET /statuses.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  {
        @change_priorities = Chm::ChangePriority.all
        render :xml => @change_priorities
      }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @change_priority = Chm::ChangePriority.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @change_priority }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @change_priority = Chm::ChangePriority.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_priority }
    end
  end

  # GET /statuses/1/edit
  def edit
    @change_priority = Chm::ChangePriority.multilingual.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_priority = Chm::ChangePriority.new(params[:chm_change_priority])

    respond_to do |format|
      if @change_priority.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @change_priority, :status => :created, :location => @change_priority }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @change_priority.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_priority = Chm::ChangePriority.find(params[:id])

    respond_to do |format|
      if @change_priority.update_attributes(params[:chm_change_priority])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_priority.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_priority = Chm::ChangePriority.find(params[:id])
    @change_priority.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @change_priority = Chm::ChangePriority.find(params[:id])
  end

  def multilingual_update
    @change_priority = Chm::ChangePriority.find(params[:id])
    @change_priority.not_auto_mult=true
    respond_to do |format|
      if @change_priority.update_attributes(params[:chm_change_priority])
        format.html { redirect_to({:action => "show"}, :notice => 'Status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_priority.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    change_priorities_scope = Chm::ChangePriority.multilingual.order("#{Chm::ChangePriority.table_name}.weight_values")
    change_priorities_scope = change_priorities_scope.match_value("#{Chm::ChangePriority.table_name}.name",params[:name])
    change_priorities_scope = change_priorities_scope.match_value("#{Chm::ChangePriority.table_name}.code",params[:code])
    change_priorities,count = paginate(change_priorities_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(change_priorities.to_grid_json([:name,:code,:display_sequence,:weight_values,:default_flag,:description,:status_meaning],count))}
    end
  end
end
