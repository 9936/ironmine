class Irm::OperationUnitsController < ApplicationController
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
    @operation_unit = Irm::OperationUnit.multilingual.with_default_zone(I18n.locale).with_language(I18n.locale).with_license(I18n.locale).find(Irm::OperationUnit.current.id)

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
    @operation_unit = Irm::OperationUnit.multilingual.with_license(I18n.locale).find(Irm::OperationUnit.current.id)
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
    @operation_unit = Irm::OperationUnit.current

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

  def multilingual_edit
    @operation_unit = Irm::OperationUnit.find(params[:id])
  end

  def multilingual_update
    @operation_unit = Irm::OperationUnit.find(params[:id])
    @operation_unit.not_auto_mult=true
    respond_to do |format|
      if @operation_unit.update_attributes(params[:irm_operation_unit])
        format.html { redirect_to({:action => "show"}, :notice => 'Operation unit was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @operation_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    operation_units_scope = Irm::OperationUnit.multilingual
    operation_units_scope = operation_units_scope.match_value("operation_unit.name",params[:name])
    operation_units,count = paginate(operation_units_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(operation_units.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
