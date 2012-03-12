class Irm::OrganizationsController < ApplicationController
  layout "uid"
  # GET /organizations
  # GET /organizations.xml
  def index
    all_organizations = Irm::Organization.with_parent(I18n.locale).multilingual

    grouped_organizations = all_organizations.collect{|i| [i.id,i.parent_org_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    organizations = {}
    all_organizations.each do |ao|
      organizations.merge!({ao.id=>ao})
    end
    @leveled_organizations = []

    proc = Proc.new{|parent_id,level|
      if(grouped_organizations[parent_id.to_s]&&grouped_organizations[parent_id.to_s].any?)

        grouped_organizations[parent_id.to_s].each do |o|
          organizations[o[0]].level = level
          @leveled_organizations << organizations[o[0]]

          proc.call(organizations[o[0]].id,level+1)
        end
      end
    }


    grouped_organizations["blank"].each do |go|
      organizations[go[0]].level = 1
      @leveled_organizations << organizations[go[0]]
      proc.call(organizations[go[0]].id,2)
    end

    unless params[:mode].present?
      params[:mode] = cookies['organization_view']
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @leveled_organizations }
      format.json {
         render :json=>to_jsonp(@leveled_organizations.to_grid_json([:id,:name,:parent_org_id,:short_name,:parent_org_name,:description],@leveled_organizations.size))
      }
    end
  end

  def show
    @organization = Irm::Organization.multilingual.with_parent(I18n.locale).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.xml
  def new
    @organization = Irm::Organization.new
    if params[:parent_id].present?
        @organization.parent_org_id =  params[:parent_id]
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
    @organization = Irm::Organization.multilingual.find(params[:id])
  end

  # POST /organizations
  # POST /organizations.xml
  def create
    @organization = Irm::Organization.new(params[:irm_organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to({:action=>"index"},:notice => (t :successfully_created))}
        format.xml  { render :xml => @organization, :status => :created, :location => @organization }
      else
        format.html { render "new" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.xml
  def update
    @organization = Irm::Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:irm_organization])
        format.html { redirect_to({:action=>"index"},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
      else
        @error = @organization
        format.html { render "edit" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  def multilingual_edit
    @organization = Irm::Organization.find(params[:id])
  end

  def multilingual_update
    @organization = Irm::Organization.find(params[:id])
    @organization.not_auto_mult=true
    respond_to do |format|
      if @organization.update_attributes(params[:irm_organization])
        format.html { render({:action=>"show"}) }
      else
        format.html { render({:action=>"multilingual_edit"}) }
      end
    end
  end
end
