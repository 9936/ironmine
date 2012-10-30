class Irm::SystemsController < ApplicationController
  layout "system_setting"

  def index
    sid = params[:sid]
    system = Irm::ExternalSystem.multilingual.enabled.find(sid)
    if system
      Irm::ExternalSystem.current_system = system
      session[:sid] = system.id
    end
    @profile = Irm::Profile.multilingual.with_user_license_name.find(Irm::Person.current.system_profile(sid).system_profile_id)
  end

  def show
    @external_system = Irm::ExternalSystem.current_system
    @external_system_person = Irm::ExternalSystemPerson.new
    @external_system_person.status_code=""
    respond_to do |format|
      format.html
      format.xml  { render :xml => @external_system }
    end
  end

  def add_people
    @external_system_person = Irm::ExternalSystemPerson.new(params[:irm_external_system_person])
    system_id = params[:sid]
    respond_to do |format|
      if @external_system_person.status_code.present?
        @external_system_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Irm::ExternalSystemPerson.create(:external_system_id => system_id,:person_id => id, :system_profile_id => params[:irm_external_system_person][:system_profile_id])
        end
      end
      format.html { redirect_to({:action=>"show", :sid => system_id }, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @external_system_person.errors, :status => :unprocessable_entity }
    end
  end

  def delete_people
    @external_system_person = Irm::ExternalSystemPerson.new(params[:irm_external_system_person])
    system_id = params[:sid]
    respond_to do |format|
      if @external_system_person.temp_id_string.present?
        @external_system_person.temp_id_string.split(",").delete_if{|i| i.blank?}.each do |id|
          esp = Irm::ExternalSystemPerson.where(:external_system_id => system_id,:person_id => id).first
          esp.destroy
        end
      end
      format.html { redirect_to({:action=>"show", :id => system_id}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @external_system_person.errors, :status => :unprocessable_entity }
    end
  end
end
