class Ccc::ConsultantModulesController < ApplicationController
  layout "uid"
  # GET /industries
  # GET /industries.xml
  def index
    @consultantModules = Ccc::ConsultantModule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultantModules }
    end
  end

  def show

    @consultantModule = Ccc::ConsultantModule.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultantModule }
    end
  end

  # GET /industries/new
  # GET /industries/new.xml
  def new
    @consultantModule = Ccc::ConsultantModule.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consultantModule }
    end
  end

  # GET /industries/1/edit
  def edit
    @consultantModule = Ccc::ConsultantModule.multilingual.find(params[:id])
  end

  # POST /industries
  # POST /industries.xml
  def create
    @consultantModule = Ccc::ConsultantModule.new(params[:ccc_consultant_module])
    respond_to do |format|
      if @consultantModule.valid? && @consultantModule.save
        format.html { redirect_to({:action => "show", :id => @consultantModule}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @consultantModule, :status => :created, :location => @consultantModule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultantModule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /industries/1
  # PUT /industries/1.xml
  def update
    @consultantModule = Ccc::ConsultantModule.find(params[:id])

    respond_to do |format|
      if @consultantModule.update_attributes(params[:ccc_consultant_module])
        format.html { redirect_to({:action=>"show", :id=>@consultantModule.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@consultantModule}
      else
        @error = @consultantModule
        format.html { render "edit" }
        format.xml  { render :xml => @consultantModule.errors, :status => :unprocessable_entity }
        format.json  { render :json => @consultantModule.errors}
      end
    end
  end


  def get_data
    industries_scope = Ccc::ConsultantModule.multilingual
    industries_scope = industries_scope.match_value("#{Ccc::ConsultantModule.table_name}.code",params[:code])
    industries_scope = industries_scope.match_value("#{Ccc::ConsultantModulesTl.table_name}.name",params[:name])
    industries_scope = industries_scope.match_value("#{Ccc::ConsultantModulesTl.table_name}.description",params[:description])
    industries,count = paginate(industries_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(industries.to_grid_json([:name,:description,:code],count))}
      format.html  {
        @count = count
        @datas = industries
      }
    end
  end

  def multilingual_edit
    @consultantModule = Ccc::ConsultantModule.find(params[:id])
  end

  def multilingual_update
    @consultantModule = Ccc::ConsultantModule.find(params[:id])
    @consultantModule.not_auto_mult=true
    respond_to do |format|
      if @consultantModule.update_attributes(params[:ccc_consultant_module])
        format.html { redirect_to({:action => "show"}, :notice => 'consultantModule was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultantModule.errors, :status => :unprocessable_entity }
      end
    end
  end
end
