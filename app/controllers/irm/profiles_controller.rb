class Irm::ProfilesController < ApplicationController
  # GET /profiles
  # GET /profiles.xml
  def index
    @profiles = Irm::Profile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = Irm::Profile.multilingual.with_kanban.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.xml
  def new
    @profile = Irm::Profile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = Irm::Profile.multilingual.with_kanban.find(params[:id])
  end

  # POST /profiles
  # POST /profiles.xml
  def create
    @profile = Irm::Profile.new(params[:irm_profile])
    existing_profile = Irm::Profile.find(params[:existing_profile])
    @profile.user_license = existing_profile.user_license
    @profile.opu_id = existing_profile.opu_id
    respond_to do |format|
      if @profile.valid? && @profile.save
        @profile.clone_application_relation_from_profile(existing_profile)
        @profile.clone_function_relation_from_profile(existing_profile)
        @profile.clone_kanban_relation_from_profile(existing_profile)

        format.html { redirect_to({:action => "show", :id => @profile}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    @profile = Irm::Profile.find(params[:id])
    @profile.attributes = params[:irm_profile]

    respond_to do |format|
      if @profile.valid?
        @profile.create_from_application_ids(params[:applications],params[:default_application_id])
        @profile.create_from_function_ids(params[:functions])
        @profile.save
        check_profile_kanban = Irm::ProfileKanban.check_exists(params[:id], params[:ir_kanban], "INCIDENT_REQUEST_PAGE")
        if check_profile_kanban
          check_profile_kanban.update_attribute(:kanban_id, params[:ir_kanban])
        else
          t = Irm::ProfileKanban.create({:profile_id => params[:id], :kanban_id => params[:ir_kanban]})
          t.save
        end if params[:ir_kanban].present?
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.xml
  def destroy
    @profile = Irm::Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to(profiles_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @profile = Irm::Profile.find(params[:id])
  end

  def multilingual_update
    @profile = Irm::Profile.find(params[:id])
    @profile.not_auto_mult=true
    respond_to do |format|
      if @profile.update_attributes(params[:irm_profile])
        format.html { redirect_to({:action => "show"}, :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    profiles_scope = Irm::Profile.multilingual
    profiles_scope = profiles_scope.match_value("profile.name",params[:name])
    profiles,count = paginate(profiles_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(profiles.to_grid_json([:name,:description,:code],count))}
    end
  end
end
