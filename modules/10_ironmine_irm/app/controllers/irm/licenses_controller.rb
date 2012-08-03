class Irm::LicensesController < ApplicationController
  # GET /licenses
  # GET /licenses.xml
  def index
    @licenses = Irm::License.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @licenses }
    end
  end

  # GET /licenses/1
  # GET /licenses/1.xml
  def show
    @license = Irm::License.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @license }
    end
  end

  # GET /licenses/new
  # GET /licenses/new.xml
  def new
    @license = Irm::License.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @license }
    end
  end

  # GET /licenses/1/edit
  def edit
    @license = Irm::License.multilingual.find(params[:id])
  end

  # POST /licenses
  # POST /licenses.xml
  def create
    @license = Irm::License.new(params[:irm_license])

    respond_to do |format|
      if @license.valid?
        @license.create_from_function_ids(params[:functions])
        @license.save

        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @license, :status => :created, :location => @license }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @license.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /licenses/1
  # PUT /licenses/1.xml
  def update
    @license = Irm::License.find(params[:id])
    @license.attributes = params[:irm_license]
    respond_to do |format|
      if @license.valid?
        @license.create_from_function_ids(params[:functions])
        @license.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @license.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.xml
  def destroy
    @license = Irm::License.find(params[:id])
    @license.destroy

    respond_to do |format|
      format.html { redirect_to(licenses_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @license = Irm::License.find(params[:id])
  end

  def multilingual_update
    @license = Irm::License.find(params[:id])
    @license.not_auto_mult=true
    respond_to do |format|
      if @license.update_attributes(params[:irm_license])
        format.html { redirect_to({:action => "show"}, :notice => 'Irm::License was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @license.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    licenses_scope = Irm::License.multilingual
    licenses_scope = licenses_scope.match_value("license.name",params[:name])
    licenses,count = paginate(licenses_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(licenses.to_grid_json([:name,:description,:code],count))}
      format.html {
        @count = count
        @datas = licenses
      }
    end
  end
end
