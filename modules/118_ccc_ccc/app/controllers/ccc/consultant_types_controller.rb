class Ccc::ConsultantTypesController < ApplicationController
  layout "uid"
  # GET /industries
  # GET /industries.xml
  def index
    @consultantTypes = Ccc::ConsultantType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultantTypes }
    end
  end

  def show

    @consultantType = Ccc::ConsultantType.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultantType }
    end
  end

  # GET /industries/new
  # GET /industries/new.xml
  def new
    @consultantType = Ccc::ConsultantType.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consultantType }
    end
  end

  # GET /industries/1/edit
  def edit
    @consultantType = Ccc::ConsultantType.multilingual.find(params[:id])
  end

  # POST /industries
  # POST /industries.xml
  def create
    @consultantType = Ccc::ConsultantType.new(params[:ccc_consultant_type])
    respond_to do |format|
      if @consultantType.valid? && @consultantType.save
        format.html { redirect_to({:action => "show", :id => @consultantType}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @consultantType, :status => :created, :location => @consultantType }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultantType.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /industries/1
  # PUT /industries/1.xml
  def update
    @consultantType = Ccc::ConsultantType.find(params[:id])

    respond_to do |format|
      if @consultantType.update_attributes(params[:ccc_consultant_type])
        format.html { redirect_to({:action=>"show", :id=>@consultantType.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@consultantType}
      else
        @error = @consultantType
        format.html { render "edit" }
        format.xml  { render :xml => @consultantType.errors, :status => :unprocessable_entity }
        format.json  { render :json => @consultantType.errors}
      end
    end
  end


  def get_data
    industries_scope = Ccc::ConsultantType.multilingual
    industries_scope = industries_scope.match_value("#{Ccc::ConsultantType.table_name}.code",params[:code])
    industries_scope = industries_scope.match_value("#{Ccc::ConsultantTypesTl.table_name}.name",params[:name])
    industries_scope = industries_scope.match_value("#{Ccc::ConsultantTypesTl.table_name}.description",params[:description])
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
    @consultantType = Ccc::ConsultantType.find(params[:id])
  end

  def multilingual_update
    @consultantType = Ccc::ConsultantType.find(params[:id])
    @consultantType.not_auto_mult=true
    respond_to do |format|
      if @consultantType.update_attributes(params[:ccc_consultant_type])
        format.html { redirect_to({:action => "show"}, :notice => 'consultantType was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultantType.errors, :status => :unprocessable_entity }
      end
    end
  end
end
