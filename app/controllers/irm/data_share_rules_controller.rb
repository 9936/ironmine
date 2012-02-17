class Irm::DataShareRulesController < ApplicationController
  # GET /irm/data_share_rules
  # GET /irm/data_share_rules.xml
  def index
    @irm_data_share_rules = Irm::DataShareRule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @irm_data_share_rules }
    end
  end

  # GET /irm/data_share_rules/1
  # GET /irm/data_share_rules/1.xml
  def show
    @irm_data_share_rule = Irm::DataShareRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @irm_data_share_rule }
    end
  end

  # GET /irm/data_share_rules/new
  # GET /irm/data_share_rules/new.xml
  def new
    @irm_data_share_rule = Irm::DataShareRule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @irm_data_share_rule }
    end
  end

  # GET /irm/data_share_rules/1/edit
  def edit
    @irm_data_share_rule = Irm::DataShareRule.find(params[:id])
  end

  # POST /irm/data_share_rules
  # POST /irm/data_share_rules.xml
  def create
    @irm_data_share_rule = Irm::DataShareRule.new(params[:irm_data_share_rule])

    respond_to do |format|
      if @irm_data_share_rule.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @irm_data_share_rule, :status => :created, :location => @irm_data_share_rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @irm_data_share_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /irm/data_share_rules/1
  # PUT /irm/data_share_rules/1.xml
  def update
    @irm_data_share_rule = Irm::DataShareRule.find(params[:id])

    respond_to do |format|
      if @irm_data_share_rule.update_attributes(params[:irm_data_share_rule])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @irm_data_share_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /irm/data_share_rules/1
  # DELETE /irm/data_share_rules/1.xml
  def destroy
    @irm_data_share_rule = Irm::DataShareRule.find(params[:id])
    @irm_data_share_rule.destroy

    respond_to do |format|
      format.html { redirect_to(irm_data_share_rules_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @irm_data_share_rule = Irm::DataShareRule.find(params[:id])
  end

  def multilingual_update
    @irm_data_share_rule = Irm::DataShareRule.find(params[:id])
    @irm_data_share_rule.not_auto_mult=true
    respond_to do |format|
      if @irm_data_share_rule.update_attributes(params[:irm_data_share_rule])
        format.html { redirect_to({:action => "show"}, :notice => 'Data share rule was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @irm_data_share_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    irm_data_share_rules_scope = Irm::DataShareRule.multilingual
    irm_data_share_rules_scope = irm_data_share_rules_scope.match_value("irm_data_share_rule.name",params[:name])
    irm_data_share_rules,count = paginate(irm_data_share_rules_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(irm_data_share_rules.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
