class Irm::ReportTriggersController < ApplicationController
  # GET /report_triggers
  # GET /report_triggers.xml
  def index
    redirect_to({:controller => "irm/reports",:action => "index"})
  end


  # GET /report_triggers/new
  # GET /report_triggers/new.xml
  def new
    @report_trigger = Irm::ReportTrigger.where(:report_id=>params[:report_id]).first
    if(@report_trigger)
      redirect_to(:action => "edit",:id=>@report_trigger.id)
      return
    end

    @report_trigger = Irm::ReportTrigger.new(:report_id=>params[:report_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report_trigger }
    end
  end

  # GET /report_triggers/1/edit
  def edit
    @report_trigger = Irm::ReportTrigger.find(params[:id])
  end

  # POST /report_triggers
  # POST /report_triggers.xml
  def create
    @report_trigger = Irm::ReportTrigger.new(params[:irm_report_trigger])
    @report_trigger.time_mode= YAML.dump(params[:time_mode_obj])
    respond_to do |format|
      if @report_trigger.save
        @report_trigger.create_receiver_from_str
        format.html { redirect_to({:controller=>"irm/reports",:action => "show",:id=>@report_trigger.report_id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report_trigger, :status => :created, :location => @report_trigger }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report_trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /report_triggers/1
  # PUT /report_triggers/1.xml
  def update
    @report_trigger = Irm::ReportTrigger.find(params[:id])
    @report_trigger.time_mode= YAML.dump(params[:time_mode_obj])
    respond_to do |format|
      if @report_trigger.update_attributes(params[:irm_report_trigger])
        @report_trigger.create_receiver_from_str
        format.html { redirect_to({:controller=>"irm/reports"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /report_triggers/1
  # DELETE /report_triggers/1.xml
  def destroy
    @report_trigger = Irm::ReportTrigger.find(params[:id])
    @report_trigger.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"irm/reports",:action => "show",:id=>@report_trigger.report_id}, :notice => t(:successfully_updated)) }
      format.xml  { head :ok }
    end
  end

end
