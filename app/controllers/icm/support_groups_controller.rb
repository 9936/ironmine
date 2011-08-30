class Icm::SupportGroupsController < ApplicationController
  # GET /support_groups
  # GET /support_groups.xml
  def index
    group_id = params[:group_id]
    group_id ||= Icm::SupportGroup.first_group_id
    @support_group = Icm::SupportGroup.where(:group_id=>group_id).first
    if @support_group.nil?
      @support_group = Icm::SupportGroup.new(:group_id=>group_id)
    end
    @group = Irm::Group.multilingual.query(group_id).first
  end

  # POST /support_groups
  # POST /support_groups.xml
  def create
    @support_group = Icm::SupportGroup.new(params[:icm_support_group])

    respond_to do |format|

      if @support_group.save
        @support_group.create_assignment_from_str
        format.html { redirect_to({:action=>"index",:group_id=>@support_group.group_id},:notice => (t :successfully_created))}
        format.xml  { render :xml => @support_group, :status => :created, :location => @support_group }
      else
        @group = Irm::Group.multilingual.find(@support_group.group_id)
        format.html { render "index" }
        format.xml  { render :xml => @support_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /support_groups/1
  # PUT /support_groups/1.xml
  def update
    @support_group = Icm::SupportGroup.find(params[:id])

    respond_to do |format|
      if @support_group.update_attributes(params[:icm_support_group])
        @support_group.create_assignment_from_str
        format.html { redirect_to({:action=>"index",:group_id=>@support_group.group_id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
      else
        @group = Irm::Group.multilingual.find(@support_group.group_id)
        format.html { render "index" }
        format.xml  { render :xml => @support_group.errors, :status => :unprocessable_entity }
      end
    end
  end


  def get_member_options
    support_group_members_scope= Irm::GroupMember.select_all.with_person(I18n.locale).assignable.query_by_support_group(params[:id])
    support_group_members = support_group_members_scope.collect{|p| {:label=>p[:person_name],:value=>p[:person_id]}}
    respond_to do |format|
      format.json {render :json=>support_group_members.to_grid_json([:label,:value],support_group_members.count)}
    end
  end

end
