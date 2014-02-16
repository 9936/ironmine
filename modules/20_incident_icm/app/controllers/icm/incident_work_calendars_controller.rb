class Icm::IncidentWorkCalendarsController < ApplicationController
  layout "application_full"
  def new
    @incident_work_calendar = Icm::IncidentWorkCalendar.incident_work_calendar(params[:sid])
  end

  def create
    @incident_work_calendar = Icm::IncidentWorkCalendar.incident_work_calendar(params[:icm_incident_work_calendar][:external_system_id])
    @incident_work_calendar.attributes = params[:icm_incident_work_calendar]

    respond_to do |format|
      if @incident_work_calendar.save
        format.html { redirect_to({:action => "show",:id=>@incident_work_calendar.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @incident_work_calendar, :status => :created, :location => @incident_work_calendar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @incident_work_calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @incident_work_calendar = Icm::IncidentWorkCalendar.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @incident_work_calendar }
    end
  end

  def recalculate
    Icm::IncidentJournalElapse.recalculate_distance_by_system(params[:sid])
    redirect_to({:action=>"new"})

  end

end
