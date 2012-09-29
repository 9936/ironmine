class Irm::OauthAccessClientsController < ApplicationController
  # GET /oauth_access_clients
  # GET /oauth_access_clients.xml
  def index
    @oauth_access_clients = Irm::OauthAccessClient.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @oauth_access_clients }
    end
  end

  # GET /oauth_access_clients/1
  # GET /oauth_access_clients/1.xml
  def show
    @oauth_access_client = Irm::OauthAccessClient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @oauth_access_client }
    end
  end

  # GET /oauth_access_clients/new
  # GET /oauth_access_clients/new.xml
  def new
    @oauth_access_client = Irm::OauthAccessClient.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @oauth_access_client }
    end
  end

  # GET /oauth_access_clients/1/edit
  def edit
    @oauth_access_client = Irm::OauthAccessClient.find(params[:id])
  end

  # POST /oauth_access_clients
  # POST /oauth_access_clients.xml
  def create
    @oauth_access_client = Irm::OauthAccessClient.new(params[:irm_oauth_access_client])

    respond_to do |format|
      if @oauth_access_client.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @oauth_access_client, :status => :created, :location => @oauth_access_client }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @oauth_access_client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /oauth_access_clients/1
  # PUT /oauth_access_clients/1.xml
  def update
    @oauth_access_client = Irm::OauthAccessClient.find(params[:id])

    respond_to do |format|
      if @oauth_access_client.update_attributes(params[:irm_oauth_access_client])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @oauth_access_client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /oauth_access_clients/1
  # DELETE /oauth_access_clients/1.xml
  def destroy
    @oauth_access_client = Irm::OauthAccessClient.find(params[:id])
    @oauth_access_client.destroy

    respond_to do |format|
      format.html { redirect_to({:action => "index"}) }
      format.xml  { head :ok }
    end
  end

  def get_data
    oauth_access_clients_scope = Irm::OauthAccessClient
    oauth_access_clients_scope = oauth_access_clients_scope.match_value("#{Irm::OauthAccessClient.table_name}.name",params[:name])
    oauth_access_clients_scope = oauth_access_clients_scope.match_value("#{Irm::OauthAccessClient.table_name}.code",params[:code])
    oauth_access_clients_scope = oauth_access_clients_scope.match_value("#{Irm::OauthAccessClient.table_name}.description",params[:description])
    oauth_access_clients,count = paginate(oauth_access_clients_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(oauth_access_clients.to_grid_json([:name,:description,:code,:token],count))}
      format.html  {
        @count = count
        @datas = oauth_access_clients
      }
    end
  end
end
