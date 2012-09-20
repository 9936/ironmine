class Chm::ChangeIncidentRelationsController < ApplicationController
  layout "application_full"

  # GET /statuses/new
  # GET /statuses/new.xml
  def new

    @change_request = Chm::ChangeRequest.find(params[:change_request_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_task_template }
    end
  end


  # POST /statuses
  # POST /statuses.xml
  def create
    @change_request = Chm::ChangeRequest.find(params[:change_request_id])

    if params[:incident_request_id].present?
      relation = Chm::ChangeIncidentRelation.new(:change_request_id=>@change_request.id,:incident_request_id=>params[:incident_request_id])
      relation.save if relation.valid?
    end

  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_request = Chm::ChangeRequest.find(params[:change_request_id])
    unless params[:incident_request_id].eql?(@change_request.incident_request_id)
      change_incident_relation = Chm::ChangeIncidentRelation.where(:change_request_id=>@change_request.id,:incident_request_id=>params[:incident_request_id]).first
      change_incident_relation.destroy if change_incident_relation.present?
    end

  end


  def incident_requests
    return_columns = [:request_number,
                      :title,
                      :organization_name,
                      :incident_status_name,
                      :requested_name,
                      :priority_name,
                      :external_system_name]

    change_request_id = params[:change_request_id]

    incident_requests_scope = Icm::IncidentRequest.list_all.filter_system_ids(Irm::Person.current.system_ids).where("NOT EXISTS(SELECT 1 FROM #{Chm::ChangeIncidentRelation.table_name} WHERE #{Chm::ChangeIncidentRelation.table_name}.change_request_id=? AND #{Chm::ChangeIncidentRelation.table_name}.incident_request_id = #{Icm::IncidentRequest.table_name}.id)",change_request_id)

    respond_to do |format|
      format.json {
        incident_requests,count = paginate(incident_requests_scope)
        render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count))
      }
      format.xml {
        incident_requests,count = paginate(incident_requests_scope)
        render :xml => incident_requests
      }
    end
  end


end
