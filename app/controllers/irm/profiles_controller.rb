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
    @profile = Irm::Profile.multilingual.find(params[:id])
    @kanbans = Irm::Profile.owned_kanbans(params[:id])

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
    @profile = Irm::Profile.multilingual.find(params[:id])
  end

  # POST /profiles
  # POST /profiles.xml
  def create
    @profile = Irm::Profile.new(params[:irm_profile])

    respond_to do |format|
      if @profile.valid?
        @profile.create_from_application_ids(params[:applications],params[:default_application_id])
        @profile.create_from_function_ids(params[:functions])
        @profile.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
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

  def add_kanban
    @profile_kanban = Irm::ProfileKanban.new
    @profile = Irm::Profile.find(params[:profile_id])
  end

  def create_kanban
    @profile_kanban = Irm::ProfileKanban.new(params[:irm_profile_kanban])
    @profile = Irm::Profile.find(params[:profile_id])

    respond_to do |format|
      if @profile_kanban.valid? && @profile_kanban.save
        format.html { redirect_to({:action => "show", :id => params[:profile_id]}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @profile_kanban, :status => :created, :location => @profile_kanban }
      else
        format.html { render :action => "add_kanban"}
        format.xml  { render :xml => @profile_kanban.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit_kanban
    @profile_kanban = Irm::ProfileKanban.select_all.with_position_name.where("#{Irm::ProfileKanban.table_name}.id=?", params[:pk_id]).first
    @profile = Irm::Profile.find(params[:profile_id])
  end

  def update_kanban
    @profile_kanban = Irm::ProfileKanban.find(params[:pk_id])
    respond_to do |format|
      if @profile_kanban.update_attributes(params[:irm_kanban_profile])
        format.html { redirect_to({:action => "show", :id => params[:profile_id]}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        @profile_kanban = Irm::ProfileKanban.select_all.with_position_name.where("#{Irm::ProfileKanban.table_name}.id=?", params[:pk_id]).first
        @profile = Irm::Profile.find(params[:profile_id])
        format.html { render :action => "edit_kanban" }
        format.xml  { render :xml => @profile_kanban.errors, :status => :unprocessable_entity }
      end
    end
  end

  def remove_kanban
    @profile_kanban = Irm::ProfileKanban.find(params[:pk_id])
    profile_id = @profile_kanban.profile_id
    @profile_kanban.destroy

    respond_to do |format|
      format.html { redirect_to({:action => "show", :id=>profile_id})}
    end
  end
end
