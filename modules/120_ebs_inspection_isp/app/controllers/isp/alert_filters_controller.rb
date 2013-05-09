class Isp::AlertFiltersController < ApplicationController
  def show
    @alert_filter = Isp::AlertFilter.with_operation_meaning.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @alert_filter }
    end
  end

  # GET /alert_filters/new
  # GET /alert_filters/new.xml
  def new
    @alert_filter = Isp::AlertFilter.new(:check_item_id => params[:check_item_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @alert_filter }
    end
  end

  # GET /alert_filters/1/edit
  def edit
    @alert_filter = Isp::AlertFilter.find(params[:id])
  end

  # POST /alert_filters
  # POST /alert_filters.xml
  def create
    @alert_filter = Isp::AlertFilter.new(params[:isp_alert_filter])

    respond_to do |format|
      if @alert_filter.save
        check_item = @alert_filter.check_item
        format.html { redirect_to({:controller => "isp/check_items", :action => "show", :id => check_item.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @alert_filter, :status => :created, :location => @alert_filter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @alert_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_operator_data
    operators = Irm::LookupValue.query_by_lookup_type("RULE_FILTER_OPERATOR").multilingual.order_id
    available_operators = []
    if params[:result_type].eql?("NUMBER")
      codes = ["E", "G", "L"]
    else
      codes = ["E", "N"]
    end
    operators.each do |operator|
      if codes.include?(operator[:lookup_code].to_s)
        available_operators << {:label=> operator[:meaning], :value=>operator[:lookup_code],:id=> operator[:lookup_code]}
      end
    end
    respond_to do |format|
      format.json {render :json=> available_operators.to_grid_json([:label, :value],available_operators.count)}
    end
  end

  # PUT /alert_filters/1
  # PUT /alert_filters/1.xml
  def update
    @alert_filter = Isp::AlertFilter.find(params[:id])

    respond_to do |format|
      if @alert_filter.update_attributes(params[:isp_alert_filter])
        check_item = @alert_filter.check_item
        format.html { redirect_to({:controller => "isp/check_items", :action => "show", :id => check_item.id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alert_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /alert_filters/1
  # DELETE /alert_filters/1.xml
  def destroy
    @alert_filter = Isp::AlertFilter.find(params[:id])
    @alert_filter.destroy

    respond_to do |format|
      check_item = @alert_filter.check_item
      format.html { redirect_to({:controller => "isp/check_items", :action => "show", :id => check_item.id}) }
      format.xml  { head :ok }
    end
  end


  def get_data
    alert_filters_scope = Isp::AlertFilter.with_operation_meaning.with_check_item(params[:check_item_id])
    alert_filters,count = paginate(alert_filters_scope)
    respond_to do |format|
      format.html  {
        @datas = alert_filters
        @count = count
      }
      format.json {render :json=>to_jsonp(check_item_alert_filters.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
