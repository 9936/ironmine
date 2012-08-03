class Chm::ChangeTaskPhasesController < ApplicationController
  # GET /statuses
  # GET /statuses.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { @change_task_phases = Chm::ChaneTaskPhase.all
                    render :xml => @change_task_phases 
      }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @change_task_phase = Chm::ChangeTaskPhase.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @change_task_phase }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @change_task_phase = Chm::ChangeTaskPhase.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_task_phase }
    end
  end

  # GET /statuses/1/edit
  def edit
    @change_task_phase = Chm::ChangeTaskPhase.multilingual.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_task_phase = Chm::ChangeTaskPhase.new(params[:chm_change_task_phase])

    respond_to do |format|
      if @change_task_phase.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @change_task_phase, :status => :created, :location => @change_task_phase }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @change_task_phase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_task_phase = Chm::ChangeTaskPhase.find(params[:id])

    respond_to do |format|
      if @change_task_phase.update_attributes(params[:chm_change_task_phase])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_task_phase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_task_phase = Chm::ChangeTaskPhase.find(params[:id])
    @change_task_phase.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @change_task_phase = Chm::ChangeTaskPhase.find(params[:id])
  end

  def multilingual_update
    @change_task_phase = Chm::ChangeTaskPhase.find(params[:id])
    @change_task_phase.not_auto_mult=true
    respond_to do |format|
      if @change_task_phase.update_attributes(params[:chm_change_task_phase])
        format.html { redirect_to({:action => "show"}, :notice => 'Status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_task_phase.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    change_task_phases_scope = Chm::ChangeTaskPhase.multilingual.order("#{Chm::ChangeTaskPhase.table_name}.display_sequence")
    change_task_phases_scope = change_task_phases_scope.match_value("#{Chm::ChangeTaskPhase.table_name}.name",params[:name])
    change_task_phases_scope = change_task_phases_scope.match_value("#{Chm::ChangeTaskPhase.table_name}.code",params[:code])
    change_task_phases,count = paginate(change_task_phases_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(change_task_phases.to_grid_json([:name,:code,:display_sequence,:description,:status_meaning],count))}
      format.html  {
        @count = count
        @datas = change_task_phases
      }
    end
  end
end
