class Emw::DatabasesController < ApplicationController
  layout "application_full"
  # GET /emw/databases
  # GET /emw/databases.xml
  def index
    @emw_databases = Emw::Database.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emw_databases }
    end
  end

  # GET /emw/databases/1
  # GET /emw/databases/1.xml
  def show
    @emw_database = Emw::Database.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @emw_database }
    end
  end

  # GET /emw/databases/new
  # GET /emw/databases/new.xml
  def new
    @emw_database = Emw::Database.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @emw_database }
    end
  end

  # GET /emw/databases/1/edit
  def edit
    @emw_database = Emw::Database.find(params[:id])
  end

  # POST /emw/databases
  # POST /emw/databases.xml
  def create
    @emw_database = Emw::Database.new(params[:emw_database])

    respond_to do |format|
      if @emw_database.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @emw_database, :status => :created, :location => @emw_database }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @emw_database.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emw/databases/1
  # PUT /emw/databases/1.xml
  def update
    @emw_database = Emw::Database.find(params[:id])

    respond_to do |format|
      if @emw_database.update_attributes(params[:emw_database])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @emw_database.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    emw_databases_scope = Emw::Database
    emw_databases_scope = emw_databases_scope.match_value("#{Emw::Database.table_name}.name",params[:name])
    emw_databases,count = paginate(emw_databases_scope)
    respond_to do |format|
      format.html  {
        @datas = emw_databases
        @count = count
      }
      format.json {render :json=>to_jsonp(emw_databases.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
