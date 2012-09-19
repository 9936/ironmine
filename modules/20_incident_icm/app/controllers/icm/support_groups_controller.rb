class Icm::SupportGroupsController < ApplicationController
  # GET /support_groups
  # GET /support_groups.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
    params[:step] = 1
    @support_group = Icm::SupportGroup.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @support_group }
    end
  end

  def edit
    @support_group = Icm::SupportGroup.find(params[:id])
    @group = Irm::Group.multilingual.query(@support_group.group_id).first

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @support_group }
    end
  end

  def show
    @support_group = Icm::SupportGroup.find(params[:id])
    @group = Irm::Group.multilingual.query(@support_group.group_id).first

    respond_to do |format|
      format.html
      format.xml  { render :xml => @support_group }
    end
  end

  def get_data
    support_group_scope = Icm::SupportGroup
    support_groups,count = paginate(support_group_scope)
    respond_to do |format|
      format.html  {
        @datas = support_groups
        @count = count
      }
      format.json {render :json=>to_jsonp(assign_rules.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  # POST /support_groups
  # POST /support_groups.xml
  def create
    respond_to do |format|
      @support_group = Icm::SupportGroup.new(params[:icm_support_group])
      if params[:step].present? and params[:step].to_s.eql?("2")
        if @support_group.save
          format.html { redirect_to({:action=>"index",:group_id=>@support_group.group_id},:notice => (t :successfully_created))}
          format.xml  { render :xml => @support_group, :status => :created, :location => @support_group }
        else
          @group = Irm::Group.multilingual.find(@support_group.group_id)
          format.html { render "new" }
          format.xml  { render :xml => @support_group.errors, :status => :unprocessable_entity }
        end
      else
        params[:step] = 2 if @support_group.group_id.present?
        @group = Irm::Group.multilingual.query(@support_group.group_id).first
        format.html { render "new" }
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


  def get_pass_member_options
    support_group_members_scope= Irm::GroupMember.select_all.with_person(I18n.locale).assignable.query_by_support_group(params[:id])
    support_group_members = support_group_members_scope.collect{|p| {:label=>p[:person_name],:value=>p[:person_id]}}
    support_group_members.delete_if{|sgm| Irm::Person.current.eql?(sgm[:value])}
    respond_to do |format|
      format.json {render :json=>support_group_members.to_grid_json([:label,:value],support_group_members.count)}
    end
  end

end
