class Emw::EbsModulesController < ApplicationController
  layout "application_full"

  # GET /ebs_modules
  # GET /ebs_modules.xml
  def index
    @ebs_modules = Emw::EbsModule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ebs_modules }
    end
  end

  # GET /ebs_modules/1
  # GET /ebs_modules/1.xml
  def show
    @ebs_module = Emw::EbsModule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ebs_module }
    end
  end

  # GET /ebs_modules/new
  # GET /ebs_modules/new.xml
  def new
    @ebs_module = Emw::EbsModule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ebs_module }
    end
  end

  # GET /ebs_modules/1/edit
  def edit
    @ebs_module = Emw::EbsModule.find(params[:id])
  end

  # POST /ebs_modules
  # POST /ebs_modules.xml
  def create
    @ebs_module = Emw::EbsModule.new(params[:emw_ebs_module])

    respond_to do |format|
      if @ebs_module.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @ebs_module, :status => :created, :location => @ebs_module }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ebs_module.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ebs_modules/1
  # PUT /ebs_modules/1.xml
  def update
    @ebs_module = Emw::EbsModule.find(params[:id])

    respond_to do |format|
      if @ebs_module.update_attributes(params[:emw_ebs_module])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ebs_module.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ebs_modules/1
  # DELETE /ebs_modules/1.xml
  def destroy
    @ebs_module = Emw::EbsModule.find(params[:id])
    @ebs_module.destroy

    respond_to do |format|
      format.html { redirect_to(ebs_modules_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    ebs_modules_scope = Emw::EbsModule
    ebs_modules_scope = ebs_modules_scope.match_value("#{Emw::EbsModule.table_name}.name", params[:name])
    ebs_modules,count = paginate(ebs_modules_scope)
    respond_to do |format|
      format.html  {
        @datas = ebs_modules
        @count = count
      }
      format.json {render :json=>to_jsonp(ebs_modules.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
