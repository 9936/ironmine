class Irm::WfApprovalProcessesController < ApplicationController
  # GET /wf_approval_processes
  # GET /wf_approval_processes.xml
  def index
    if params[:bo_code]
      session[:bo_code] = params[:bo_code]
      @bo_code = params[:bo_code]
    else
      first_approval_bo = Irm::BusinessObject.enabled.multilingual.where(:workflow_flag=>Irm::Constant::SYS_YES).first
      @bo_code = session[:bo_code]||first_approval_bo.business_object_code if first_approval_bo
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wf_approval_processes }
    end
  end

  # GET /wf_approval_processes/1
  # GET /wf_approval_processes/1.xml
  def show
    @wf_approval_process = Irm::WfApprovalProcess.list_all.find(params[:id])
    @rule_filter = Irm::RuleFilter.query_by_source(Irm::WfApprovalProcess.name,@wf_approval_process.id).first

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wf_approval_process }
    end
  end

  # GET /wf_approval_processes/new
  # GET /wf_approval_processes/new.xml
  def new
    if params[:irm_wf_approval_process]
      session[:irm_wf_approval_process].merge!(params[:irm_wf_approval_process].symbolize_keys)
    else
      session[:irm_wf_approval_process]={:bo_code=>params[:bo_code],:step=>1}
      session[:irm_rule_filter]=nil
    end
    @wf_approval_process = Irm::WfApprovalProcess.new(session[:irm_wf_approval_process])
    @wf_approval_process.step = @wf_approval_process.step.to_i if  @wf_approval_process.step.present?
    unless  @wf_approval_process.bo_code.present?
      redirect_to({:action => "index"})
      return
    end

    validate_result =  request.post?&&@wf_approval_process.valid?
    # validate filter
    if request.post?&&@wf_approval_process.step.eql?(2)
      session[:irm_rule_filter] = params[:irm_rule_filter]
      @rule_filter = Irm::RuleFilter.new(session[:irm_rule_filter])
      validate_result = validate_result&&@rule_filter.valid?
    end

    if validate_result
      if(params[:pre_step])
        @wf_approval_process.step = @wf_approval_process.step.to_i-1
        session[:irm_wf_approval_process][:step] = @wf_approval_process.step
      else
        if @wf_approval_process.step<5
          @wf_approval_process.step = @wf_approval_process.step.to_i+1
          session[:irm_wf_approval_process][:step] = @wf_approval_process.step
        end
      end
    end

    #prepare step 2
    if validate_result&&@wf_approval_process.step.eql?(2)
      if session[:irm_rule_filter]
        @rule_filter =Irm::RuleFilter.new(session[:irm_rule_filter])
      else
        @rule_filter =Irm::RuleFilter.create_for_source(@wf_approval_process.bo_code,Irm::WfApprovalProcess.name,0)
      end
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wf_approval_process }
    end
  end

  # GET /wf_approval_processes/1/edit
  def edit
    @wf_approval_process = Irm::WfApprovalProcess.find(params[:id])
    if params[:irm_wf_approval_process]
      session[:irm_wf_approval_process].merge!(params[:irm_wf_approval_process].symbolize_keys)
    else
      session[:irm_wf_approval_process]={:step=>1}
      session[:irm_rule_filter]=nil
    end

    @wf_approval_process.attributes = session[:irm_wf_approval_process]
    @wf_approval_process.step =  @wf_approval_process.step.to_i if @wf_approval_process.step

    validate_result =  request.put?&&@wf_approval_process.valid?
    # validate filter
    if request.put?&&@wf_approval_process.step.eql?(2)
      session[:irm_rule_filter] = params[:irm_rule_filter]
      @rule_filter = Irm::RuleFilter.query_by_source(Irm::WfApprovalProcess.name,@wf_approval_process.id).first
      @rule_filter.attributes = session[:irm_rule_filter]
      validate_result = validate_result&&@rule_filter.valid?
    end

    if validate_result
      if(params[:pre_step])
        @wf_approval_process.step = @wf_approval_process.step.to_i-1
        session[:irm_wf_approval_process][:step] = @wf_approval_process.step
      else
        if @wf_approval_process.step<5
          @wf_approval_process.step = @wf_approval_process.step.to_i+1
          session[:irm_wf_approval_process][:step] = @wf_approval_process.step
        end
      end
    end

    #prepare step 2
    if validate_result&&@wf_approval_process.step.eql?(2)
      if session[:irm_rule_filter]
        @rule_filter = Irm::RuleFilter.query_by_source(Irm::WfApprovalProcess.name,@wf_approval_process.id).first
        @rule_filter.attributes = session[:irm_rule_filter]
      else
        @rule_filter = Irm::RuleFilter.query_by_source(Irm::WfApprovalProcess.name,@wf_approval_process.id).first
      end
    end

  end

  # POST /wf_approval_processes
  # POST /wf_approval_processes.xml
  def create
    session[:irm_wf_approval_process].merge!(params[:irm_wf_approval_process].symbolize_keys)
    @wf_approval_process = Irm::WfApprovalProcess.new(session[:irm_wf_approval_process])
    @rule_filter =Irm::RuleFilter.new(session[:irm_rule_filter])

    respond_to do |format|
      if @wf_approval_process.valid?&&@rule_filter.valid?
         @wf_approval_process.create_submitter_from_str
         @wf_approval_process.save
         @rule_filter.source_id = @wf_approval_process.id
         @rule_filter.save
         session[:irm_rule_filter] = nil
         session[:irm_wf_approval_process] = nil
        format.html { redirect_to({:action => "show",:id=>@wf_approval_process.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @wf_approval_process, :status => :created, :location => @wf_rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wf_approval_process.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wf_approval_processes/1
  # PUT /wf_approval_processes/1.xml
  def update
    session[:irm_wf_approval_process].merge!(params[:irm_wf_approval_process].symbolize_keys)
    @wf_approval_process = Irm::WfApprovalProcess.find(params[:id])
    @wf_approval_process.attributes = session[:irm_wf_approval_process]

    @rule_filter = Irm::RuleFilter.query_by_source(Irm::WfApprovalProcess.name,@wf_approval_process.id).first
    @rule_filter.attributes = session[:irm_rule_filter]

    respond_to do |format|
      if @wf_approval_process.valid?&&@rule_filter.valid?
        @wf_approval_process.create_submitter_from_str
        @wf_approval_process.save
        @rule_filter.save
        session[:irm_rule_filter] = nil
        session[:irm_wf_approval_process] = nil
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wf_approval_process.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wf_approval_processes/1
  # DELETE /wf_approval_processes/1.xml
  def destroy
    @wf_approval_process = Irm::WfApprovalProcess.find(params[:id])
    @wf_approval_process.delete_self

    respond_to do |format|
      format.html { redirect_back_or_default({:action=>"index"}) }
      format.xml  { head :ok }
    end
  end


  def destroy_action
    @wf_approval_action = Irm::WfApprovalAction.find(params[:id])
    process_id =  @wf_approval_action.process_id
    @wf_approval_action.destroy

    respond_to do |format|
      format.html { redirect_back_or_default({:action=>"show",:id=>process_id})}
      format.xml  { head :ok }
    end
  end


  def add_exists_action
    source_info = params[:source_str].split(",")
    @source = source_info
  end

  def save_exists_action
    source_info = params[:source_str].split(",")
    selected_actions = params[:selected_actions].split(",")
    exists_actions = Irm::WfApprovalAction.where(:action_mode=>source_info[0],:process_id=>source_info[1],:step_id=>source_info[2])
    exists_actions.each do |action|
      if selected_actions.include?("#{action.action_type}##{action.action_id}")
        selected_actions.delete("#{action.action_type}##{action.action_id}")
      else
        action.destroy
      end
    end

    selected_actions.each do |action_str|
      next unless action_str.strip.present?
      action = action_str.strip.split("#")
      Irm::WfApprovalAction.create(:action_mode=>source_info[0],
                               :process_id=>source_info[1],
                               :step_id=>source_info[2],
                               :action_type=>Irm::BusinessObject.code_to_class_name(action[0]),
                               :action_id=>action[1])
    end if selected_actions.any?

    respond_to do |format|
      format.html { redirect_back_or_default({:action=>"show",:id=>params[:id]}) }
      format.xml  { head :ok }
    end
  end

  def active
    @wf_approval_process = Irm::WfApprovalProcess.find(params[:id])
    if(Irm::Constant::SYS_YES.eql?(params[:active]))
      @wf_approval_process.change_active(true)
    else
      @wf_approval_process.change_active(false)
    end

    respond_to do |format|
        format.html { redirect_back_or_default({:action=>"show",:id=>@wf_approval_process.id}) }
        format.xml  { head :ok }
    end
  end

  def reorder
    sequence_str = params[:ordered_ids]
    if sequence_str.present?
      sequence = 0
      ids = sequence_str.split(",")
      values = Irm::WfApprovalProcess.where(:id => ids).index_by(&:id)
      ids.each do |id|
        value = values[id]
        value.process_order = sequence
        value.save
        sequence += 1
      end
    end
    respond_to do |format|
      format.json  {render :json => {:success => true}}
    end
  end

  def get_data_by_action
    wf_approval_processes_scope = Irm::WfApprovalProcess.select_all.with_bo(I18n.locale).query_by_action(params[:action_type],params[:action_id])
    wf_approval_processes_scope = wf_approval_processes_scope.match_value("#{Irm::WfApprovalProcess.table_name}.name",params[:name])
    wf_approval_processes_scope = wf_approval_processes_scope.match_value("#{Irm::WfApprovalProcess.table_name}.description",params[:description])
    wf_approval_processes,count = paginate(wf_approval_processes_scope)
    respond_to do |format|
      format.json  {render :json => to_jsonp(wf_approval_processes.to_grid_json([:name,:description,:status_code,:bo_name], count)) }
      format.html  {
        @datas =  wf_approval_processes
        @count = count
      }
    end
  end

  def get_active_processes
    bo_code = params[:bo_code]
    @datas = Irm::WfApprovalProcess.where(:bo_code=>bo_code).enabled.order("process_order")
    @count = @datas.count
  end

end
