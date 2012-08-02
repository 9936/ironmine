class Icm::IncidentConfigRelationsController < ApplicationController
  layout "bootstrap_application_full"

  def create
    @incident_request = Icm::IncidentRequest.find(params[:incident_request_id])

    if params[:config_item_id].present?
      relation = Icm::IncidentConfigRelation.new(:incident_request_id=>@incident_request.id,:config_item_id=>params[:config_item_id])
      relation.save if relation.valid?
    end

  end

  def destroy
    relation = Icm::IncidentConfigRelation.find(params[:id])

    @incident_request = Icm::IncidentRequest.find(relation.incident_request_id)

    relation.destroy
  end


end
