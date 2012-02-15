class Irm::DataAccessesController < ApplicationController
  # GET /data_accesses
  # GET /data_accesses.xml
  def index

    Irm::DataAccess.prepare_for_opu
    @data_accesses = Irm::DataAccess.opu_data_access.list_all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @data_accesses }
    end
  end

  # GET /data_accesses/1
  # GET /data_accesses/1.xml
  def show
    @data_access = DataAccess.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @data_access }
    end
  end

  # GET /data_accesses/new
  # GET /data_accesses/new.xml
  def new
    @data_access = DataAccess.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @data_access }
    end
  end

  # GET /data_accesses/1/edit
  def edit
    @data_accesses = Irm::DataAccess.list_all
  end

  # POST /data_accesses
  # POST /data_accesses.xml
  def create
    @data_access = DataAccess.new(params[:data_access])

    respond_to do |format|
      if @data_access.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @data_access, :status => :created, :location => @data_access }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @data_access.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /data_accesses/1
  # PUT /data_accesses/1.xml
  def update
    access_levels = params[:access_levels]
    all_data_accesses =    {}
    Irm::DataAccess.opu_data_access.each do |data_access|
      all_data_accesses[data_access.business_object_id] =  data_access
    end
    access_levels.each do |business_object_id,access_level|
      if all_data_accesses[business_object_id]
        all_data_accesses[business_object_id].update_attribute(:access_level,access_level)
      end
    end

    respond_to do |format|
      format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      format.xml  { head :ok }
    end
  end

  # DELETE /data_accesses/1
  # DELETE /data_accesses/1.xml
  def destroy
    @data_access = DataAccess.find(params[:id])
    @data_access.destroy

    respond_to do |format|
      format.html { redirect_to(data_accesses_url) }
      format.xml  { head :ok }
    end
  end

  def get_data
    data_accesses_scope = DataAccess.multilingual
    data_accesses_scope = data_accesses_scope.match_value("data_access.name",params[:name])
    data_accesses,count = paginate(data_accesses_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(data_accesses.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
