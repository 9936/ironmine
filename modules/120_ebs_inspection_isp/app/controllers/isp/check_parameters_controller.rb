class Isp::CheckParametersController < ApplicationController
  # GET /isp/check_parameters/1
  # GET /isp/check_parameters/1.xml
  def show
    @isp_check_parameter = Isp::CheckParameter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @isp_check_parameter }
    end
  end

  # GET /isp/check_parameters/new
  # GET /isp/check_parameters/new.xml
  def new
    @isp_check_parameter = Isp::CheckParameter.new(:check_item_id => params[:check_item_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @isp_check_parameter }
    end
  end

  # GET /isp/check_parameters/1/edit
  def edit
    @isp_check_parameter = Isp::CheckParameter.find(params[:id])
  end

  # POST /isp/check_parameters
  # POST /isp/check_parameters.xml
  def create
    @isp_check_parameter = Isp::CheckParameter.new(params[:isp_check_parameter])

    respond_to do |format|
      if @isp_check_parameter.save
        format.html { redirect_to({:controller => "isp/check_items", :id => @isp_check_parameter.check_item_id, :action => "show"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @isp_check_parameter, :status => :created, :location => @isp_check_parameter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @isp_check_parameter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /isp/check_parameters/1
  # PUT /isp/check_parameters/1.xml
  def update
    @isp_check_parameter = Isp::CheckParameter.find(params[:id])

    respond_to do |format|
      if @isp_check_parameter.update_attributes(params[:isp_check_parameter])
        format.html { redirect_to({:controller => "isp/check_items", :id => @isp_check_parameter.check_item_id, :action => "show"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @isp_check_parameter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /isp/check_parameters/1
  # DELETE /isp/check_parameters/1.xml
  def destroy
    @isp_check_parameter = Isp::CheckParameter.find(params[:id])
    @isp_check_parameter.destroy

    respond_to do |format|
      format.html { redirect_to({:controller => "isp/programs", :id => @isp_check_parameter.program_id, :action => "show"}) }
      format.xml  { head :ok }
    end
  end

  def get_data
    isp_check_parameters_scope = Isp::CheckParameter.with_check_item(params[:check_item_id])
    isp_check_parameters_scope = isp_check_parameters_scope.match_value("#{Isp::CheckParameter.table_name}.name",params[:name])
    isp_check_parameters,count = paginate(isp_check_parameters_scope)
    respond_to do |format|
      format.html  {
        @datas = isp_check_parameters
        @count = count
      }
      format.json {render :json=>to_jsonp(isp_check_parameters.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
