class Ccc::ConsultantStatusesController < ApplicationController
  layout "uid"
  # GET /industries
  # GET /industries.xml
  def index
    @consultantStatuses = Ccc::ConsultantStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultantStatuses }
    end
  end

  def show

    @consultantStatus = Ccc::ConsultantStatus.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultantStatus }
    end
  end

  # GET /industries/new
  # GET /industries/new.xml
  def new
    @consultantStatus = Ccc::ConsultantStatus.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consultantStatus }
    end
  end

  # GET /industries/1/edit
  def edit
    @consultantStatus = Ccc::ConsultantStatus.multilingual.find(params[:id])
  end

  # POST /industries
  # POST /industries.xml
  def create
    @consultantStatus = Ccc::ConsultantStatus.new(params[:ccc_consultant_status])
    respond_to do |format|
      if @consultantStatus.valid? && @consultantStatus.save
        format.html { redirect_to({:action => "show", :id => @consultantStatus}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @consultantStatus, :status => :created, :location => @consultantStatus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultantStatus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /industries/1
  # PUT /industries/1.xml
  def update
    @consultantStatus = Ccc::ConsultantStatus.find(params[:id])

    respond_to do |format|
      if @consultantStatus.update_attributes(params[:ccc_consultant_status])
        format.html { redirect_to({:action=>"show", :id=>@consultantStatus.id},:notice => (t :successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@consultantStatus}
      else
        @error = @consultantStatus
        format.html { render "edit" }
        format.xml  { render :xml => @consultantStatus.errors, :status => :unprocessable_entity }
        format.json  { render :json => @consultantStatus.errors}
      end
    end
  end


  def get_data
    industries_scope = Ccc::ConsultantStatus.multilingual
    industries_scope = industries_scope.match_value("#{Ccc::ConsultantStatus.table_name}.code",params[:code])
    industries_scope = industries_scope.match_value("#{Ccc::ConsultantStatusesTl.table_name}.name",params[:name])
    industries_scope = industries_scope.match_value("#{Ccc::ConsultantStatusesTl.table_name}.description",params[:description])
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
    @consultantStatus = Ccc::ConsultantStatus.find(params[:id])
  end

  def multilingual_update
    @consultantStatus = Ccc::ConsultantStatus.find(params[:id])
    @consultantStatus.not_auto_mult=true
    respond_to do |format|
      if @consultantStatus.update_attributes(params[:ccc_consultant_status])
        format.html { redirect_to({:action => "show"}, :notice => 'consultantStatus was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultantStatus.errors, :status => :unprocessable_entity }
      end
    end
  end
end
