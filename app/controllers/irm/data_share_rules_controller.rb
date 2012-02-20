class Irm::DataShareRulesController < ApplicationController
  # GET /irm/data_share_rules
  # GET /irm/data_share_rules.xml
  def index
    @data_share_rules = Irm::DataShareRule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @data_share_rules }
    end
  end

  # GET /irm/data_share_rules/1
  # GET /irm/data_share_rules/1.xml
  def show
    @data_share_rule = Irm::DataShareRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @data_share_rule }
    end
  end

  # GET /irm/data_share_rules/new
  # GET /irm/data_share_rules/new.xml
  def new
    @data_share_rule = Irm::DataShareRule.new
    @data_share_rule[:business_object_id]=params[:business_object_id]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @data_share_rule }
    end
  end

  # GET /irm/data_share_rules/1/edit
  def edit
    @data_share_rule = Irm::DataShareRule.multilingual.find(params[:id])
  end

  # POST /irm/data_share_rules
  # POST /irm/data_share_rules.xml
  def create
    @data_share_rule = Irm::DataShareRule.new(params[:irm_data_share_rule])

    respond_to do |format|
      if @data_share_rule.save
        format.html { redirect_to({:controller => "data_accesses",:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @data_share_rule, :status => :created, :location => @data_share_rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @data_share_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /irm/data_share_rules/1
  # PUT /irm/data_share_rules/1.xml
  def update
    @data_share_rule = Irm::DataShareRule.find(params[:id])

    respond_to do |format|
      if @data_share_rule.update_attributes(params[:irm_data_share_rule])
        format.html { redirect_to({:controller => "data_accesses",:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @data_share_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /irm/data_share_rules/1
  # DELETE /irm/data_share_rules/1.xml
  def destroy
    @data_share_rule = Irm::DataShareRule.find(params[:id])
    @data_share_rule.destroy

    respond_to do |format|
      format.html { redirect_to({:controller => "data_accesses",:action => "index"}, :notice => t(:successfully_deleted)) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @data_share_rule = Irm::DataShareRule.find(params[:id])
  end

  def multilingual_update
    @data_share_rule = Irm::DataShareRule.find(params[:id])
    @data_share_rule.not_auto_mult=true
    respond_to do |format|
      if @data_share_rule.update_attributes(params[:irm_data_share_rule])
        format.html { redirect_to({:action => "show"}, :notice => 'Data share rule was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @data_share_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data

    irm_data_share_rules_scope = Irm::DataShareRule.multilingual
    irm_data_share_rules_scope = irm_data_share_rules_scope.match_value("irm_data_share_rule.business_object_id",params[:business_object_id])
    irm_data_share_rules,count = paginate(irm_data_share_rules_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(irm_data_share_rules.to_grid_json([:source_id,:target_id,:access_level],count))}
    end
  end
  def get_option
     member_options= subject_values(params[:subject_type])

    respond_to do |format|
      format.json {render :json=>member_options.to_grid_json([:label,:value],member_options.count)}
    end
  end

  private
  def subject_values(subject_type)

    type_classes = Irm::BusinessObject.code_to_class_name(subject_type)

    values = []

    case  type_classes
      when Irm::Organization.name
        values =Irm::Organization.enabled.multilingual.collect{|i| {:label=>i[:name],:value=>i[:id],:id=>i[:id]}}
      when Irm::OrganizationExplosion.name
        values =Irm::Organization.enabled.multilingual.collect{|i| {:label=>i[:name],:value=>i[:id],:id=>i[:id]}}
      when Irm::Role.name
        values =Irm::Role.enabled.multilingual.collect{|i| {:label=>i[:name],:value=>i[:id],:id=>i[:id]}}
      when Irm::RoleExplosion.name
        values =Irm::Role.enabled.multilingual.collect{|i| {:label=>i[:name],:value=>i[:id],:id=>i[:id]}}
      when Irm::Group.name
        values =Irm::Group.enabled.multilingual.collect{|i| {:label=>i[:name],:value=>i[:id],:id=>i[:id]}}
      else
        values
    end


  end
end
