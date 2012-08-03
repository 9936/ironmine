class Irm::ApplicationsController < ApplicationController
  # GET /applications
  # GET /applications.xml
  def index
    @applications = Irm::Application.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @applications }
    end
  end

  # GET /applications/1
  # GET /applications/1.xml
  def show
    @application = Irm::Application.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @application }
    end
  end

  # GET /applications/new
  # GET /applications/new.xml
  def new
    @application = Irm::Application.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @application }
    end
  end

  # GET /applications/1/edit
  def edit
    @application = Irm::Application.multilingual.find(params[:id])
  end

  # POST /applications
  # POST /applications.xml
  def create
    @application = Irm::Application.new(params[:irm_application])

    respond_to do |format|
      if @application.valid?
        @application.create_tabs_from_str
        @application.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @application, :status => :created, :location => @application }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /applications/1
  # PUT /applications/1.xml
  def update
    @application = Irm::Application.find(params[:id])
    @application.attributes = params[:irm_application]
    respond_to do |format|
      if @application.valid?
        @application.create_tabs_from_str
        @application.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.xml
  def destroy
    @application = Irm::Application.find(params[:id])
    @application.destroy

    respond_to do |format|
      format.html { redirect_to(applications_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @application = Irm::Application.find(params[:id])
  end

  def multilingual_update
    @application = Irm::Application.find(params[:id])
    @application.not_auto_mult=true
    respond_to do |format|
      if @application.update_attributes(params[:irm_application])
        format.html { redirect_to({:action => "show"}, :notice => 'Application was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @application.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    applications_scope = Irm::Application.multilingual
    applications_scope = applications_scope.match_value("#{Irm::ApplicationsTl.table_name}.name",params[:name])
    applications_scope = applications_scope.match_value("#{Irm::ApplicationsTl.table_name}.description",params[:description])
    applications_scope = applications_scope.match_value("#{Irm::Application.table_name}.code",params[:code])
    applications,count = paginate(applications_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(applications.to_grid_json([:code,:name,:description],count))}
      format.html {
        @count = count
        @datas = applications
      }
    end
  end
end
