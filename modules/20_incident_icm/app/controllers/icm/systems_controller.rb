class Icm::SystemsController < ApplicationController

  def index

  end

  def edit_transform

  end

  def get_status_data
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

  def update_transform
    sid = Irm::ExternalSystem.current_system.id
    if sid.present? and params[:status_transforms]
      params[:status_transforms].each do |from_status_id,to_statuses|
        to_statuses.each do |to_status_id,event|
          exists_status_transform = Icm::StatusTransform.with_sid(sid).where(:from_status_id=>from_status_id,:to_status_id=>to_status_id).first
          if exists_status_transform
            if event.present?
              exists_status_transform.update_attribute(:event_code,event)
            else
              exists_status_transform.destroy
            end
          else
            Icm::StatusTransform.create(:sid => sid, :from_status_id=>from_status_id,:to_status_id=>to_status_id,:event_code=>event) if(event.present?)
          end
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
    end
  end
end