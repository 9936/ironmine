class Chm::ChangeStatusesController < ApplicationController
  # GET /statuses
  # GET /statuses.xml
  def index
    @change_statuses = Chm::ChangeStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @statuses }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @change_status = Chm::ChangeStatus.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @change_status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @change_status = Chm::ChangeStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @change_status = Chm::ChangeStatus.multilingual.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_status = Chm::ChangeStatus.new(params[:chm_change_status])

    respond_to do |format|
      if @change_status.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @change_status, :status => :created, :location => @change_status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @change_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_status = Chm::ChangeStatus.find(params[:id])

    respond_to do |format|
      if @change_status.update_attributes(params[:chm_change_status])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_status = Chm::ChangeStatus.find(params[:id])
    @change_status.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @change_status = Chm::ChangeStatus.find(params[:id])
  end

  def multilingual_update
    @change_status = Chm::ChangeStatus.find(params[:id])
    @change_status.not_auto_mult=true
    respond_to do |format|
      if @change_status.update_attributes(params[:chm_change_status])
        format.html { redirect_to({:action => "show"}, :notice => 'Status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    change_statuses_scope = Chm::ChangeStatus.multilingual.order("#{Chm::ChangeStatus.table_name}.display_sequence")
    change_statuses_scope = change_statuses_scope.match_value("#{Chm::ChangeStatus.table_name}.name",params[:name])
    change_statuses_scope = change_statuses_scope.match_value("#{Chm::ChangeStatus.table_name}.code",params[:code])
    change_statuses,count = paginate(change_statuses_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(change_statuses.to_grid_json([:name,:code,:display_sequence,:default_flag,:description,:status_meaning],count))}
      format.html  {
        @count = count
        @datas = change_statuses
      }
    end
  end
end
