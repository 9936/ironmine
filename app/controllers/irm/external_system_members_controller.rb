class Irm::ExternalSystemMembersController < ApplicationController
  def index
    if params[:external_system_id]
      session[:external_system_id] = params[:external_system_id]
      @external_system_id = params[:external_system_id]
    else

      @external_system_id = session[:external_system_id]
      unless @external_system_id.present?
        first_system = Irm::ExternalSystem.enabled.first
        @external_system_id ||= first_system.id if first_system
      end
      @external_system_id ||="0"
    end

    @external_system_person = Irm::ExternalSystemPerson.new
    @external_system_person.status_code=""

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @external_system_id }
    end
  end

  def get_owned_members_data
    member_scope = Irm::Person.
                      with_organization(I18n.locale).
                      with_external_system(params[:external_system_id])
    member_scope = member_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    member_scope = member_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    member_scope = member_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    members, count = paginate(member_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(members.to_grid_json(
                                              [:full_name, :email_address, :organization_name],
                                              count))}
    end
  end

  def get_available_people_data
    ava_people_scope = Irm::Person.
                      with_organization(I18n.locale).
                      without_external_system(params[:external_system_id])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    people, count = paginate(ava_people_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(people.to_grid_json(
                                              [:full_name, :email_address, :organization_name],
                                              count))}
    end
  end

  def add_people
    @external_system_person = Irm::ExternalSystemPerson.new(params[:irm_external_system_person])

    respond_to do |format|
      if(!@external_system_person.status_code.blank?)
        @external_system_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Irm::ExternalSystemPerson.create(:external_system_id => params[:external_system_id],:person_id => id)
        end
      end
      format.html { redirect_to({:action=>"index", :external_system_id => params[:external_system_id]}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @external_system_person.errors, :status => :unprocessable_entity }
    end
  end

  def delete_people
    @external_system_person = Irm::ExternalSystemPerson.new(params[:irm_external_system_person])

    respond_to do |format|
      if(!@external_system_person.temp_id_string.blank?)
        @external_system_person.temp_id_string.split(",").delete_if{|i| i.blank?}.each do |id|
          esp = Irm::ExternalSystemPerson.where(:external_system_id => params[:external_system_id],:person_id => id).first
          esp.destroy
        end
      end
      format.html { redirect_to({:action=>"index", :external_system_id => params[:external_system_id]}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @external_system_person.errors, :status => :unprocessable_entity }
    end
  end

  def get_available_external_system_data
    external_systems_scope = Irm::ExternalSystem.multilingual.enabled.without_person(params[:person_id])
    external_systems_scope = external_systems_scope.match_value("irm_external_systems.system_name",params[:system_name])
    external_systems_scope = external_systems_scope.match_value("irm_external_systems.external_system_code",params[:external_system_code])
    external_systems,count = paginate(external_systems_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(external_systems.to_grid_json([:external_system_code,:external_hostname,:external_ip_address,
                                                                         :system_name,:system_description,:status_meaning],count))}
    end
  end

  def new_from_person
    @person = Irm::Person.find(params[:person_id])
    @system_person = Irm::ExternalSystemPerson.new(:person_id=>params[:person_id])
    @system_person.status_code = ""
  end

  def create_from_person
    @person = Irm::Person.find(params[:person_id])
    @system_person = Irm::ExternalSystemPerson.new(params[:irm_external_system_person])
    respond_to do |format|
      if(!@system_person.status_code.blank?)
        @system_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          external_system = Irm::ExternalSystem.find(id)
          Irm::ExternalSystemPerson.create(:person_id=>@person.id,:external_system_id=>external_system.id)
        end
        format.html { redirect_to({:controller => "irm/people",:action=>"show",:id=>@person.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @system_person, :status => :created}
      else
        @system_person.errors.add(:status_code,"")
        format.html { render :action => "new_from_person" }
        format.xml  { render :xml => @system_person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete_from_person
    system_person =
        Irm::ExternalSystemPerson.
            where(:external_system_id => params[:external_system_id]).
            where(:person_id => params[:person_id])
    system_person.each do |sp|
      sp.destroy
    end

    respond_to do |format|
      format.html { redirect_to({:controller=>"irm/people",:action=>"show",:id=>params[:person_id]}) }
      format.xml  { head :ok }
    end
  end
end