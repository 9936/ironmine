class Chm::ChangeConfigRelationsController < ApplicationController
  layout "application_full"

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_request = Chm::ChangeRequest.find(params[:change_request_id])

    if params[:config_item_id].present?
      relation = Chm::ChangeConfigRelation.new(:change_request_id=>@change_request.id,:config_item_id=>params[:config_item_id])
      relation.save if relation.valid?
    end

  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    relation =  Chm::ChangeConfigRelation.find(params[:id])
    @change_request = Chm::ChangeRequest.find(relation.change_request_id)
    relation.destroy
  end




end
