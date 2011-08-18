class Uid::ExternalSystemMembersController < ApplicationController
  def index
    if params[:external_system_code]
      session[:external_system_code] = params[:external_system_code]
      @external_system_code = params[:external_system_code]
    else
      @external_system_code = session[:external_system_code]||
          Uid::ExternalSystem.enabled.first.external_system_code
    end

    @external_system_person = Uid::ExternalSystemPerson.new
    @external_system_person.status_code=""

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @external_system_code }
    end
  end

  def get_owned_members_data
    member_scope = Irm::Person.
                      with_company(I18n.locale).
                      with_organization(I18n.locale).
                      with_department(I18n.locale).
                      with_external_system(params[:external_system_code])
    member_scope = member_scope.match_value("#{Irm::Company.view_name}.name", params[:company_name])
    member_scope = member_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    member_scope = member_scope.match_value("#{Irm::Department.view_name}.name", params[:department_name])

    member_scope = member_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    member_scope = member_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    members, count = paginate(member_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(members.to_grid_json(
                                              [:full_name, :email_address, :company_name, :organization_name, :department_name],
                                              count))}
    end
  end

  def get_available_people_data
    ava_people_scope = Irm::Person.
                      with_company(I18n.locale).
                      with_organization(I18n.locale).
                      with_department(I18n.locale).
                      without_external_system(params[:external_system_code])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Company.view_name}.name", params[:company_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Department.view_name}.name", params[:department_name])

    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    people, count = paginate(ava_people_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(people.to_grid_json(
                                              [:full_name, :email_address, :company_name, :organization_name, :department_name],
                                              count))}
    end
  end

  def add_people
    @external_system_person = Uid::ExternalSystemPerson.new(params[:uid_external_system_person])

    respond_to do |format|
      if(!@external_system_person.status_code.blank?)
        @external_system_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Uid::ExternalSystemPerson.create(:external_system_code => params[:external_system_code],:person_id => id)
        end
      end
      format.html { redirect_to({:action=>"index", :external_system_code => params[:external_system_code]}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @external_system_person.errors, :status => :unprocessable_entity }
    end
  end

  def delete_people
    @external_system_person = Uid::ExternalSystemPerson.new(params[:uid_external_system_person])

    respond_to do |format|
      if(!@external_system_person.temp_id_string.blank?)
        @external_system_person.temp_id_string.split(",").delete_if{|i| i.blank?}.each do |id|
          esp = Uid::ExternalSystemPerson.where(:external_system_code => params[:external_system_code],:person_id => id).first
          esp.destroy
        end
      end
      format.html { redirect_to({:action=>"index", :external_system_code => params[:external_system_code]}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @external_system_person.errors, :status => :unprocessable_entity }
    end
  end

  def get_available_external_system_data
    external_systems_scope = Uid::ExternalSystem.multilingual.enabled.without_person(params[:person_id])
    external_systems_scope = external_systems_scope.match_value("uid_external_systems.system_name",params[:system_name])
    external_systems_scope = external_systems_scope.match_value("uid_external_systems.external_system_code",params[:external_system_code])
    external_systems_scope = external_systems_scope.match_value("uid_external_systems.external_hostname",params[:hostname])
    external_systems_scope = external_systems_scope.match_value("uid_external_systems.external_ip_address",params[:external_ip_address])
    external_systems,count = paginate(external_systems_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(external_systems.to_grid_json([:external_system_code,:external_hostname,:external_ip_address,
                                                                         :system_name,:system_description,:status_meaning],count))}
    end
  end

  def new_from_person
    @person = Irm::Person.find(params[:person_id])
    @system_person = Uid::ExternalSystemPerson.new(:person_id=>params[:person_id])
    @system_person.status_code = ""
  end

  def create_from_person
    @person = Irm::Person.find(params[:person_id])
    @system_person = Uid::ExternalSystemPerson.new(params[:uid_external_system_person])
    respond_to do |format|
      if(!@system_person.status_code.blank?)
        @system_person.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          external_system = Uid::ExternalSystem.find(id)
          Uid::ExternalSystemPerson.create(:person_id=>@person.id,:external_system_code=>external_system.external_system_code)
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
        Uid::ExternalSystemPerson.
            where(:external_system_code => params[:external_system_code]).
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