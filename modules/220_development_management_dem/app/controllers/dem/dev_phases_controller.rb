class Dem::DevPhasesController < ApplicationController
  def index

  end

  def show

  end

  def new

  end

  def edit

  end

  def create

  end

  def update

  end

  def destroy
    @dev_phase = Dem::DevPhase.find(params[:id])
    tid = @dev_phase.dev_management_id
    @dev_phase.destroy
    Dem::DevManagement.find(tid).update_trigger
    respond_to do |format|
      format.html { redirect_to({:controller => "dem/dev_managements",
                                 :action => "edit", :id => tid},
                                :notice => t(:successfully_updated)) }
      format.xml { head :ok }
    end
  end
end
