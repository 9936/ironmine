class Mam::SystemsController < ApplicationController
  layout 'application'
  # GET /incident_requests
  # GET /incident_requests.xml
  def index
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
    end
  end

  # GET /incident_requests/1
  # GET /incident_requests/1.xml
  def show

    @system = Mam::System.select_all.status_meaning.find(params[:id])

    respond_to do |format|
      format.html { render :layout => "application_full" }# show.html.erb
      format.xml { render :xml => @system }
    end
  end

  # GET /incident_requests/new
  # GET /incident_requests/new.xml
  def new
    @system = Mam::System.new()
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
      format.xml { render :xml => @system }
    end
  end

  def create
    @system = Mam::System.new(params[:mam_system])
    respond_to do |format|
      if @system.save
        format.html { redirect_to({:action=>"index"}, :notice =>t(:successfully_created)) }
        format.xml  { render :xml => @system, :status => :created, :location => @system }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @system.errors, :status => :unprocessable_entity }
      end
    end
  end


  # GET /incident_rsolr_searchequests/1/edit
  def edit
    @system = Mam::System.find(params[:id])
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
      format.xml { render :xml => @system }
    end
  end

  def get_data
    systems_scope = Mam::System.select_all.status_meaning
    systems,count = paginate(systems_scope)

    respond_to do |format|
      format.json  {render :json => to_jsonp(systems.to_grid_json([:system_name], count)) }
      format.html  {
        @count = count
        @datas = systems
      }
    end
  end

end
