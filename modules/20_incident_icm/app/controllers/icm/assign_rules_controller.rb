class Icm::AssignRulesController < ApplicationController
  # GET /assign_rules
  # GET /assign_rules.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /assign_rules/1
  # GET /assign_rules/1.xml
  def show
    @assign_rule = Icm::AssignRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assign_rule }
    end
  end

  # GET /assign_rules/new
  # GET /assign_rules/new.xml
  def new
    @assign_rule = Icm::AssignRule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assign_rule }
    end
  end

  # GET /assign_rules/1/edit
  def edit
    @assign_rule = Icm::AssignRule.find(params[:id])
  end

  # POST /assign_rules
  # POST /assign_rules.xml
  def create
    @assign_rule = Icm::AssignRule.new(params[:icm_assign_rule])
    @assign_rule.external_system_id = Irm::ExternalSystem.current_system.id

    #处理传递过来的事故单属性值
    if params[:custom_str].present?
      custom_str = {}
      params[:custom_str].each do |k,v|
        if k.present? and v.present?
          custom_str[k.to_sym] = v
        end
      end
      @assign_rule.custom_str = custom_str.to_s
    end

    respond_to do |format|
      if @assign_rule.save

        @assign_rule.create_assignment_from_str
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @assign_rule, :status => :created, :location => @assign_rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assign_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assign_rules/1
  # PUT /assign_rules/1.xml
  def update
    @assign_rule = Icm::AssignRule.find(params[:id])

    #处理传递过来的事故单属性值
    if params[:custom_str].present?
      custom_str = {}
      params[:custom_str].each do |k,v|
        if k.present? && v.present?
          custom_str[k.to_sym] = v
        end
      end
      @assign_rule.custom_str = custom_str.to_s
    end

    respond_to do |format|
      if @assign_rule.update_attributes(params[:icm_assign_rule])
        @assign_rule.create_assignment_from_str
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assign_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assign_rules/1
  # DELETE /assign_rules/1.xml
  def destroy
    @assign_rule = Icm::AssignRule.find(params[:id])
    @assign_rule.destroy
    Icm::AssignRule.update_all

    respond_to do |format|
      format.html { redirect_to(assign_rules_url) }
      format.xml  { head :ok }
    end
  end


  def switch_sequence
    sequence_str = params[:ordered_ids]
    if sequence_str.present?
      sequence = 0
      assign_rule_ids = sequence_str.split(",")
      assign_rules = Icm::AssignRule.where(:id => assign_rule_ids).index_by(&:id)
      assign_rule_ids.each do |id|
        assign_rule = assign_rules[id]
        assign_rule.sequence = sequence
        assign_rule.save
        sequence += 1
      end
    end
    respond_to do |format|
      format.json  {render :json => {:success => true}}
    end
  end

  def get_data
    if params[:status_code].eql?(Irm::Constant::DISABLED)
      assign_rules_scope = Icm::AssignRule.disabled.order_by_sequence.with_external_system(Irm::ExternalSystem.current_system.id)
    else
      assign_rules_scope = Icm::AssignRule.enabled.order_by_sequence.with_external_system(Irm::ExternalSystem.current_system.id)
    end
    assign_rules,count = paginate(assign_rules_scope)
    respond_to do |format|
      format.html  {
        @datas = assign_rules
        @count = count
      }
      format.json {render :json=>to_jsonp(assign_rules.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end

  #启用或者失效
  def switch_status_code
    assign_rule = Icm::AssignRule.find(params[:id])
    if assign_rule.status_code.eql?(Irm::Constant::DISABLED)
      assign_rule.status_code = Irm::Constant::ENABLED
      assign_rule.sequence = Icm::AssignRule.next_active_sequence
    else
      assign_rule.status_code = Irm::Constant::DISABLED
    end
    assign_rule.save
    respond_to do |format|
      format.html { redirect_to({:action => "index"}) }
      format.xml  { head :ok }
    end
  end
end
