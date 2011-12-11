class Chm::ChangeImpactsController < ApplicationController
  # GET /statuses
  # GET /statuses.xml
  def index
    @change_impacts = Chm::ChangeImpact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @change_impacts }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @change_impact = Chm::ChangeImpact.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @change_impact }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @change_impact = Chm::ChangeImpact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_impact }
    end
  end

  # GET /statuses/1/edit
  def edit
    @change_impact = Chm::ChangeImpact.multilingual.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_impact = Chm::ChangeImpact.new(params[:chm_change_impact])

    respond_to do |format|
      if @change_impact.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @change_impact, :status => :created, :location => @change_impact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @change_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_impact = Chm::ChangeImpact.find(params[:id])

    respond_to do |format|
      if @change_impact.update_attributes(params[:chm_change_impact])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_impact = Chm::ChangeImpact.find(params[:id])
    @change_impact.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @change_impact = Chm::ChangeImpact.find(params[:id])
  end

  def multilingual_update
    @change_impact = Chm::ChangeImpact.find(params[:id])
    @change_impact.not_auto_mult=true
    respond_to do |format|
      if @change_impact.update_attributes(params[:chm_change_impact])
        format.html { redirect_to({:action => "show"}, :notice => 'Status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    change_impacts_scope = Chm::ChangeImpact.multilingual.order("#{Chm::ChangeImpact.table_name}.display_sequence")
    change_impacts_scope = change_impacts_scope.match_value("#{Chm::ChangeImpact.table_name}.name",params[:name])
    change_impacts_scope = change_impacts_scope.match_value("#{Chm::ChangeImpact.table_name}.code",params[:code])
    change_impacts,count = paginate(change_impacts_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(change_impacts.to_grid_json([:name,:code,:display_sequence,:weight_values,:default_flag,:description,:status_meaning],count))}
    end
  end
end
