class Irm::SystemsController < ApplicationController

  def index
    sid = params[:sid]
    system = Irm::ExternalSystem.multilingual.enabled.find(sid)
    if system.present?
      Irm::ExternalSystem.current_system = system
      session[:sid] = system.id
    end
    @external_system = system
    @profile = Irm::Profile.multilingual.with_user_license_name.find(Irm::Person.current.system_profile(sid).system_profile_id)
  end

  #def edit
  #  @external_system = Irm::ExternalSystem.multilingual.find(params[:sid])
  #end
  #
  #def update
  #  @external_system = Irm::ExternalSystem.find(params[:sid])
  #
  #  respond_to do |format|
  #    if @external_system.update_attributes(params[:irm_external_system])
  #      format.html { redirect_to({:action=>"show", :sid => params[:sid]}, :notice => t(:successfully_updated)) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @external_system.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

end
