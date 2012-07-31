class Icm::IncidentStatusesController < ApplicationController
  def index
    @incident_status = Icm::IncidentStatus.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incident_status }
    end
  end

  def show
    @incident_status = Icm::IncidentStatus.multilingual.with_phase.status_meaning.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incident_status }
    end
  end

  def new
    @incident_status = Icm::IncidentStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @incident_status }
    end
  end

  def edit
    @incident_status = Icm::IncidentStatus.multilingual.find(params[:id])
  end

  def create
    @incident_status = Icm::IncidentStatus.new(params[:icm_incident_status])
    respond_to do |format|
      if @incident_status.save
         format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
      else
         format.html { render :action=>"new" }
      end
    end
  end

  def update
    @incident_status = Icm::IncidentStatus.find(params[:id])

    respond_to do |format|
      if @incident_status.update_attributes(params[:icm_incident_status])
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_updated)) }
      else
        format.html { render :action=>"edit" }
      end
    end
  end

  def multilingual_edit
    @incident_status = Icm::IncidentStatus.find(params[:id])
  end

  def multilingual_update
    @incident_status = Icm::IncidentStatus.find(params[:id])
    @incident_status.not_auto_mult=true
    respond_to do |format|
      if @incident_status.update_attributes(params[:icm_incident_status])
        format.html { render({:action=>"show"}, :notice => t(:successfully_updated)) }
      else
        format.html { render({:action=>"multilingual_edit"}) }
      end
    end
  end

  def get_data
    incident_statuses_scope = Icm::IncidentStatus.multilingual.with_phase.status_meaning
    incident_statuses_scope = incident_statuses_scope.match_value("#{Icm::IncidentPhase.view_name}.name",params[:phase_name])
    incident_statuses_scope = incident_statuses_scope.match_value("#{Icm::IncidentStatus.table_name}.incident_status_code",params[:incident_status_code])
    incident_statuses_scope = incident_statuses_scope.match_value("#{Icm::IncidentStatusesTl.table_name}.name",params[:name])
    incident_statuses,count = paginate(incident_statuses_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(incident_statuses.to_grid_json([:phase_name,:incident_status_code,:name,:display_sequence,:close_flag,:permanent_close_flag,:default_flag,:status_meaning], count)) }
      format.html  {
        @count = count
        @datas = incident_statuses
      }
    end
  end

  def edit_transform
  end

  def update_transform
    if(params[:status_transforms])
      params[:status_transforms].each do |from_status_id,to_statuses|
        to_statuses.each do |to_status_id,event|
          exists_status_transform = Icm::StatusTransform.where(:from_status_id=>from_status_id,:to_status_id=>to_status_id).first
          if(exists_status_transform)
            if(event.present?)
              exists_status_transform.update_attribute(:event_code,event)
            else
              exists_status_transform.destroy
            end
          else
            Icm::StatusTransform.create(:from_status_id=>from_status_id,:to_status_id=>to_status_id,:event_code=>event) if(event.present?)
          end
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
    end
  end
end
