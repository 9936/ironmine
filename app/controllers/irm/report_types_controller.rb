class Irm::ReportTypesController < ApplicationController
  # GET /report_types
  # GET /report_types.xml
  def index


    respond_to do |format|
      format.html # index.html.erb
      format.xml  {
        @report_types = Irm::ReportType.all
        render :xml => @report_types
      }
    end
  end

  # GET /report_types/1
  # GET /report_types/1.xml
  def show
    @report_type = Irm::ReportType.multilingual.with_bo(I18n.locale).with_category(I18n.locale).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report_type }
    end
  end

  # GET /report_types/new
  # GET /report_types/new.xml
  def new
    if params[:irm_report_type]
      session[:irm_report_type].merge!(params[:irm_report_type].symbolize_keys)
    else
      session[:irm_report_type]={:step=>1}
    end
    @report_type = Irm::ReportType.new(session[:irm_report_type])
    @report_type.step = @report_type.step.to_i if  @report_type.step.present?

    validate_result =  request.post?&&@report_type.valid?

    if validate_result
      if(params[:pre_step]&&@report_type.step.to_i>1)
        @report_type.step = @report_type.step.to_i-1
        session[:irm_report_type][:step] = @report_type.step
      else
        if @report_type.step<5
          @report_type.step = @report_type.step.to_i+1
          session[:irm_report_type][:step] = @report_type.step
        end
      end
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report_type }
    end
  end

  # GET /report_types/1/edit
  def edit
    @report_type = Irm::ReportType.multilingual.with_bo(I18n.locale).with_category(I18n.locale).find(params[:id])
  end

  # POST /report_types
  # POST /report_types.xml
  def create
    session[:irm_report_type].merge!(params[:irm_report_type].symbolize_keys)
    @report_type = Irm::ReportType.new(session[:irm_report_type])

    respond_to do |format|
      if @report_type.save
        @report_type.process_relationship
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report_type, :status => :created, :location => @report_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /report_types/1
  # PUT /report_types/1.xml
  def update
    @report_type = Irm::ReportType.find(params[:id])

    respond_to do |format|
      if @report_type.update_attributes(params[:irm_report_type])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /report_types/1
  # DELETE /report_types/1.xml
  def destroy
    @report_type = Irm::ReportType.find(params[:id])
    @report_type.destroy

    respond_to do |format|
      format.html { redirect_to(report_types_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @report_type = Irm::ReportType.find(params[:id])
  end

  def multilingual_update
    @report_type = Irm::ReportType.find(params[:id])
    @report_type.not_auto_mult=true
    respond_to do |format|
      if @report_type.update_attributes(params[:irm_report_type])
        format.html { redirect_to({:action => "show"}, :notice => 'Report type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    report_types_scope = Irm::ReportType.multilingual.with_bo(I18n.locale).with_category(I18n.locale)
    report_types_scope = report_types_scope.match_value("#{Irm::ReportTypesTl.table_name}.name",params[:name])
    report_types,count = paginate(report_types_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(report_types.to_grid_json([:name,:description,:category_name,:business_object_name,:created_at],count))}
    end
  end


  def edit_relation
    @report_type = Irm::ReportType.find(params[:id])
  end

  # PUT /report_types/1
  # PUT /report_types/1.xml
  def update_relation
    @report_type = Irm::ReportType.find(params[:id])
    @report_type.attributes = params[:irm_report_type]
    respond_to do |format|
      if @report_type.process_relationship

        format.html { redirect_to({:action => "show"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit_relation" }
        format.xml  { render :xml => @report_type.errors, :status => :unprocessable_entity }
      end
    end
  end
end
