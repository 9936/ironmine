class Slm::TimeTriggersController < ApplicationController
  # GET /slm/time_triggers
  # GET /slm/time_triggers.xml
  def index
    @time_triggers = Slm::TimeTrigger.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @time_triggers }
    end
  end

  # GET /slm/time_triggers/1
  # GET /slm/time_triggers/1.xml
  def show
    @time_trigger = Slm::TimeTrigger.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @time_trigger }
    end
  end

  # GET /slm/time_triggers/new
  # GET /slm/time_triggers/new.xml
  def new
    @time_trigger = Slm::TimeTrigger.new(:service_agreement_id=>params[:service_agreement_id])
    @time_trigger.duration_percent = 20
    @service_agreement = Slm::ServiceAgreement.multilingual.status_meaning.find(params[:service_agreement_id])
    @service_agreement.untransform_time

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @time_trigger }
    end
  end

  # GET /slm/time_triggers/1/edit
  def edit
    @time_trigger = Slm::TimeTrigger.find(params[:id])
    @service_agreement = Slm::ServiceAgreement.multilingual.status_meaning.find(@time_trigger.service_agreement_id)
  end

  # POST /slm/time_triggers
  # POST /slm/time_triggers.xml
  def create
    @time_trigger = Slm::TimeTrigger.new(params[:slm_time_trigger])
    respond_to do |format|
      if @time_trigger.save
        format.html { redirect_to({:controller=>"slm/service_agreements",:action => "show",:id=>params[:service_agreement_id]}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @time_trigger, :status => :created, :location => @time_trigger }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @time_trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /slm/time_triggers/1
  # PUT /slm/time_triggers/1.xml
  def update
    @time_trigger = Slm::TimeTrigger.find(params[:id])

    respond_to do |format|
      if @time_trigger.update_attributes(params[:slm_time_trigger])
        format.html { redirect_to({:controller=>"slm/service_agreements",:action => "show",:id=>@time_trigger.service_agreement_id},  :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @time_trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /slm/time_triggers/1
  # DELETE /slm/time_triggers/1.xml
  def destroy
    @time_trigger = Slm::TimeTrigger.find(params[:id])
    @time_trigger.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"slm/service_agreements",:action => "show",:id=>@time_trigger.service_agreement_id}) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @time_trigger = Slm::TimeTrigger.find(params[:id])
  end

  def multilingual_update
    @time_trigger = Slm::TimeTrigger.find(params[:id])
    @time_trigger.not_auto_mult=true
    respond_to do |format|
      if @time_trigger.update_attributes(params[:slm_time_trigger])
        format.html { redirect_to({:action => "show"}, :notice => 'Time trigger was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @time_trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    slm_time_triggers_scope = Slm::TimeTrigger.multilingual
    slm_time_triggers_scope = slm_time_triggers_scope.match_value("slm_time_trigger.name",params[:name])
    slm_time_triggers,count = paginate(slm_time_triggers_scope)
    respond_to do |format|
      format.html  {
        @datas = slm_time_triggers
        @count = count
      }
      format.json {render :json=>to_jsonp(slm_time_triggers.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  def add_exists_action

  end
end
