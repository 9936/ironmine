class Irm::GroupMembersController < ApplicationController

  def new
    @group = Irm::Group.find(params[:id])
    @group_member = Irm::GroupMember.new(:group_id=>params[:id])
    @group_member.status_code = ""
  end

  def create
    @group = Irm::Group.find(params[:id])
    @group_member = Irm::GroupMember.new(params[:irm_group_member])
    respond_to do |format|
        if(@group_member.status_code.present?)
          @group_member.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Irm::GroupMember.create(:person_id=>id,:group_id=>@group.id)
        end
        format.html { redirect_to({:controller => "irm/groups",:action=>"show",:id=>@group.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @group_member, :status => :created}
      else
        @group_member.errors.add(:status_code,"")
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group_member.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def get_data
    group_members_scope= Irm::GroupMember.select_all.with_person(I18n.locale).where(:group_id=>params[:id])
    group_members_scope,count = paginate(group_members_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(group_members_scope.to_grid_json([:person_name,:organization_name,:email_address], count))}
    end
  end

  def get_memberable_data
    people_scope = Irm::Person.real.group_memberable(params[:id]).with_organization(I18n.locale)
    people_scope = people_scope.match_value("#{Irm::Person.table_name}.full_name",params[:person_name])
    people_scope = people_scope.match_value("#{Irm::Person.table_name}.email_address",params[:email_address])
    people_scope,count = paginate(people_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(people_scope.to_grid_json([:person_name,:email_address,:organization_name], count))}
    end
  end


  def delete
    @group_member = Irm::GroupMember.find(params[:id])
    @group_member.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"irm/groups",:action=>"show",:id=>@group_member.group_id}) }
      format.xml  { head :ok }
    end
  end


  def new_from_person
    @person = Irm::Person.find(params[:id])
    @group_member = Irm::GroupMember.new(:person_id=>params[:id])
    @group_member.status_code = ""
  end

  def create_from_person
    @person = Irm::Person.find(params[:id])
    @group_member = Irm::GroupMember.new(params[:irm_group_member])
    respond_to do |format|
      if(!@group_member.status_code.blank?)
        @group_member.status_code.split(",").delete_if{|i| i.blank?}.each do |id|
          Irm::GroupMember.create(:person_id=>@person.id,:group_id=>id)
        end
        format.html { redirect_to({:controller => "irm/people",:action=>"show",:id=>@person.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @support_group_member, :status => :created}
      else
        @support_group_member.errors.add(:status_code,"")
        format.html { render :action => "new_from_person" }
        format.xml  { render :xml => @group_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_groupable_data
    group_scope = Irm::Group.multilingual.enabled.select_all.group_memberable(params[:id])
    group_scope = group_scope.match_value("#{Irm::Group.table_name}.code",params[:code])
    group_scope = group_scope.match_value("#{Irm::Group.table_name}.name",params[:name])
    group_scope,count = paginate(group_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(group_scope.to_grid_json([:code,:name,:description], count))}
    end
  end

  def get_data_from_person
    group_code =  Irm::GroupMember.select_all.with_group(I18n.locale).where(:person_id=>params[:id])
    group_code,count = paginate(group_code)
    respond_to do |format|
      format.json {render :json=>to_jsonp(group_code.to_grid_json([:code,:name,:description], count))}
    end
  end

  def delete_from_person
    @group_member = Irm::GroupMember.find(params[:id])
    @group_member.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"irm/people",:action=>"show",:id=>@group_member.person_id}) }
      format.xml  { head :ok }
    end
  end

end
