class Irm::CloudOperationsController < ApplicationController
  # GET /operation_units
  # GET /operation_units.xml
  def index
    @operation_units = Irm::OperationUnit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @operation_units }
    end
  end

  # GET /operation_units/1
  # GET /operation_units/1.xml
  def show
    @operation_unit = Irm::OperationUnit.multilingual.with_default_zone(I18n.locale).with_language(I18n.locale).with_license(I18n.locale).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @operation_unit }
    end
  end

  # GET /operation_units/new
  # GET /operation_units/new.xml
  def new
    @operation_unit = Irm::OperationUnit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @operation_unit }
    end
  end

  # GET /operation_units/1/edit
  def edit
    @operation_unit = Irm::OperationUnit.multilingual.find(params[:id])
  end

  # POST /operation_units
  # POST /operation_units.xml
  def create
    @operation_unit = Irm::OperationUnit.new(params[:irm_operation_unit])

    respond_to do |format|
      if @operation_unit.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @operation_unit, :status => :created, :location => @operation_unit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @operation_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /operation_units/1
  # PUT /operation_units/1.xml
  def update
    @operation_unit = Irm::OperationUnit.multilingual.find(params[:id])

    respond_to do |format|
      if @operation_unit.update_attributes(params[:irm_operation_unit])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @operation_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /operation_units/1
  # DELETE /operation_units/1.xml
  def destroy
    @operation_unit = Irm::OperationUnit.find(params[:id])
    @operation_unit.destroy

    respond_to do |format|
      format.html { redirect_to(operation_units_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    operation_units_scope = Irm::OperationUnit.multilingual.with_license(I18n.locale)
    operation_units_scope = operation_units_scope.match_value("#{Irm::OperationUnit.table_name}.name",params[:name])
    operation_units,count = paginate(operation_units_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(operation_units.to_grid_json([:name,:short_name,:description,:license_name],count))}
      format.html {
        @count = count
        @datas = operation_units
      }
    end
  end
end
