class Icm::SystemSupportGroupsController < ApplicationController
  def index
    @external_system = Irm::ExternalSystem.current_system
    respond_to do |format|
      format.html
      format.xml  { render :xml => @external_system }
    end
  end

  def get_data
    sid = params[:sid]

    system_group_scope = Icm::ExternalSystemGroup.with_groups(I18n.locale).with_system(sid)
    system_group_scope = system_group_scope.match_value("#{Irm::Group.view_name}.name ", params[:group_name]) if params[:group_name]
    system_groups,count = paginate(system_group_scope)

    support_group_ids = system_groups.collect(&:support_group_id)
    @support_group_systems_hash = Icm::ExternalSystemGroup.with_system_count(support_group_ids).index_by(&:support_group_id)


    respond_to do |format|
      format.html  {
        @datas = system_groups
        @count = count
      }
    end
  end

  def show
    system_group = Icm::ExternalSystemGroup.find(params[:id])
    @support_group = Icm::SupportGroup.find(system_group.support_group_id)
    @group = Irm::Group.multilingual.query(@support_group.group_id).first

    respond_to do |format|
      format.html
      format.xml  { render :xml => @support_group }
    end
  end

  def add_people
    add_person_ids = params[:add_person_ids].split(",").delete_if{|i| i.blank?}

    add_person_ids.each do |id|
      Irm::GroupMember.create(:person_id=>id,:group_id=> params[:group_id])
    end if add_person_ids.present? and params[:group_id]
    respond_to do |format|
      format.html { redirect_to({:action=>"show",:id => params[:id], :sid => params[:sid] }, :notice => t(:successfully_created)) }
    end
  end

  def delete_people
    gm = Irm::GroupMember.find(params[:group_member_id])
    gm.destroy if gm

    respond_to do |format|
      format.html { redirect_to({:action=>"show",:id => params[:id], :sid => params[:sid] }, :notice => t(:successfully_created)) }
    end
  end

  def get_owned_people_data
    group_members_scope = Irm::GroupMember.select_all.with_person(I18n.locale).where(:group_id=>params[:group_id])
    group_members_scope,count = paginate(group_members_scope)
    #
    person_ids = group_members_scope.collect(&:person_id)
    #查找用户在多少个系统中
    @person_systems_count_hash = Irm::ExternalSystemPerson.with_systems_count(person_ids).index_by(&:person_id)
    #查找用户在多少个组中
    @person_groups_count_hash = Irm::GroupMember.with_groups_count(person_ids).index_by(&:person_id)

    #检查用户是否在系统中
    @person_system_delete_hash = Irm::ExternalSystemPerson.with_delete_flag(person_ids, params[:sid]).index_by(&:person_id)


    respond_to do |format|
      format.html  {
        @datas = group_members_scope
        @count = count
      }
    end
  end

  def get_available_people_data
    people_scope = Irm::Person.real.group_memberable(params[:group_id]).with_organization(I18n.locale).with_external_system(params[:sid])
    people_scope = people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:person_name])
    people_scope = people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])
    people_scope,count = paginate(people_scope)
    respond_to do |format|
      format.html  {
        @count = count
        @datas = people_scope
      }
      format.json {render :json=>to_jsonp(people_scope.to_grid_json([:person_name,:email_address,:organization_name], count))}
    end
  end


end