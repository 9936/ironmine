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

    respond_to do |format|
      format.html { redirect_to(assign_rules_url) }
      format.xml  { head :ok }
    end
  end

  def up_rule
    return_url = params[:return_url]
    current_rule = Icm::AssignRule.find(params[:id])
    if current_rule.present?
      pre_rule = current_rule.pre_rule
      tmp_sequence = current_rule.sequence
      current_rule.sequence = pre_rule.sequence
      pre_rule.sequence = tmp_sequence
      current_rule.save
      pre_rule.save
    end
    if return_url.blank?
      redirect_to({:action => "index"})
    else
      redirect_to(return_url)
    end
  end

  def down_rule
    return_url = params[:return_url]
    current_rule = Icm::AssignRule.find(params[:id])
    if current_rule.present?
      next_rule = current_rule.next_rule
      tmp_sequence = current_rule.sequence
      current_rule.sequence = next_rule.sequence
      next_rule.sequence = tmp_sequence
      current_rule.save
      next_rule.save
    end
    if return_url.blank?
      redirect_to({:action => "index"})
    else
      redirect_to(return_url)
    end
  end

  def get_data
    assign_rules_scope = Icm::AssignRule.order_by_sequence
    #assign_rules_scope = assign_rules_scope.match_value("assign_rule.name",params[:name])
    assign_rules,count = paginate(assign_rules_scope)
    respond_to do |format|
      format.html  {
        @datas = assign_rules
        @count = count
      }
      format.json {render :json=>to_jsonp(assign_rules.to_grid_json([:name,:description,:status_meaning],count))}
    end
  end
end
