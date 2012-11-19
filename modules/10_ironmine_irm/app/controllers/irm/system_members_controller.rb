class Irm::SystemMembersController < ApplicationController
  def index
    @external_system = Irm::ExternalSystem.current_system
    @external_system_person = Irm::ExternalSystemPerson.new
    @external_system_person.status_code=""
    respond_to do |format|
      format.html
      format.xml  { render :xml => @external_system }
    end
  end

  def get_owned_members_data
    member_scope = Irm::Person.with_organization(I18n.locale).with_external_system(params[:sid])
    member_scope = member_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    member_scope = member_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    member_scope = member_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    members, count = paginate(member_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(members.to_grid_json([:full_name, :email_address, :organization_name],count))}
      format.html {
        @datas = members
        @count = count
      }
    end
  end

  def get_available_people_data
    ava_people_scope = Irm::Person.with_organization(I18n.locale).without_external_system(params[:sid])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Organization.view_name}.name", params[:organization_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:full_name])
    ava_people_scope = ava_people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])

    people, count = paginate(ava_people_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(people.to_grid_json([:full_name, :email_address, :organization_name],count))}
      format.html {
        @datas = people
        @count = count
      }
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
      format.html { redirect_to({:action=>"index", :sid => system_id }, :notice => t(:successfully_created)) }
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
      format.html { redirect_to({:action=>"index", :sid => system_id}, :notice => t(:successfully_created)) }
      format.xml  { render :xml => @external_system_person.errors, :status => :unprocessable_entity }
    end
  end

end